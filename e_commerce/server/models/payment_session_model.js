import mongoose from "mongoose";

/*
 * ============================================================
 * PAYMENT SESSION MODEL
 * ============================================================
 *
 * WHY:
 *
 * A card payment must NOT create an Order before payment
 * succeeds.
 *
 * Therefore we temporarily store the checkout information
 * in this PaymentSession.
 *
 * FLOW:
 *
 * Checkout
 *    ↓
 * PaymentSession
 *    ↓
 * Paymob
 *    ↓
 * Successful payment
 *    ↓
 * Paymob Webhook
 *    ↓
 * Create real Order
 *
 * If payment fails/cancelled:
 *
 * PaymentSession = failed
 * NO Order is created.
 */

const paymentSessionSchema =
  new mongoose.Schema(
    {
      /*
       * The authenticated user who started this payment.
       */
      user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
      },

      /*
       * Products being purchased.
       *
       * IMPORTANT:
       *
       * These values are copied from the database after
       * validation by payment_controller.js.
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
           * Server-verified price.
           *
           * We NEVER trust the Flutter price for calculation.
           */
          price: {
            type: Number,
            required: true,
          },
        },
      ],

      /*
       * Total calculated by our backend.
       */
      totalPrice: {
        type: Number,
        required: true,
        min: 0,
      },

      /*
       * Shipping information saved temporarily until
       * the real Order is created.
       */
      shippingAddress: {
        street: String,
        city: String,
        country: String,
        postalCode: String,
      },

      /*
       * PaymentSession is only used for card payments.
       */
      paymentMethod: {
        type: String,
        enum: ["card"],
        default: "card",
      },

      /*
       * Payment lifecycle.
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
       * Useful for debugging and matching transactions.
       */
      paymobIntentionId: {
        type: String,
        default: null,
      },

      /*
       * Client secret returned by Paymob.
       *
       * Flutter uses this to open Unified Checkout.
       */
      paymobClientSecret: {
        type: String,
        default: null,
      },

      /*
       * The REAL Order ID.
       *
       * This remains NULL while the payment is pending.
       *
       * It gets filled only after successful payment.
       */
      orderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Order",
        default: null,
      },

      /*
       * Payment session expiration.
       *
       * Default = 30 minutes.
       */
      expiresAt: {
        type: Date,
        default: () =>
          new Date(
            Date.now() +
              30 * 60 * 1000,
          ),
      },
    },

    {
      timestamps: true,
    },
  );


/*
 * ============================================================
 * INDEXES
 * ============================================================
 *
 * These make session lookup faster.
 */


/*
 * Find a user's latest payment sessions.
 */
paymentSessionSchema.index({
  user: 1,
  createdAt: -1,
});


/*
 * Find payment sessions using Paymob intention ID.
 */
paymentSessionSchema.index({
  paymobIntentionId: 1,
});


export const PaymentSession =
  mongoose.model(
    "PaymentSession",
    paymentSessionSchema,
  );