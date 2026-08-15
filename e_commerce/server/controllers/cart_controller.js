import mongoose from "mongoose";
import { Cart } from "../models/cart_model.js";
import { Product } from "../models/product_model.js";
import { Variant } from "../models/product_variants_model.js";
import { User } from "../models/user_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";

export const createCart = async (req, res) => {
  try {
    const { user, products } = req.body;

    // 1. check if product exists
    const product = await Product.findById(products[0].product);
    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }

    // 2. check if variant exists
    const variant = await Variant.findById(products[0].variant);
    if (!variant) {
      return res.status(400).json({
        status: "Failed",
        message: "No Variant Found With This ID",
      });
    }

    // 3. check if variant exists for this product
    const variantOfProduct = await Variant.findOne({
      _id: products[0].variant,
      product: products[0].product,
    });
    
    if (!variantOfProduct) {
      return res.status(400).json({
        status: "Failed",
        message: "No Variant With This ID Found For This Product",
      });
    }

    const existingCart = await Cart.findOne({ user });

    // 4. User doesn't have a cart
    if (!existingCart) {
      const cart = await Cart.create(req.body);
      if (!cart) {
        return res.status(400).json({
          status: "Failed",
          message: "Cart is not created",
        });
      }
      return res.status(201).json({
        status: "Success",
        message: "Product added to cart successfully",
      });
    }

    // 5. User have cart
    let flag = false;
    for (const el of existingCart.products) {
      if (
        el.product.equals(products[0].product) &&
        el.variant.equals(products[0].variant)
      ) {
        flag = true;
        // 6. check for stock here in addittion to the stock calculated in the route
        const newQuantity = el.quantity + products[0].quantity;
        if (newQuantity > variant.stock) {
          return res.status(400).json({
            status: "Failed",
            message: `Quantity specified is not available! only ${variant.stock} pieces are available`,
          });
        }
        el.quantity = newQuantity;
      }
    }

    // 7. If same variant and product increase quantity
    if (flag) {
      await existingCart.save();
      return res.status(201).json({
        status: "Success",
        message: "Quantity increased successfully",
      });
    }

    // 8. If new variant or product add new product
    existingCart.products.push(products[0]);
    await existingCart.save();
    return res.status(200).json({
      status: "Success",
      message: "Product added successfully with this specific variant",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal server error",
    });
  }
};

export const getAllCarts = async (req, res) => {
  try {
    const { filter, skip, limits, sortBy } = apiFeatures(req.query);
    const carts = await Cart.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy)
      .select("-__v");
    if (!carts || carts.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "No cart found",
      });
    }
    return res.status(200).json({
      status: "Success",
      carts,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateCart = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedCart = await Cart.findByIdAndUpdate(id, req.body, {
      returnDocument: "after",
    });
    if (!updatedCart) {
      return res.status(400).json({
        status: "Failed",
        message: "Something went wrong while updating cart!",
      });
    }
    return res.status(200).json({
      status: "Success",
      updatedCart,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteCart = async (req, res) => {
  try {
    const { id } = req.params;
    const deletedCart = await Cart.findByIdAndDelete(id);
    if (!deletedCart) {
      return res.status(400).json({
        status: "Failed",
        message: "Something went wrong while deleting cart!",
      });
    }
    return res.status(200).json({
      status: "Success",
      message: "Cart deleted successfully",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
