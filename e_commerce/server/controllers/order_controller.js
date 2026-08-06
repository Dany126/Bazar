import { Order } from "../models/order_model.js";
import { Product } from "../models/product_model.js";

export const createOrder = async (req, res) => {
  try {
    const { products } = req.body;
    if (!products || products.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "Cannot make order without products",
      });
    }
    for (const el of products) {
      await Product.findByIdAndUpdate(el.product, {
        $inc: {
          stock: -el.quantity,
          soldCount: el.quantity,
        },
      });
    }
    const order = await Order.create(req.body);
    if (!order) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating an order",
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
      message: "Something went wrong",
    });
  }
};

export const getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find();
    if (!orders) {
      return res.status(400).json({
        status: "Failed",
        message: "No order found",
      });
    }
    return res.status(200).json({
      status: "Success",
      data: {
        orders,
      },
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
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
      message: "Something went wrong",
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
    return res.status(200).json({
      status: "Success",
      updatedOrder,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
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
      message: "Something went wrong",
    });
  }
};
