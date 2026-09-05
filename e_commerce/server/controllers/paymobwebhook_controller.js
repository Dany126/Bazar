// import crypto from "crypto";
// import { Order } from "../models/order_model.js";
// import { createNotification } from "./notification_controller.js"; // adjust path as needed

// const HMAC_FIELDS = [
//   "amount_cents",
//   "created_at",
//   "currency",
//   "error_occured",
//   "has_parent_transaction",
//   "id",
//   "integration_id",
//   "is_3d_secure",
//   "is_auth",
//   "is_capture",
//   "is_refunded",
//   "is_standalone_payment",
//   "is_voided",
//   "order",
//   "owner",
//   "pending",
//   "source_data_pan",
//   "source_data_sub_type",
//   "source_data_type",
//   "success",
// ];

// const formatHmacValue = (value) => {
//   if (value === null || value === undefined) {
//     return "";
//   }

//   if (typeof value === "boolean") {
//     return value ? "true" : "false";
//   }

//   return String(value);
// };

// /*
//  * Some HMAC fields aren't flat keys on the transaction object.
//  * "order" is an object (use its id), and the three source_data_*
//  * fields are actually nested inside transaction.source_data.
//  */
// const getHmacValue = (transaction, field) => {
//   let value;

//   switch (field) {
//     case "order":
//       value = transaction.order?.id;
//       break;
//     case "source_data_pan":
//       value = transaction.source_data?.pan;
//       break;
//     case "source_data_sub_type":
//       value = transaction.source_data?.sub_type;
//       break;
//     case "source_data_type":
//       value = transaction.source_data?.type;
//       break;
//     default:
//       value = transaction[field];
//   }

//   return formatHmacValue(value);
// };

// const verifyPaymobHmac = (data, receivedHmac) => {
//   const transaction = data.obj;

//   if (!transaction || !receivedHmac) {
//     return false;
//   }

//   const concatenatedValues = HMAC_FIELDS.map((field) =>
//     getHmacValue(transaction, field),
//   ).join("");

//   const calculatedHmac = crypto
//     .createHmac("sha512", process.env.PAYMOB_HMAC_KEY)
//     .update(concatenatedValues)
//     .digest("hex");

//   // Prevent timingSafeEqual from throwing if lengths differ
//   if (calculatedHmac.length !== receivedHmac.length) {
//     return false;
//   }

//   return crypto.timingSafeEqual(
//     Buffer.from(calculatedHmac, "hex"),
//     Buffer.from(receivedHmac, "hex"),
//   );
// };

// export const paymobWebhook = async (req, res) => {
//   try {
//     /*
//      * Because this route uses express.raw(),
//      * req.body is a Buffer.
//      */

//     const data = JSON.parse(req.body.toString());

//     /*
//      * Paymob sends the HMAC in the query string:
//      *
//      * /webhook?hmac=xxxxxxxx
//      */
//     const receivedHmac = req.query.hmac;

//     console.log("Received Paymob HMAC:", receivedHmac);

//     // Verify Paymob HMAC
//     const isValid = verifyPaymobHmac(data, receivedHmac);

//     if (!isValid) {
//       console.log("Invalid Paymob HMAC");

//       return res.status(403).json({
//         status: "Failed",
//         message: "Invalid HMAC",
//       });
//     }

//     console.log("Valid Paymob HMAC");

//     const transaction = data.obj;

//     console.log("Paymob transaction:", transaction);

//     /*
//      * Only successful transactions should
//      * make the order paid.
//      */
//     if (transaction.success === true) {
//       /*
//        * Prefer merchant_order_id (set via special_reference when
//        * creating the Paymob intention), fall back to
//        * payment_key_claims.extra.order_id as a safety net.
//        */
//       const orderId =
//         transaction.order?.merchant_order_id ||
//         transaction.payment_key_claims?.extra?.order_id;

//       if (!orderId) {
//         console.log("Order ID not found in Paymob webhook");

//         return res.status(400).json({
//           status: "Failed",
//           message: "Order ID not found",
//         });
//       }

//       /*
//        * Populate user so we have fcm_token available
//        * for the notification below without a second query.
//        */
//       const order = await Order.findById(orderId).populate("user");

//       if (!order) {
//         console.log("Order not found:", orderId);

//         return res.status(404).json({
//           status: "Failed",
//           message: "Order not found",
//         });
//       }

