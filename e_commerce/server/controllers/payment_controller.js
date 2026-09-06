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

import mongoose from "mongoose";

import {
  PaymentSession,
} from "../models/payment_session_model.js";

import {
  Variant,
} from "../models/product_variants_model.js";

import {
  User,
} from "../models/user_model.js";

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
 * This does NOT create an Order.
 *
 * It creates a temporary PaymentSession.
 *
 * The real Order is created by the Paymob webhook after
 * successful payment.
 *
 *
 * PRICE RULE
 * ============================================================
 *
 * Product price + Variant price = Final price
 *
 * Example:
 *
 * Product:
 *   price = 100
 *
 * Variant:
 *   price = 500
 *
 * Final:
 *   100 + 500 = 600 EGP
 *
 * The client NEVER decides the final price.
 * MongoDB is always the source of truth.
 */

export const createPaymentSession = async (req, res) => {
  try {
    /*
     * ========================================================
     * USER
     * ========================================================
     */

    const userId = req.user.id;

    /*
     * ========================================================
     * REQUEST DATA
     * ========================================================
     */

    const {
      products,
      shippingAddress,
    } = req.body;

    /*
     * ========================================================
     * VALIDATE PRODUCTS
     * ========================================================
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
     * ========================================================
     * VALIDATE USER
     * ========================================================
     */

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        status: "Failed",
        message: "User not found",
      });
    }

    /*
     * ========================================================
     * VALIDATE PRODUCT + VARIANT IDS
     * ========================================================
     */

    for (const item of products) {
      if (
        !item.product ||
        !mongoose.Types.ObjectId.isValid(item.product)
      ) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid product ID",
        });
      }

      if (
        !item.variant ||
        !mongoose.Types.ObjectId.isValid(item.variant)
      ) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid variant ID",
        });
      }
    }

    /*
     * ========================================================
     * GET VARIANTS
     * ========================================================
     */

    const variantIds = products.map(
      (item) => item.variant,
    );

    const variants = await Variant.find({
      _id: {
        $in: variantIds,
      },
    }).populate("product");

    /*
     * ========================================================
     * CREATE VARIANT MAP
     * ========================================================
     */

    const variantMap = new Map(
      variants.map((variant) => [
        variant._id.toString(),
        variant,
      ]),
    );

    /*
     * ========================================================
     * VERIFIED PRODUCTS
     * ========================================================
     */

    const sessionProducts = [];

    /*
     * Server calculated total.
     */

    let serverTotal = 0;

    /*
     * ========================================================
     * PROCESS PRODUCTS
     * ========================================================
     */

    for (const item of products) {
      /*
       * ------------------------------------------------------
       * Find variant
       * ------------------------------------------------------
       */

      const variant = variantMap.get(
        String(item.variant),
      );

      if (!variant) {
        return res.status(404).json({
          status: "Failed",
          message: "Product variant not found",
        });
      }

      /*
       * ------------------------------------------------------
       * Verify variant belongs to product
       * ------------------------------------------------------
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
       * Quantity
       * ------------------------------------------------------
       */

      const quantity = Number(item.quantity);

      if (
        !Number.isInteger(quantity) ||
        quantity <= 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid product quantity",
        });
      }

      /*
       * ------------------------------------------------------
       * Stock
       * ------------------------------------------------------
       */

      if (variant.stock < quantity) {
        return res.status(400).json({
          status: "Failed",
          message:
            `Not enough stock for ${variant.product.name}. ` +
            `Available stock: ${variant.stock}`,
        });
      }

      /*
       * ======================================================
       * PRICE
       * ======================================================
       *
       * YOUR DATABASE:
       *
       * variant.product.price
       *       +
       * variant.price
       *
       * Example:
       *
       * product.price = 100
       * variant.price = 500
       *
       * finalPrice = 600
       *
       * DO NOT trust:
       *
       * item.price
       *
       * from Flutter.
       */

      const basePrice = Number(
        variant.product.price,
      );

      const variantPrice = Number(
        variant.price,
      );

      /*
       * Validate base product price.
       */

      if (
        !Number.isFinite(basePrice) ||
        basePrice < 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Invalid product base price",
        });
      }

      /*
       * Validate variant price.
       */

      if (
        !Number.isFinite(variantPrice) ||
        variantPrice < 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Invalid variant price",
        });
      }

      /*
       * ======================================================
       * FINAL UNIT PRICE
       * ======================================================
       */

      const finalPrice =
        basePrice + variantPrice;

      /*
       * Make sure final price is valid.
       */

      if (
        !Number.isFinite(finalPrice) ||
        finalPrice < 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Invalid final product price",
        });
      }

      /*
       * ======================================================
       * SAVE VERIFIED PRODUCT
       * ======================================================
       *
       * price is the FINAL unit price.
       *
       * Example:
       *
       * base = 100
       * variant = 500
       * price = 600
       */

      sessionProducts.push({
        product: variant.product._id,

        variant: variant._id,

        quantity,

        price: Number(
          finalPrice.toFixed(2),
        ),
      });

      /*
       * ======================================================
       * CALCULATE TOTAL
       * ======================================================
       */

      serverTotal +=
        finalPrice * quantity;
    }

    /*
     * ========================================================
     * ROUND TOTAL
     * ========================================================
     */

    serverTotal = Number(
      serverTotal.toFixed(2),
    );

    /*
     * ========================================================
     * CREATE PAYMENT SESSION
     * ========================================================
     */

    const paymentSession =
      await PaymentSession.create({
        user: userId,

        products: sessionProducts,

        totalPrice: serverTotal,

        shippingAddress,

        paymentMethod: "card",

        status: "pending",
      });

    /*
     * ========================================================
     * PAYMOB AMOUNT
     * ========================================================
     *
     * EGP -> piastres
     *
     * 600 EGP
     * =
     * 60000 piastres
     */

    const amount = Math.round(
      serverTotal * 100,
    );

    /*
     * ========================================================
     * PAYMOB ITEMS
     * ========================================================
     */

    const items = sessionProducts.map(
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

          /*
           * IMPORTANT:
           *
           * item.price is already:
           *
           * product.price + variant.price
           */

          amount: Math.round(
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
     * ========================================================
     * CREATE PAYMOB INTENTION
     * ========================================================
     */

    let intention;

    try {
      intention =
        await createPaymobIntention({
          amount,

          /*
           * PaymentSession ID is the reference.
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
       * Delete unused payment session.
       */

      await PaymentSession.findByIdAndDelete(
        paymentSession._id,
      );

      throw error;
    }

    /*
     * ========================================================
     * VALIDATE PAYMOB RESPONSE
     * ========================================================
     */

    if (!intention?.client_secret) {
      await PaymentSession.findByIdAndDelete(
        paymentSession._id,
      );

      return res.status(500).json({
        status: "Failed",
        message:
          "Paymob did not return a client secret",
      });
    }

    /*
     * ========================================================
     * SAVE PAYMOB DATA
     * ========================================================
     */

    paymentSession.paymobIntentionId =
      intention.id
        ? intention.id.toString()
        : null;

    paymentSession.paymobClientSecret =
      intention.client_secret;

    await paymentSession.save();

    /*
     * ========================================================
     * CHECKOUT URL
     * ========================================================
     */

    const checkoutUrl =
      `${process.env.PAYMOB_API_URL}` +
      `/unifiedcheckout/` +
      `?publicKey=${process.env.PAYMOB_PUBLIC_KEY}` +
      `&clientSecret=${intention.client_secret}`;

    /*
     * ========================================================
     * RESPONSE
     * ========================================================
     */

    return res.status(200).json({
      status: "Success",

      data: {
        paymentSessionId:
          paymentSession._id.toString(),

        checkoutUrl,

        clientSecret:
          intention.client_secret,

        /*
         * This is the REAL amount calculated by
         * the backend.
         */

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
 * GET:
 *
 * /api/payments/sessions/:paymentSessionId/status
 *
 * Flutter polls this after opening Paymob.
 */

export const getPaymentSessionStatus = async (
  req,
  res,
) => {
  try {
    const userId = req.user.id;

    const {
      paymentSessionId,
    } = req.params;

    /*
     * --------------------------------------------------------
     * Validate ID
     * --------------------------------------------------------
     */

    if (
      !mongoose.Types.ObjectId.isValid(
        paymentSessionId,
      )
    ) {
      return res.status(400).json({
        status: "Failed",
        message:
          "Invalid payment session ID",
      });
    }

    /*
     * --------------------------------------------------------
     * Find user's payment session
     * --------------------------------------------------------
     */

    const paymentSession =
      await PaymentSession.findOne({
        _id: paymentSessionId,

        user: userId,
      });

    if (!paymentSession) {
      return res.status(404).json({
        status: "Failed",
        message:
          "Payment session not found",
      });
    }

    /*
     * --------------------------------------------------------
     * Expire old pending session
     * --------------------------------------------------------
     */

    if (
      paymentSession.status === "pending" &&
      paymentSession.expiresAt &&
      paymentSession.expiresAt < new Date()
    ) {
      paymentSession.status =
        "expired";

      await paymentSession.save();
    }

    /*
     * --------------------------------------------------------
     * RESPONSE
     * --------------------------------------------------------
     */

    return res.status(200).json({
      status: "Success",

      data: {
        paymentSessionId:
          paymentSession._id.toString(),

        status:
          paymentSession.status,

        totalPrice:
          paymentSession.totalPrice,

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
        error.message ||
        "Could not get payment status",
    });
  }
};
