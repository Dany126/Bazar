const mongoose = require("mongoose");

const categorySchema = new mongoose.Schema({
  name: String,
});

// categorySchema.pre(/^find/, function (next) {
//   this.select("-__v");
//   next();
// });

const Category = mongoose.model("Category", categorySchema);

module.exports = Category;
