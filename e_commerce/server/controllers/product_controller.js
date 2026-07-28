const Product = require("../models/product_model");

const createProduct = async (req, res, next) => {
  try {
    const data = await Product.create(req.body);
    if (!data) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating a product",
      });
    }
    return res.status(200).json({
      status: "Success",
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

const getAllProducts = async (req, res, next) => {
  try {
    const products = await Product.find();
    if (!products) {
      return res.status(400).json({
        status: "Failed",
        message: "No product found",
      });
    }
    return res.status(200).json({
      status: "Success",
      data: {
        products,
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

module.exports = { getAllProducts, createProduct };
