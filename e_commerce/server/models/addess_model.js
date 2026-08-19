
import mongoose from "mongoose";

const addressSchema = new mongoose.Schema(
  {
    addressType: {
      type: String,
      required: true,
      trim: true,
    },

    buildingName: {
      type: String,
      trim: true,
    },

    apartmentNumber: {
      type: String,
      trim: true,
    },

    houseName: {
      type: String,
      trim: true,
    },

    houseNumber: {
      type: String,
      trim: true,
    },

    officeName: {
      type: String,
      trim: true,
    },

    officeNumber: {
      type: String,
      trim: true,
    },

    floor: {
      type: String,
      trim: true,
    },

    street: {
      type: String,
      required: true,
      trim: true,
    },

    phone: {
      type: String,
      required: true,
      trim: true,
    },

    additionalDirections: {
      type: String,
      trim: true,
    },

    addressLabel: {
      type: String,
      trim: true,
    },

    latitude: {
      type: Number,
      required: true,
    },

    longitude: {
      type: Number,
      required: true,
    },

    city: {
      type: String,
      required: true,
      trim: true,
    },

    country: {
      type: String,
      required: true,
      trim: true,
    },

    postalCode: {
      type: String,
      required: true,
      trim: true,
    },

    isDefault: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);



export const Address = mongoose.model("Address", addressSchema);