//       /*
//        * Idempotency:
//        *
//        * If Paymob sends the webhook more than once,
//        * don't process the payment again.
//        */
//       if (order.paymentStatus !== "paid") {
//         order.paymentStatus = "paid";

//         await order.save();

//         console.log(`Order ${orderId} successfully paid`);

//         /*
//          * Notify the user that their order is placed.
//          * Wrapped separately so a notification failure
//          * never breaks the webhook response — the payment
//          * itself already succeeded.
//          */
//         try {
//           if (order.user?.fcm_token) {
//             await createNotification({
//               title: "Order Created Successfully",
//               body: `Order Status is ${order.orderStatus}`,
//               fcm_token: order.user.fcm_token,
//               userId: order.user.id,
//               type: "ORDER",
//             });

//             console.log(`Notification sent for order ${orderId}`);
//           } else {
//             console.log(`No fcm_token found for user on order ${orderId}`);
//           }
//         } catch (notifyErr) {
//           console.error(
//             `Failed to send notification for order ${orderId}:`,
//             notifyErr,
//           );
//         }
//       } else {
//         console.log(`Order ${orderId} was already paid`);
//       }
//     }

//     /*
//      * Return 200 so Paymob knows that
//      * the webhook was successfully received.
//      */
//     return res.status(200).json({
//       status: "Success",
//     });
//   } catch (err) {
//     console.error("Paymob webhook error:", err);

//     return res.status(500).json({
//       status: "Failed",
//       message: "Webhook processing failed",
//     });
//   }
// };
import crypto from "crypto";

import mongoose from "mongoose";

import {
  PaymentSession,
} from "../models/payment_session_model.js";

import {
  Order,
} from "../models/order_model.js";

import {
  Variant,
} from "../models/product_variants_model.js";

import {
  createNotification,
} from "./notification_controller.js";


/*
 * ============================================================
 * PAYMOB HMAC FIELDS
 * ============================================================
 *
 * These are the fields Paymob uses when calculating webhook HMAC.
 */
const HMAC_FIELDS = [
  "amount_cents",
  "created_at",
  "currency",
  "error_occured",
  "has_parent_transaction",
  "id",
  "integration_id",
  "is_3d_secure",
  "is_auth",
  "is_capture",
  "is_refunded",
  "is_standalone_payment",
  "is_voided",
  "order",
  "owner",
  "pending",
  "source_data_pan",
  "source_data_sub_type",
  "source_data_type",
  "success",
];


/*
 * Convert values into the exact string representation
 * required for HMAC calculation.
 */
const formatHmacValue =
  (value) => {

    if (
      value === null ||
      value === undefined
    ) {
      return "";
    }


    if (
      typeof value ===
      "boolean"
    ) {
      return value
        ? "true"
        : "false";
    }


    return String(value);
  };


/*
 * ============================================================
 * GET HMAC FIELD VALUE
 * ============================================================
 *
 * Some Paymob fields are nested objects.
 */
const getHmacValue =
  (
    transaction,
    field,
  ) => {

    let value;


    switch (field) {

      case "order":
        value =
          transaction
            .order
            ?.id;
        break;


      case "source_data_pan":
        value =
          transaction
            .source_data
            ?.pan;
        break;


      case "source_data_sub_type":
        value =
          transaction
            .source_data
            ?.sub_type;
        break;


      case "source_data_type":
        value =
          transaction
            .source_data
            ?.type;
        break;


      default:
        value =
          transaction[field];
    }


    return formatHmacValue(
      value,
    );
  };


/*
 * ============================================================
 * VERIFY PAYMOB HMAC
 * ============================================================
 */
const verifyPaymobHmac =
  (
    data,
    receivedHmac,
  ) => {

    const transaction =
      data?.obj;


    if (
      !transaction ||
      !receivedHmac
    ) {
      return false;
    }


    /*
     * Build the exact concatenated value.
     */
    const concatenatedValues =
      HMAC_FIELDS
        .map(
          (field) =>
            getHmacValue(
              transaction,
              field,
            ),
        )
        .join("");


    /*
     * Generate HMAC using your Paymob HMAC key.
     */
    const calculatedHmac =
      crypto
        .createHmac(
          "sha512",
          process.env
            .PAYMOB_HMAC_KEY,
        )
        .update(
          concatenatedValues,
        )
        .digest("hex");


    /*
     * Prevent timingSafeEqual from throwing when lengths differ.
     */
    if (
      calculatedHmac.length !==
      receivedHmac.length
    ) {
      return false;
    }


    /*
     * Timing-safe comparison.
     */
    return crypto.timingSafeEqual(
      Buffer.from(
        calculatedHmac,
        "hex",
      ),

      Buffer.from(
        receivedHmac,
        "hex",
      ),
    );
  };


