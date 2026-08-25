import mongoose from "mongoose";

const pendingPaymentSchema = new mongoose.Schema(
  {
    reference: { type: String, required: true, unique: true, index: true },
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    products: { type: Array, required: true },
    totalPrice: { type: Number, required: true },
    shippingAddress: { type: Object, required: true },
    paymentId: { type: String },
    status: {
      type: String,
      enum: ["pending", "paid", "failed"],
      default: "pending",
    },
  },
  { timestamps: true },
);

export const PendingPayment = mongoose.model(
  "PendingPayment",
  pendingPaymentSchema,
);
