const Category = require("../models/category_model");

const createCategory = async (req, res, next) => {
  try {
    const { name } = req.body;
    const data = await Category.create({ name });
    if (!data) {
      return res.status(400).json({
        status: "Failed",
        message: "Something went wrong",
      });
    }
    return res.status(200).json({
      status: "success",
      message: "Category Created Successfuly",
      data,
    });
    next();
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

const getAllCategories = async (req, res, next) => {
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
      data: {
        categories,
      },
    });
    next();
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

module.exports = { getAllCategories, createCategory };
