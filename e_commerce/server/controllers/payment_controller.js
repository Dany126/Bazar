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
 * THIS DOES NOT CREATE AN ORDER.
 *
 * It creates a temporary PaymentSession.
 *
 * The real Order is created by the Paymob webhook only after
 * successful payment.
 */
export const createPaymentSession =
  async (req, res) => {
    try {
      /*
       * Authentication middleware provides req.user.
       */
      const userId =
        req.user.id;


      /*
       * Get checkout information from Flutter.
       *
       * NOTICE:
       *
       * We intentionally do NOT read totalPrice.
       *
       * The server calculates it.
       */
      const {
        products,
        shippingAddress,
      } = req.body;


      /*
       * ------------------------------------------------------
       * 1. Validate products
       * ------------------------------------------------------
       */
      if (
        !products ||
        !Array.isArray(products)
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Products are required",
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
       * ------------------------------------------------------
       * 2. Validate user
       * ------------------------------------------------------
       */
      const user =
        await User.findById(
          userId,
        );


      if (!user) {
        return res.status(404).json({
          status: "Failed",
          message:
            "User not found",
        });
      }


      /*
       * ------------------------------------------------------
       * 3. Validate ObjectIds
       * ------------------------------------------------------
       *
       * This prevents MongoDB CastError from turning into
       * an unnecessary 500 response.
       */
      for (const item of products) {
        if (
          !mongoose.Types.ObjectId.isValid(
            item.product,
          )
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              "Invalid product ID",
          });
        }

        if (
          !mongoose.Types.ObjectId.isValid(
            item.variant,
          )
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              "Invalid variant ID",
          });
        }
      }


      /*
       * ------------------------------------------------------
       * 4. Get all variants in ONE query
       * ------------------------------------------------------
       */
      const variantIds =
        products.map(
          (item) =>
            item.variant,
        );


      const variants =
        await Variant.find({
          _id: {
            $in: variantIds,
          },
        }).populate(
          "product",
        );


      /*
       * Map variants for fast lookup.
       */
      const variantMap =
        new Map(
          variants.map(
            (variant) => [
              variant._id.toString(),
              variant,
            ],
          ),
        );


      /*
       * ------------------------------------------------------
       * 5. Build verified products
       * ------------------------------------------------------
       */
      const sessionProducts =
        [];


      /*
       * Server-side total.
       */
      let serverTotal = 0;


      for (
        const item of products
      ) {
        /*
         * Find variant from database.
         */
        const variant =
          variantMap.get(
            String(
              item.variant,
            ),
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
         * ----------------------------------------------------
         * Verify product ↔ variant relationship
         * ----------------------------------------------------
         */
        if (
          !variant.product ||
          variant.product._id.toString() !==
            String(
              item.product,
            )
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              "Variant does not belong to this product",
          });
        }


        /*
         * ----------------------------------------------------
         * Validate quantity
         * ----------------------------------------------------
         */
        const quantity =
          Number(
            item.quantity,
          );


        if (
          !Number.isInteger(
            quantity,
          ) ||
          quantity <= 0
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              "Invalid product quantity",
          });
        }


        /*
         * ----------------------------------------------------
         * Check stock
         * ----------------------------------------------------
         */
        if (
          variant.stock <
          quantity
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              `Not enough stock for ${variant.product.name}. Available stock: ${variant.stock}`,
          });
        }


        /*
         * ----------------------------------------------------
         * Get REAL price from database
         * ----------------------------------------------------
         *
         * IMPORTANT:
         *
         * Your Variant.price is already the FINAL price.
         *
         * Therefore:
         *
         * variant.price
         *
         * NOT:
         *
         * product.price + variant.price
         */
        const price =
          Number(
            variant.price,
          );


        if (
          !Number.isFinite(
            price,
          ) ||
          price < 0
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              "Invalid variant price",
          });
        }


        /*
         * Save verified product information.
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
         * Calculate total using SERVER price.
         */
        serverTotal +=
          price * quantity;
      }


      /*
       * Round total to two decimal places.
       */
      serverTotal =
        Number(
          serverTotal.toFixed(
            2,
          ),
        );


      /*
       * ------------------------------------------------------
       * 6. Create PaymentSession
       * ------------------------------------------------------
       *
       * IMPORTANT:
       *
       * This is NOT an Order.
       */
      const paymentSession =
        await PaymentSession.create({
          user:
            userId,

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
       * ------------------------------------------------------
       * 7. Convert EGP → piastres
       * ------------------------------------------------------
       *
       * Example:
       *
       * 500 EGP = 50000 piastres
       */
      const amount =
        Math.round(
          serverTotal * 100,
        );


      /*
       * ------------------------------------------------------
       * 8. Build Paymob items
       * ------------------------------------------------------
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
       * ------------------------------------------------------
       * 9. Create Paymob intention
       * ------------------------------------------------------
       */
      let intention;


      try {
        intention =
          await createPaymobIntention({
            amount,

            /*
             * VERY IMPORTANT:
             *
             * We pass PaymentSession ID as reference.
             *
             * Paymob webhook will use this to find the
             * temporary payment session.
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
         * Remove unused session.
         */
        await PaymentSession.findByIdAndDelete(
          paymentSession._id,
        );

        throw error;
      }


      /*
       * ------------------------------------------------------
       * 10. Save Paymob information
       * ------------------------------------------------------
       */
      paymentSession.paymobIntentionId =
        intention.id
          ? intention.id.toString()
          : null;


      paymentSession.paymobClientSecret =
        intention.client_secret ||
        null;


      /*
       * Make sure Paymob returned a client secret.
       */
      if (
        !intention.client_secret
      ) {
        await PaymentSession.findByIdAndDelete(
          paymentSession._id,
        );

        return res.status(500).json({
          status: "Failed",
          message:
            "Paymob did not return a client secret",
        });
      }


      await paymentSession.save();


      /*
       * ------------------------------------------------------
       * 11. Build Unified Checkout URL
       * ------------------------------------------------------
       */
      const checkoutUrl =
        `${process.env.PAYMOB_API_URL}` +
        `/unifiedcheckout/` +
        `?publicKey=${process.env.PAYMOB_PUBLIC_KEY}` +
        `&clientSecret=${intention.client_secret}`;


      /*
       * ------------------------------------------------------
       * 12. Return payment session
       * ------------------------------------------------------
       *
       * Notice:
       *
       * NO orderId.
       *
       * The Order doesn't exist yet.
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
 * Flutter uses this endpoint after opening Paymob.
 *
 * GET:
 *
 * /api/payments/sessions/:paymentSessionId/status
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
       * Validate Mongo ID before querying.
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
       * Only allow the owner of the session to access it.
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
       * Automatically expire old pending sessions.
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
       * Return current status.
       */
      return res.status(200).json({
        status: "Success",

        data: {
          paymentSessionId:
            paymentSession._id.toString(),

          status:
            paymentSession.status,

          /*
           * Null until the webhook creates the Order.
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