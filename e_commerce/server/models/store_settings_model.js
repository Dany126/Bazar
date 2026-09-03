import mongoose from "mongoose";

const storeSettingsSchema = new mongoose.Schema(
  {
    storeName: {
      type: String,
      required: true,
      trim: true,
      maxlength: 100,
    },

    description: {
      type: String,
      default: "",
      trim: true,
      maxlength: 1000,
    },

    email: {
      type: String,
      default: "",
      trim: true,
      lowercase: true,
    },

    phone: {
      type: String,
      default: "",
      trim: true,
    },

    address: {
      type: String,
      default: "",
      trim: true,
    },

    city: {
      type: String,
      default: "",
      trim: true,
    },

    country: {
      type: String,
      default: "",
      trim: true,
    },

    postalCode: {
      type: String,
      default: "",
      trim: true,
    },

    currency: {
      type: String,
      default: "EGP",
      trim: true,
      uppercase: true,
      maxlength: 10,
    },

    taxRate: {
      type: Number,
      default: 0,
      min: 0,
      max: 100,
    },

    shippingFee: {
      type: Number,
      default: 0,
      min: 0,
    },

    freeShippingThreshold: {
      type: Number,
      default: 0,
      min: 0,
    },

    minimumOrderAmount: {
      type: Number,
      default: 0,
      min: 0,
    },

    lowStockThreshold: {
      type: Number,
      default: 15,
      min: 0,
    },

    storeEnabled: {
      type: Boolean,
      default: true,
    },

    acceptOrders: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  },
);

export const StoreSettings = mongoose.model(
  "StoreSettings",
  storeSettingsSchema,
);