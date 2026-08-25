import { Order } from "../models/order_model.js";
import { Product } from "../models/product_model.js";
import { Variant } from "../models/product_variants_model.js";
import { User } from "../models/user_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";
import {
  createNotification,
  deleteNotification,
  updateNotification,
} from "./notification_controller.js";

export const createOrder = async (req, res) => {
  try {
    const { products } = req.body;
    const userId = req.user.id;
    console.log(userId);
    if (!products || products.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "Cannot make order without products",
      });
    }
    let totalPrice = 0;
    for (const el of products) {
      const variant = await Variant.findById(el.variant);
      if (!variant) {
        return res.status(404).json({
          message: "variant not found",
        });
      }
      totalPrice += el.price * el.quantity;
      await Variant.findByIdAndUpdate(el.variant, {
        $inc: {
          stock: -el.quantity,
          soldCount: el.quantity,
        },
      });
    }

    const order = await Order.create({
      user: userId,
      ...req.body,
      totalPrice,
    });
    if (!order) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating an order",
      });
    }

    const user = await User.findById(userId);
    console.log("user", user);
    console.log("token", user.fcm_token);
    await createNotification({
      title: "Order Created Successfuly",
      body: `Order Status is ${order.orderStatus}`,
      fcm_token: user.fcm_token,
      userId: user.id,
      type: "ORDER",
    });

    return res.status(200).json({
      status: "Success",
      order,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllOrders = async (req, res) => {
  try {
    const query = { ...req.params, ...req.query };
    const { filter, limits, skip, sortBy } = apiFeatures(query);
    const orders = await Order.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy)
      .populate("products.product");
    if (!orders) {
      return res.status(400).json({
        status: "Failed",
        message: "No order found",
      });
    }
    return res.status(200).json({
      status: "Success",
      orders,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getOrder = async (req, res) => {
  try {
    const { id } = req.params;
    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).json({
        status: "Failed",
        message: "No Order Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      order,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateOrder = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedOrder = await Order.findByIdAndUpdate(id, req.body, {
      returnDocument: "after",
    });
    if (!updatedOrder) {
      return res.status(404).json({
        status: "Failed",
        message: "No Order Found With This ID",
      });
    }
    if (req.body?.orderStatus) {
      const user = await User.findById(updatedOrder.user);
      await createNotification({
        title: "Order Status Changed",
        body: `Order Status is ${req.body.orderStatus}`,
        fcm_token: user.fcm_token,
        userId: user.id,
        type: "ORDER",
      });
    }
    return res.status(200).json({
      status: "Success",
      updatedOrder,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteOrder = async (req, res) => {
  try {
    const { id } = req.params;
    const order = await Order.findByIdAndDelete(id);
    if (!order) {
      return res.status(404).json({
        status: "Failed",
        message: "No Order Found With This ID",
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
