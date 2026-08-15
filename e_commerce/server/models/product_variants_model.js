import mongoose from "mongoose";

const variantsSchema = new mongoose.Schema({
  size: {
    type: String,
    enum: ["S", "M", "L", "XL", "2XL", "3XL"],
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  color: {
    type: String,
    required: true,
  },
  stock: {
    type: Number,
    min: 0,
    default: 0,
  },
  soldCount: {
    type: Number,
    min: 0,
    default: 0,
  },
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Product",
  },
});

export const Variant = mongoose.model("Variant", variantsSchema);
