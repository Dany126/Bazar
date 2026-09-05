import mongoose from "mongoose";

/*
 * WHY THIS MODEL EXISTS:
 *
 * We must NOT create an Order before a card payment succeeds.
 *
 * Therefore, we temporarily store the checkout information in a
 * PaymentSession.
 *
 * Flow:
 *
 * Checkout
 *    ↓
 * PaymentSession
 *    ↓
 * Paymob
 *    ↓
 * Payment successful
 *    ↓
 * Webhook
 *    ↓
 * Create Order
 *
 * If the customer cancels the payment, there is NO Order.
 */

const paymentSessionSchema = new mongoose.Schema(
  {
    /*
     * The user who started the payment.
     *
     * WHY:
     * We need to make sure that only the owner of the payment
     * session can check its status.
     */
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    /*
     * Products that the customer wants to buy.
     *
     * We copy the price from the Variant at session creation time.
     *
     * WHY:
     * Never trust the price sent by Flutter.
     */
    products: [
      {
        product: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Product",
          required: true,
        },

        variant: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Variant",
          required: true,
        },

        quantity: {
          type: Number,
          required: true,
          min: 1,
        },

        /*
         * This is the server-verified price.
         *
         * In your project Variant.price is the final selling price.
         */
        price: {
          type: Number,
          required: true,
        },
      },
    ],

    /*
     * Total calculated by the server.
     *
     * We DO NOT trust totalPrice from Flutter.
     */
    totalPrice: {
      type: Number,
      required: true,
      min: 0,
    },

    /*
     * Shipping information entered during checkout.
     */
    shippingAddress: {
      street: String,
      city: String,
      country: String,
      postalCode: String,
    },

    /*
     * A payment session is only for card payments.
     */
    paymentMethod: {
      type: String,
      enum: ["card"],
      default: "card",
    },

    /*
     * Payment lifecycle:
     *
     * pending → customer has not paid yet
     * paid    → Paymob confirmed payment
     * failed  → payment failed
     * expired → session expired
     */
    status: {
      type: String,
      enum: [
        "pending",
        "paid",
        "failed",
        "expired",
      ],
      default: "pending",
    },

    /*
     * Paymob intention ID.
     *
     * WHY:
     * Useful for matching our payment session with Paymob.
     */
    paymobIntentionId: {
      type: String,
      default: null,
    },

    /*
     * Paymob client secret.
     *
     * Flutter uses this to open the Paymob checkout.
     */
    paymobClientSecret: {
      type: String,
      default: null,
    },

    /*
     * The real Order ID.
     *
     * IMPORTANT:
     *
     * This stays null until payment succeeds.
     */
    orderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Order",
      default: null,
    },

    /*
     * Payment sessions should not remain pending forever.
     *
     * Default = 30 minutes.
     */
    expiresAt: {
      type: Date,
      default: () =>
        new Date(
          Date.now() + 30 * 60 * 1000,
        ),
    },
  },

  {
    timestamps: true,
  },
);

/*
 * WHY THESE INDEXES:
 *
 * 1. Quickly find a user's payment sessions.
 * 2. Quickly find a session using Paymob's intention ID.
 */
paymentSessionSchema.index({
  user: 1,
  createdAt: -1,
});

paymentSessionSchema.index({
  paymobIntentionId: 1,
});

export const PaymentSession =
  mongoose.model(
    "PaymentSession",
    paymentSessionSchema,
  );