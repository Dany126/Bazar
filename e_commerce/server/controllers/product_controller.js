import { Product } from "../models/product_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";
import { Wishlist } from "../models/wishlist_model.js";

export const createProduct = async (req, res) => {
  try {
    if (!req.files) {
      return res.status(400).json({
        status: "Failed",
        message: "Image is required",
      });
    }
    const imageUrls = req.files.map(
      (file) => `${req.protocol}://${req.get("host")}/public/${file.filename}`,
    );

    const body = {
      image: imageUrls,
      avg_rating: Number(req.body.avg_rating),
      price: Number(req.body.price),
      name: req.body.name,
      category: req.body.category,
    };
    const product = await Product.create(body);
    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating a product",
      });
    }
    return res.status(201).json({
      status: "Success",
      product,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllProducts = async (req, res) => {
  try {
    const query = { ...req.params, ...req.query };

    const { filter, limits, skip, sortBy } = apiFeatures(query);

    const products = await Product.find(filter)
      .sort(sortBy)
      .skip(skip)
      .limit(limits);

    if (!products.length) {
      return res.status(404).json({
        status: "Failed",
        message: "No product found",
      });
    }

    const wishlist = await Wishlist.findOne({
      user: req.user.id,
    }).select("product");

    const wishlistIds = new Set(
      wishlist?.product.map((id) => id.toString()) || [],
    );

    const result = products.map((product) => ({
      ...product.toObject(),
      isFavourite: wishlistIds.has(product._id.toString()),
    }));

    return res.status(200).json({
      status: "Success",
      products: result,
      noOfProducts: result.length,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
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
      message: "Internal Server Error",
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
      message: "Internal Server Error",
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
      message: "Internal Server Error",
    });
  }
};
