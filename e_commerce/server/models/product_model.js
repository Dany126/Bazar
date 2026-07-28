const mongoose = require("mongoose");

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "please enter product name"],
  },
  price: {
    type: Number,
    required: [true, "please enter product price"],
  },
  avg_rating: {
    type: Number,
    default: 4.5,
    min: [1, "Rating must be above 1.0"],
    max: [5, "Rating must be below 5.0"],
    set: (val) => Math.round(val * 10) / 10,
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
});

productSchema.pre(/^find/, function () {
  this.populate("category", "-__v").select("-__v");
});

const Product = mongoose.model("Product", productSchema);

module.exports = Product;
