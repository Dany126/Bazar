import { Product } from "../models/product_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";

export const createProduct = async (req, res) => {
  try {
    const product = await Product.create(req.body);
    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating a product",
      });
    }
    return res.status(200).json({
      status: "Success",
      product,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const getAllProducts = async (req, res) => {
  try {
    const query = { ...req.query, ...req.params };
    const { filter, limits, skip, sortBy } = apiFeatures(query);
    const products = await Product.find(filter)
      .sort(sortBy)
      .skip(skip)
      .limit(limits);
    if (!products) {
      return res.status(400).json({
        status: "Failed",
        message: "No product found",
      });
    }
    return res.status(200).json({
      status: "Success",
      products,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const getProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      product,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedProduct = await Product.findByIdAndUpdate(id, req.body, {
      returnDocument: "after",
    });
    if (!updatedProduct) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      updatedProduct,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      message: "Product Deleted Successfuly",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};
