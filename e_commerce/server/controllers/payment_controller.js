// import { Order } from "../models/order_model.js";
// import { User } from "../models/user_model.js";
// import { createPaymobIntention } from "../utils/paymob_service.js";

// export const createPayment = async (req, res) => {
//   try {
//     const { orderId } = req.params;

//     // Get the order
//     const order = await Order.findById(orderId)
//       .populate("user")
//       .populate("products.product")
//       .populate("products.variant");

//     if (!order) {
//       return res.status(404).json({
//         status: "Failed",
//         message: "Order not found",
//       });
//     }

//     // Make sure the order belongs to the logged-in user
//     if (order.user._id.toString() !== req.user.id) {
//       return res.status(403).json({
//         status: "Failed",
//         message: "You are not allowed to pay for this order",
//       });
//     }

//     // Don't pay twice
//     if (order.paymentStatus === "paid") {
//       return res.status(400).json({
//         status: "Failed",
//         message: "Order is already paid",
//       });
//     }

//     // Make sure this order is supposed to use Paymob/card
//     if (order.paymentMethod !== "card") {
//       return res.status(400).json({
//         status: "Failed",
//         message: "This order is not a card payment",
//       });
//     }

//     /*
//      * Paymob expects amounts in the smallest currency unit.
//      *
//      * Example:
//      * 100 EGP -> 10000
//      */
//     const amount = Math.round(order.totalPrice * 100);

//     /*
//      * Create Paymob items from YOUR order structure.
//      *
//      * Your structure:
//      *
//      * products: [
//      *   {
//      *     product,
//      *     variant,
//      *     quantity,
//      *     price
//      *   }
//      * ]
//      */
//     const items = order.products.map((item) => ({
//       name: item.product.name,

//       amount: Math.round(item.price * 100),

//       description: item.product.name,

//       quantity: item.quantity,
//     }));

//     // Create Paymob intention
//     const intention = await createPaymobIntention({
//       amount,
//       orderId: order._id.toString(),
//       user: order.user,
//       order,
//       items,
//     });

//     /*
//      * Unified Checkout URL
//      */
//     const checkoutUrl =
//       `${process.env.PAYMOB_API_URL}/unifiedcheckout/` +
//       `?publicKey=${process.env.PAYMOB_PUBLIC_KEY}` +
//       `&clientSecret=${intention.client_secret}`;

//     return res.status(200).json({
//       status: "Success",

//       data: {
//         checkoutUrl,
//         clientSecret: intention.client_secret,
//       },
//     });
//   } catch (error) {
//     console.error(error);

//     return res.status(500).json({
//       status: "Failed",
//       message: "Could not create payment",
//     });
//   }
// };
import { PaymentSession } from "../models/payment_session_model.js";
import { Variant } from "../models/product_variants_model.js";
import { User } from "../models/user_model.js";

import {
  createPaymobIntention,
} from "../utils/paymob_service.js";


/*
 * ============================================================
 * CREATE PAYMENT SESSION
 * ============================================================
 *
 * IMPORTANT:
 *
 * This function DOES NOT create an Order.
 *
 * It creates a temporary PaymentSession.
 *
 * Flow:
 *
 * Flutter
 *   ↓
 * POST /payments/create-session
 *   ↓
 * Validate products
 *   ↓
 * Calculate real price
 *   ↓
 * Create PaymentSession
 *   ↓
 * Create Paymob intention
 *   ↓
 * Return checkout URL
 *
 * The Order will only be created by the webhook
 * after Paymob confirms successful payment.
 */
