import crypto from "crypto";
import { Order } from "../models/order_model.js";
import { PendingPayment } from "../models/pending_payment_model.js";
import { User } from "../models/user_model.js";
import { Variant } from "../models/product_variants_model.js";
import { createNotification } from "./notification_controller.js";

const paymobUrl = "https://accept.paymob.com/v1/intention/";

function getPaymobHmacFields(transaction) {
  return [
    transaction.amount_cents,
    transaction.created_at,
    transaction.currency,
    transaction.error_occured,
    transaction.has_parent_transaction,
    transaction.id,
    transaction.integration_id,
    transaction.is_3d_secure,
    transaction.is_auth,
    transaction.is_capture,
    transaction.is_refunded,
    transaction.is_standalone_payment,
    transaction.is_voided,
    transaction.order?.id,
    transaction.owner,
    transaction.pending,
    transaction.source_data?.pan,
    transaction.source_data?.sub_type,
    transaction.source_data?.type,
    transaction.success,
  ]
    .map((value) => String(value ?? ""))
    .join("");
}

function isValidPaymobHmac(transaction, hmac) {
  const secret = process.env.PAYMOB_HMAC_SECRET;
  if (!secret || !hmac) return false;

  const expected = crypto
    .createHmac("sha512", secret)
    .update(getPaymobHmacFields(transaction))
    .digest("hex");
  return (
    expected.length === hmac.length &&
    crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(hmac))
  );
}

export const createPaymobPayment = async (req, res) => {
  const {
    amountCents,
    currency = "EGP",
    orderReference,
    billingData,
    products,
    shippingAddress,
  } = req.body;
  const secretKey = process.env.PAYMOB_SECRET_KEY;
  const publicKey = process.env.PAYMOB_PUBLIC_KEY;
  const integrationId = Number(process.env.PAYMOB_INTEGRATION_ID);

  if (!secretKey || !publicKey || !integrationId) {
    return res.status(500).json({
      status: "Failed",
      message: "Paymob is not configured on the server",
    });
  }

  if (
    !Number.isInteger(amountCents) ||
    amountCents <= 0 ||
    !orderReference ||
    !billingData ||
    !Array.isArray(products) ||
    products.length === 0 ||
    !shippingAddress ||
    !req.user?.id
  ) {
    return res.status(400).json({
      status: "Failed",
      message: "Invalid Paymob order data",
    });
  }

  try {
    const response = await fetch(paymobUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Token ${secretKey}`,
      },
      body: JSON.stringify({
        amount: amountCents,
        currency,
        payment_methods: [integrationId],
        billing_data: billingData,
        special_reference: orderReference,
        items: [],
      }),
    });

    const data = await response.json();
    if (!response.ok) {
      return res.status(response.status).json({
        status: "Failed",
        message: data.detail || data.message || "Paymob payment failed",
      });
    }

    await PendingPayment.create({
      reference: orderReference,
      user: req.user.id,
      products,
      totalPrice: amountCents / 100,
      shippingAddress,
      paymentId: String(data.id),
    });

    return res.status(200).json({
      status: "Success",
      paymentId: data.id,
      checkoutUrl: `https://accept.paymob.com/unifiedcheckout/?publicKey=${encodeURIComponent(publicKey)}&clientSecret=${encodeURIComponent(data.client_secret)}`,
    });
  } catch (error) {
    console.error("Paymob payment error", error);
    return res.status(502).json({
      status: "Failed",
      message: "Could not connect to Paymob",
    });
  }
};

export const handlePaymobCallback = async (req, res) => {
  const transaction = req.body?.obj;
  const hmac = req.body?.hmac || req.query?.hmac;

  if (!transaction || !isValidPaymobHmac(transaction, hmac)) {
    return res.status(401).json({ status: "Failed", message: "Invalid callback" });
  }

  const reference =
    transaction.order?.merchant_order_id || transaction.order?.special_reference;
  if (!reference) {
    return res.status(400).json({
      status: "Failed",
      message: "Missing payment reference",
    });
  }

  const pendingPayment = await PendingPayment.findOne({ reference });
  if (!pendingPayment) {
    return res.status(404).json({ status: "Failed", message: "Payment not found" });
  }

  if (pendingPayment.status === "paid") {
    return res.status(200).json({ status: "Success" });
  }

  if (transaction.success !== true || transaction.pending === true) {
    await PendingPayment.updateOne(
      { _id: pendingPayment.id },
      { status: "failed" },
    );
    return res.status(200).json({
      status: "Failed",
      message: "Payment was not successful",
    });
  }

  try {
    let totalPrice = 0;
    for (const item of pendingPayment.products) {
      const variant = await Variant.findById(item.variant);
      if (!variant || variant.stock < item.quantity) {
        return res.status(409).json({
          status: "Failed",
          message: "Product is out of stock",
        });
      }
      totalPrice += (item.price ?? variant.price) * item.quantity;
    }

    for (const item of pendingPayment.products) {
      await Variant.findByIdAndUpdate(item.variant, {
        $inc: { stock: -item.quantity, soldCount: item.quantity },
      });
    }

    const order = await Order.create({
      user: pendingPayment.user,
      products: pendingPayment.products,
      totalPrice,
      shippingAddress: pendingPayment.shippingAddress,
      paymentMethod: "card",
      paymentStatus: "paid",
    });

    await PendingPayment.updateOne(
      { _id: pendingPayment.id },
      { status: "paid", paymentId: String(transaction.id) },
    );

    const user = await User.findById(pendingPayment.user);
    if (user?.fcm_token) {
      await createNotification({
        title: "Order Created Successfully",
        body: `Order Status is ${order.orderStatus}`,
        fcm_token: user.fcm_token,
        userId: user.id,
        type: "ORDER",
      });
    }

    return res.status(200).json({ status: "Success", orderId: order.id });
  } catch (error) {
    console.error("Paymob callback error", error);
    return res.status(500).json({
      status: "Failed",
      message: "Could not create paid order",
    });
  }
};
