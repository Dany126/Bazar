import mongoose from "mongoose";

const categorySchema = new mongoose.Schema(
  {
    name: String,
    image: String,
  },
  {
    timestamps: true,
  },
);

// categorySchema.pre(/^find/, function (next) {
//   this.select("-__v");
//   next();
// });

export const Category = mongoose.model("Category", categorySchema);