export const createPaymentSession = async (
  req,
  res,
) => {
  try {
    /*
     * The authentication middleware already put the user
     * inside req.user.
     */
    const userId = req.user.id;

    /*
     * We only need products and shippingAddress.
     *
     * totalPrice from Flutter is intentionally ignored.
     *
     * WHY:
     *
     * A malicious client could send:
     *
     * totalPrice: 1
     *
     * while the actual cart is worth 5000 EGP.
     *
     * Therefore the backend calculates the real total.
     */
    const {
      products,
      shippingAddress,
    } = req.body;


    /*
     * --------------------------------------------------------
     * 1. Validate products
     * --------------------------------------------------------
     */

    if (!products || !Array.isArray(products)) {
      return res.status(400).json({
        status: "Failed",
        message: "Products are required",
      });
    }

    if (products.length === 0) {
      return res.status(400).json({
        status: "Failed",
        message:
          "Cannot create payment session without products",
      });
    }


    /*
     * --------------------------------------------------------
     * 2. Find the authenticated user
     * --------------------------------------------------------
     *
     * WHY:
     *
     * Paymob needs customer information.
     */
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        status: "Failed",
        message: "User not found",
      });
    }


    /*
     * --------------------------------------------------------
     * 3. Get all variant IDs
     * --------------------------------------------------------
     *
     * We fetch all variants in ONE MongoDB query instead of
     * querying MongoDB separately for every product.
     */
    const variantIds = products.map(
      (item) => item.variant,
    );


    /*
     * --------------------------------------------------------
     * 4. Get variants from database
     * --------------------------------------------------------
     *
     * populate("product") lets us verify that the variant
     * actually belongs to the product sent by Flutter.
     */
    const variants = await Variant.find({
      _id: {
        $in: variantIds,
      },
    }).populate("product");


    /*
     * Convert the variants into a Map.
     *
     * WHY:
     *
     * It allows fast lookup:
     *
     * variantMap.get(variantId)
     */
    const variantMap = new Map(
      variants.map(
        (variant) => [
          variant._id.toString(),
          variant,
        ],
      ),
    );


    /*
     * This will contain the VERIFIED products.
     *
     * We do not save the raw Flutter data.
     */
    const sessionProducts = [];


    /*
     * Server-side total.
     *
     * This is the price Paymob will charge.
     */
    let serverTotal = 0;


    /*
     * --------------------------------------------------------
     * 5. Validate every product
     * --------------------------------------------------------
     */
    for (const item of products) {
      /*
       * Find the variant from our database.
       */
      const variant = variantMap.get(
        String(item.variant),
      );


      /*
       * Variant does not exist.
       */
      if (!variant) {
        return res.status(404).json({
          status: "Failed",
          message:
            "Product variant not found",
        });
      }


      /*
       * ------------------------------------------------------
       * Verify variant belongs to product
       * ------------------------------------------------------
       *
       * WHY:
       *
       * Someone could send:
       *
       * product = A
       * variant = variant belonging to B
       *
       * We must reject that.
       */
      if (
        !variant.product ||
        variant.product._id.toString() !==
          String(item.product)
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Variant does not belong to this product",
        });
      }


      /*
       * ------------------------------------------------------
       * Validate quantity
       * ------------------------------------------------------
       */
      const quantity = Number(
        item.quantity,
      );

      if (
        !Number.isInteger(quantity) ||
        quantity <= 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Invalid product quantity",
        });
      }


      /*
       * ------------------------------------------------------
       * Validate stock
       * ------------------------------------------------------
       *
       * We check stock BEFORE sending the customer to Paymob.
       */
      if (variant.stock < quantity) {
        return res.status(400).json({
          status: "Failed",
          message:
            `Not enough stock for ${variant.product.name}. Available stock: ${variant.stock}`,
        });
      }


      /*
       * ------------------------------------------------------
       * Get the real price from database
       * ------------------------------------------------------
       *
       * IMPORTANT:
       *
       * In your project Variant.price is already the final
       * customer price.
       *
       * Therefore:
       *
       * expectedPrice = variant.price
       *
       * NOT:
       *
       * product.price + variant.price
       */
      const price = Number(
        variant.price,
      );


      /*
       * Make sure the database contains a valid price.
       */
      if (
        !Number.isFinite(price) ||
        price < 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Invalid variant price",
        });
      }


      /*
       * Save only verified information.
       */
      sessionProducts.push({
        product:
          variant.product._id,

        variant:
          variant._id,

        quantity,

        price,
      });


      /*
       * Calculate the total on the SERVER.
       */
      serverTotal +=
        price * quantity;
    }


    /*
     * Avoid floating point problems such as:
     *
     * 99.999999999
     */
    serverTotal = Number(
      serverTotal.toFixed(2),
    );


    /*
     * --------------------------------------------------------
     * 6. Create PaymentSession
     * --------------------------------------------------------
     *
     * IMPORTANT:
     *
     * THIS IS NOT AN ORDER.
     *
     * The Order does not exist yet.
     */
    const paymentSession =
      await PaymentSession.create({
        user: userId,

        products:
          sessionProducts,

        totalPrice:
          serverTotal,

        shippingAddress,

        paymentMethod:
          "card",

        status:
          "pending",
      });


    /*
     * --------------------------------------------------------
     * 7. Convert EGP to smallest currency unit
     * --------------------------------------------------------
     *
     * Paymob expects amount in piastres.
     *
     * Example:
     *
     * 500 EGP
     *
     * becomes:
     *
     * 50000
     */
    const amount = Math.round(
      serverTotal * 100,
    );


    /*
     * --------------------------------------------------------
     * 8. Build Paymob items
     * --------------------------------------------------------
     *
     * Again, the price comes from our database.
     */
    const items =
      sessionProducts.map(
        (item) => {
          const variant =
            variantMap.get(
              item.variant.toString(),
            );

          const product =
            variant?.product;

          return {
            name:
              product?.name ||
              "Product",

            amount:
              Math.round(
                item.price * 100,
              ),

            description:
              product?.name ||
              "Product",

            quantity:
              item.quantity,
          };
        },
      );


    /*
     * --------------------------------------------------------
     * 9. Create Paymob intention
     * --------------------------------------------------------
     */
    let intention;

    try {
      intention =
        await createPaymobIntention({
          amount,

          /*
           * IMPORTANT:
           *
           * We use PaymentSession ID as our reference.
           *
           * This allows the webhook to know which temporary
           * payment session belongs to the Paymob transaction.
           */
          reference:
            paymentSession._id.toString(),

          user,

          items,
        });
    } catch (error) {

      /*
       * Paymob failed.
       *
       * Since no payment can happen, there is no reason
       * to keep the temporary session.
       */
      await PaymentSession.findByIdAndDelete(
        paymentSession._id,
      );

      throw error;
    }


    /*
     * --------------------------------------------------------
     * 10. Save Paymob information
     * --------------------------------------------------------
     */
    paymentSession.paymobIntentionId =
      intention.id
        ? intention.id.toString()
        : null;


    paymentSession.paymobClientSecret =
      intention.client_secret ||
      null;


    await paymentSession.save();


    /*
     * Paymob must return a client secret.
     */
    if (!intention.client_secret) {
      return res.status(500).json({
        status: "Failed",
        message:
          "Paymob did not return a client secret",
      });
    }


    /*
     * --------------------------------------------------------
     * 11. Build Paymob checkout URL
     * --------------------------------------------------------
     */
    const checkoutUrl =
      `${process.env.PAYMOB_API_URL}` +
      `/unifiedcheckout/` +
      `?publicKey=${process.env.PAYMOB_PUBLIC_KEY}` +
      `&clientSecret=${intention.client_secret}`;


    /*
     * --------------------------------------------------------
     * 12. Return session information to Flutter
     * --------------------------------------------------------
     *
     * Notice:
     *
     * There is NO orderId here.
     *
     * Because the Order doesn't exist yet.
     */
    return res.status(200).json({
      status: "Success",

      data: {
        paymentSessionId:
          paymentSession._id.toString(),

        checkoutUrl,

        clientSecret:
          intention.client_secret,

        totalPrice:
          serverTotal,
      },
    });

  } catch (error) {

    console.error(
      "CREATE PAYMENT SESSION ERROR:",
      error,
    );

    return res.status(500).json({
      status: "Failed",
      message:
        error.message ||
        "Could not create payment session",
    });
  }
};


