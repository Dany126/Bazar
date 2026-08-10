import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    title: {
      type: String,
      required: true,
    },

    body: {
      type: String,
      required: true,
    },

    type: {
      type: String,
      enum: ["ORDER", "PROMOTION", "SYSTEM"],
      required: true,
    },

    data: {
      type: Object,
    },

    isRead: {
      type: Boolean,
      default: false,
    },
    isFavorite: {
      type: Boolean,
      deefault: false,
    },
  },
  {
    timestamps: true,
  },
);

export const Notification = mongoose.model("Notification", notificationSchema);
