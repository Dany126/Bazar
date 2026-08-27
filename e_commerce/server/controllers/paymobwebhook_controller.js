import crypto from "crypto";
import { Order } from "../models/order_model.js";
import { createNotification } from "./notification_controller.js"; // adjust path as needed

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

const formatHmacValue = (value) => {
  if (value === null || value === undefined) {
    return "";
  }

  if (typeof value === "boolean") {
    return value ? "true" : "false";
  }

  return String(value);
};

/*
 * Some HMAC fields aren't flat keys on the transaction object.
 * "order" is an object (use its id), and the three source_data_*
 * fields are actually nested inside transaction.source_data.
 */
const getHmacValue = (transaction, field) => {
  let value;

  switch (field) {
    case "order":
      value = transaction.order?.id;
      break;
    case "source_data_pan":
      value = transaction.source_data?.pan;
      break;
    case "source_data_sub_type":
      value = transaction.source_data?.sub_type;
      break;
    case "source_data_type":
      value = transaction.source_data?.type;
      break;
    default:
      value = transaction[field];
  }

  return formatHmacValue(value);
};

const verifyPaymobHmac = (data, receivedHmac) => {
  const transaction = data.obj;

  if (!transaction || !receivedHmac) {
    return false;
  }

  const concatenatedValues = HMAC_FIELDS.map((field) =>
    getHmacValue(transaction, field),
  ).join("");

  const calculatedHmac = crypto
    .createHmac("sha512", process.env.PAYMOB_HMAC_KEY)
    .update(concatenatedValues)
    .digest("hex");

  // Prevent timingSafeEqual from throwing if lengths differ
  if (calculatedHmac.length !== receivedHmac.length) {
    return false;
  }

  return crypto.timingSafeEqual(
    Buffer.from(calculatedHmac, "hex"),
    Buffer.from(receivedHmac, "hex"),
  );
};

export const paymobWebhook = async (req, res) => {
  try {
    /*
     * Because this route uses express.raw(),
     * req.body is a Buffer.
     */

    const data = JSON.parse(req.body.toString());

    /*
     * Paymob sends the HMAC in the query string:
     *
     * /webhook?hmac=xxxxxxxx
     */
    const receivedHmac = req.query.hmac;

    console.log("Received Paymob HMAC:", receivedHmac);

    // Verify Paymob HMAC
    const isValid = verifyPaymobHmac(data, receivedHmac);

    if (!isValid) {
      console.log("Invalid Paymob HMAC");

      return res.status(403).json({
        status: "Failed",
        message: "Invalid HMAC",
      });
    }

    console.log("Valid Paymob HMAC");

    const transaction = data.obj;

    console.log("Paymob transaction:", transaction);

    /*
     * Only successful transactions should
     * make the order paid.
     */
    if (transaction.success === true) {
      /*
       * Prefer merchant_order_id (set via special_reference when
       * creating the Paymob intention), fall back to
       * payment_key_claims.extra.order_id as a safety net.
       */
      const orderId =
        transaction.order?.merchant_order_id ||
        transaction.payment_key_claims?.extra?.order_id;

      if (!orderId) {
        console.log("Order ID not found in Paymob webhook");

        return res.status(400).json({
          status: "Failed",
          message: "Order ID not found",
        });
      }

      /*
       * Populate user so we have fcm_token available
       * for the notification below without a second query.
       */
      const order = await Order.findById(orderId).populate("user");

      if (!order) {
        console.log("Order not found:", orderId);

        return res.status(404).json({
          status: "Failed",
          message: "Order not found",
        });
      }

      /*
       * Idempotency:
       *
       * If Paymob sends the webhook more than once,
       * don't process the payment again.
       */
      if (order.paymentStatus !== "paid") {
        order.paymentStatus = "paid";

        await order.save();

        console.log(`Order ${orderId} successfully paid`);

        /*
         * Notify the user that their order is placed.
         * Wrapped separately so a notification failure
         * never breaks the webhook response — the payment
         * itself already succeeded.
         */
        try {
          if (order.user?.fcm_token) {
            await createNotification({
              title: "Order Created Successfully",
              body: `Order Status is ${order.orderStatus}`,
              fcm_token: order.user.fcm_token,
              userId: order.user.id,
              type: "ORDER",
            });

            console.log(`Notification sent for order ${orderId}`);
          } else {
            console.log(`No fcm_token found for user on order ${orderId}`);
          }
        } catch (notifyErr) {
          console.error(
            `Failed to send notification for order ${orderId}:`,
            notifyErr,
          );
        }
      } else {
        console.log(`Order ${orderId} was already paid`);
      }
    }

    /*
     * Return 200 so Paymob knows that
     * the webhook was successfully received.
     */
    return res.status(200).json({
      status: "Success",
    });
  } catch (err) {
    console.error("Paymob webhook error:", err);

    return res.status(500).json({
      status: "Failed",
      message: "Webhook processing failed",
    });
  }
};