/*
 * ============================================================
 * GET PAYMENT SESSION STATUS
 * ============================================================
 *
 * Flutter calls this after opening Paymob.
 *
 * Example:
 *
 * GET
 * /api/payments/sessions/:paymentSessionId/status
 *
 * Response:
 *
 * pending
 * paid
 * failed
 * expired
 *
 * When the webhook changes the session to "paid",
 * Flutter will know that the payment succeeded.
 */
export const getPaymentSessionStatus =
  async (
    req,
    res,
  ) => {
    try {
      const userId =
        req.user.id;

      const {
        paymentSessionId,
      } = req.params;


      /*
       * Find the session belonging to THIS user.
       *
       * WHY:
       *
       * User A must never be able to read User B's
       * payment session.
       */
      const paymentSession =
        await PaymentSession.findOne({
          _id:
            paymentSessionId,

          user:
            userId,
        });


      if (!paymentSession) {
        return res.status(404).json({
          status: "Failed",
          message:
            "Payment session not found",
        });
      }


      /*
       * ------------------------------------------------------
       * Expire old pending sessions
       * ------------------------------------------------------
       */
      if (
        paymentSession.status ===
          "pending" &&
        paymentSession.expiresAt &&
        paymentSession.expiresAt <
          new Date()
      ) {
        paymentSession.status =
          "expired";

        await paymentSession.save();
      }


      /*
       * Return the current state.
       */
      return res.status(200).json({
        status: "Success",

        data: {
          paymentSessionId:
            paymentSession._id.toString(),

          status:
            paymentSession.status,

          /*
           * This will remain null until the webhook
           * creates the actual Order.
           */
          orderId:
            paymentSession.orderId
              ? paymentSession.orderId.toString()
              : null,
        },
      });

    } catch (error) {

      console.error(
        "GET PAYMENT SESSION STATUS ERROR:",
        error,
      );

      return res.status(500).json({
        status: "Failed",
        message:
          "Could not get payment session status",
      });
    }
  };