/*
 * ============================================================
 * GET PAYMENT SESSION ID FROM PAYMOB
 * ============================================================
 *
 * We store our PaymentSession ID in:
 *
 * 1. merchant_order_id
 * 2. payment_key_claims.extra.payment_session_id
 *
 * The first one is the primary reference.
 */
const getPaymentSessionId =
  (transaction) => {

    return (
      transaction
        ?.order
        ?.merchant_order_id ||

      transaction
        ?.payment_key_claims
        ?.extra
        ?.payment_session_id
    );
  };


/*
 * ============================================================
 * PAYMOB WEBHOOK
 * ============================================================
 */
export const paymobWebhook =
  async (
    req,
    res,
  ) => {

    try {

      /*
       * ------------------------------------------------------
       * 1. Parse raw Paymob body
       * ------------------------------------------------------
       *
       * index.js must use express.raw() for this route.
       */
      const data =
        JSON.parse(
          req.body.toString(),
        );


      /*
       * ------------------------------------------------------
       * 2. Get HMAC
       * ------------------------------------------------------
       */
      const receivedHmac =
        req.query.hmac;


      console.log(
        "Received Paymob HMAC:",
        receivedHmac,
      );


      /*
       * ------------------------------------------------------
       * 3. Verify HMAC
       * ------------------------------------------------------
       */
      const isValid =
        verifyPaymobHmac(
          data,
          receivedHmac,
        );


      if (!isValid) {

        console.log(
          "Invalid Paymob HMAC",
        );


        return res.status(403).json({
          status: "Failed",
          message:
            "Invalid HMAC",
        });
      }


      console.log(
        "Valid Paymob HMAC",
      );


      /*
       * Paymob transaction.
       */
      const transaction =
        data.obj;


      console.log(
        "Paymob transaction:",
        transaction,
      );


      /*
       * ------------------------------------------------------
       * 4. Find our PaymentSession
       * ------------------------------------------------------
       */
      const paymentSessionId =
        getPaymentSessionId(
          transaction,
        );


      if (
        !paymentSessionId
      ) {

        console.error(
          "PAYMOB WEBHOOK: PaymentSession ID not found",
        );


        /*
         * We return 200 because the webhook itself was
         * successfully received and verified.
         *
         * Returning 400 can cause Paymob to retry a webhook
         * that we simply cannot correlate.
         */
        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * Validate ID.
       */
      if (
        !mongoose.Types.ObjectId.isValid(
          paymentSessionId,
        )
      ) {

        console.error(
          "PAYMOB WEBHOOK: Invalid PaymentSession ID:",
          paymentSessionId,
        );


        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * Find PaymentSession.
       */
      const paymentSession =
        await PaymentSession.findById(
          paymentSessionId,
        );


      if (
        !paymentSession
      ) {

        console.error(
          "PAYMOB WEBHOOK: PaymentSession not found:",
          paymentSessionId,
        );


        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * ------------------------------------------------------
       * 5. Make sure Paymob amount matches our session
       * ------------------------------------------------------
       *
       * This prevents creating an Order for the wrong amount.
       */
      const paymobAmount =
        Number(
          transaction.amount_cents,
        );


      const expectedAmount =
        Math.round(
          Number(
            paymentSession.totalPrice,
          ) * 100,
        );


      if (
        paymobAmount !==
        expectedAmount
      ) {

        console.error(
          "PAYMOB WEBHOOK: AMOUNT MISMATCH",
          {
            paymobAmount,
            expectedAmount,
            paymentSessionId,
          },
        );


        /*
         * The payment amount does not match our session.
         *
         * Do not create an Order.
         */
        paymentSession.status =
          "failed";


        await paymentSession.save();


        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * ------------------------------------------------------
       * 6. Handle unsuccessful payment
       * ------------------------------------------------------
       */
      if (
        transaction.success !==
        true
      ) {

        paymentSession.status =
          "failed";


        await paymentSession.save();


        console.log(
          "PAYMOB PAYMENT FAILED:",
          paymentSessionId,
        );


        /*
         * IMPORTANT:
         *
         * NO Order is created.
         */
        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * ------------------------------------------------------
       * 7. Prevent duplicate webhook processing
       * ------------------------------------------------------
       *
       * Paymob may send the same webhook more than once.
       */
      if (
        paymentSession.status ===
        "paid"
      ) {

        console.log(
          "PaymentSession already processed:",
          paymentSessionId,
        );


        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * ------------------------------------------------------
       * 8. Check whether session expired
       * ------------------------------------------------------
       */
      if (
        paymentSession.expiresAt &&
        paymentSession.expiresAt <
          new Date()
      ) {

        paymentSession.status =
          "expired";


        await paymentSession.save();


        return res.status(200).json({
          status: "Success",
        });
      }


      /*
       * ------------------------------------------------------
       * 9. Check stock AGAIN
       * ------------------------------------------------------
       *
       * WHY:
       *
       * Stock may have changed while the customer was
       * on the Paymob payment page.
       *
       * Example:
       *
       * Customer starts payment with stock = 2.
       * Another customer buys both.
       * First customer finishes payment.
       *
       * We must detect that before creating the Order.
       */
      for (
        const item of
          paymentSession.products
      ) {

        const variant =
          await Variant.findById(
            item.variant,
          );


        if (
          !variant
        ) {

          paymentSession.status =
            "failed";


          await paymentSession.save();


          console.error(
            "Variant no longer exists:",
            item.variant,
          );


          return res.status(200).json({
            status: "Success",
          });
        }


        if (
          variant.stock <
          item.quantity
        ) {

          paymentSession.status =
            "failed";


          await paymentSession.save();


          console.error(
            "Stock changed during payment:",
            item.variant,
          );


          return res.status(200).json({
            status: "Success",
          });
        }
      }


      /*
       * ------------------------------------------------------
       * 10. Create REAL Order
       * ------------------------------------------------------
       *
       * THIS is the first time an Order is created.
       */
      const order =
        await Order.create({
          user:
            paymentSession.user,

          products:
            paymentSession.products,

          totalPrice:
            paymentSession.totalPrice,

          shippingAddress:
            paymentSession.shippingAddress,

          paymentMethod:
            "card",

          paymentStatus:
            "paid",

          orderStatus:
            "confirmed",
        });


      console.log(
        "CARD ORDER CREATED:",
        order._id.toString(),
      );


      /*
       * ------------------------------------------------------
       * 11. Decrease stock
       * ------------------------------------------------------
       */
      for (
        const item of
          paymentSession.products
      ) {

        await Variant.findByIdAndUpdate(
          item.variant,

          {
            $inc: {
              stock:
                -item.quantity,

              soldCount:
                item.quantity,
            },
          },
        );
      }


      /*
       * ------------------------------------------------------
       * 12. Mark PaymentSession as paid
       * ------------------------------------------------------
       */
      paymentSession.status =
        "paid";


      paymentSession.orderId =
        order._id;


      await paymentSession.save();


      /*
       * ------------------------------------------------------
       * 13. Notify customer
       * ------------------------------------------------------
       *
       * Notification failure must NEVER make the payment
       * appear unsuccessful.
       */
      try {

        const populatedOrder =
          await Order.findById(
            order._id,
          ).populate(
            "user",
          );


        if (
          populatedOrder
            ?.user
            ?.fcm_token
        ) {

          await createNotification({
            title:
              "Order Created Successfully",

            body:
              `Order Status is ${populatedOrder.orderStatus}`,

            fcm_token:
              populatedOrder
                .user
                .fcm_token,

            userId:
              populatedOrder
                .user
                .id,

            type:
              "ORDER",
          });


          console.log(
            "Order notification sent:",
            order._id.toString(),
          );
        }

      } catch (
        notificationError
      ) {

        console.error(
          "Notification failed:",
          notificationError,
        );
      }


      /*
       * ------------------------------------------------------
       * 14. Tell Paymob webhook was received
       * ------------------------------------------------------
       */
      return res.status(200).json({
        status: "Success",
      });

    } catch (error) {

      console.error(
        "PAYMOB WEBHOOK ERROR:",
        error,
      );


      return res.status(500).json({
        status: "Failed",
        message:
          "Webhook processing failed",
      });
    }
  };