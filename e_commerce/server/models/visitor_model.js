import mongoose from "mongoose";

const visitorSchema = new mongoose.Schema(
  {
    visitorId: {
      type: String,
      required: true,
    },
    monthKey: {
      type: String,
      required: true,
    },
    lastSeenAt: {
      type: Date,
      default: Date.now,
    },
    lastPath: String,
    converted: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true },
);

visitorSchema.index({ visitorId: 1, monthKey: 1 }, { unique: true });
visitorSchema.index({ monthKey: 1, createdAt: 1, converted: 1 });

export const Visitor = mongoose.model("Visitor", visitorSchema);
