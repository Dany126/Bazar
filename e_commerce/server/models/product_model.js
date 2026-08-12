import mongoose from "mongoose";

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "please enter product name"],
      unique: true,
    },
    price: {
      type: Number,
      required: [true, "please enter product price"],
    },
    image: {
      type: [String],
      required: [true, "Please enter at least on image"],
    },
    avg_rating: {
      type: Number,
      default: 4.5,
      min: [1, "Rating must be above 1.0"],
      max: [5, "Rating must be below 5.0"],
    },
    stock: {
      type: Number,
      default: 0,
    },
    soldCount: {
      type: Number,
      default: 0,
    },
    ratingsQuantity: {
      type: Number,
      default: 0,
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: true,
    },
  },
  {
    timestamps: true,
  },
);

productSchema.pre(/^find/, function () {
  this.populate("category", "-__v").select("-__v");
});

export const Product = mongoose.model("Product", productSchema);
