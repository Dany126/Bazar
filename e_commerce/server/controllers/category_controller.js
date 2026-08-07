import { Category } from "../models/category_model.js";

export const createCategory = async (req, res) => {
  try {
    const category = await Category.create(req.body);
    if (!category) {
      return res.status(400).json({
        status: "Failed",
        message: "Something went wrong",
      });
    }
    return res.status(200).json({
      status: "success",
      message: "Category Created Successfuly",
      category,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const getAllCategories = async (req, res) => {
  try {
    const categories = await Category.find().select("-__v");
    if (!categories) {
      return res.status(400).json({
        status: "Failed",
        message: "No category found",
      });
    }
    return res.status(200).json({
      status: "Success",
      categories,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};
