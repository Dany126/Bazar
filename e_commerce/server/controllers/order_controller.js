import { Order } from "../models/order_model.js";
import { Variant } from "../models/product_variants_model.js";
import { User } from "../models/user_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";
import { createNotification } from "./notification_controller.js";
import { Visitor } from "../models/visitor_model.js";

export const createOrder = async (req, res) => {
  try {
    // get order specifications(product, variant, quantity, price) from body
    const { products } = req.body;

    const userId = req.user.id;

    // check if no order specifications
    if (!products || products.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "Cannot make order without products",
      });
    }
    let totalPrice = 0;

    // get all variants id in one array to prevent multiple DB queries
    const variantIDs = products.map((item) => item.variant);

    // get all variants from db
    const variants = await Variant.find({
      _id: { $in: variantIDs },
    }).populate("product");

    // put them in a map
    const variantMap = new Map(variants.map((v) => [v._id.toString(), v]));

    for (const el of products) {
      // get variant from map using the variant id
      const variant = variantMap.get(el.variant.toString());

      // check whether variant exists
      if (!variant) {
        return res.status(404).json({
          message: "No Variant Found With This ID!",
        });
      }

      // check whether variant exists for this product
      if (!variant.product.equals(el.product)) {
        return res.status(404).json({
          status: "Failed",
          message: "No Variant With This ID Found For This Product!",
        });
      }

      const expectedPrice = variant.product.price + variant.price;

      // check whether the price sent by the client is correct
      if (el.price !== expectedPrice) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid product price",
        });
      }

      // calculate total price and change the stock and soldCount
      totalPrice += (variant.product.price + variant.price) * el.quantity;
      await Variant.findByIdAndUpdate(el.variant, {
        $inc: {
          stock: -el.quantity,
          soldCount: el.quantity,
        },
      });
    }

    // Place The Order
    const order = await Order.create({
      user: userId,
      ...req.body,
      totalPrice,
    });

    // Check if there is a problem creating order
    if (!order) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating an order",
      });
    }
    if (order.visitorId) {
  const monthKey =
    `${order.createdAt.getUTCFullYear()}-${String(
      order.createdAt.getUTCMonth() + 1,
    ).padStart(2, "0")}`;

  await Visitor.findOneAndUpdate(
    {
      visitorId:
        order.visitorId,

      monthKey,
    },
    {
      $set: {
        converted: true,
        lastSeenAt:
          order.createdAt,
      },

      $setOnInsert: {
        visitorId:
          order.visitorId,

        monthKey,

        converted: true,
      },
    },
    {
      upsert: true,
      new: true,
      setDefaultsOnInsert:
        true,
    },
  );
}

    return res.status(200).json({
      status: "Success",
      message: "Order Placed Successfully",
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
    res.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
res.set("Pragma", "no-cache");
res.set("Expires", "0");
res.set("Surrogate-Control", "no-store");
    const query = { ...req.params, ...req.query };

    const { filter, limits, skip, sortBy } =
      apiFeatures(query);

    const page = Number(query.page) || 1;
    const limit = Number(query.limit) || 10;

    const [orders, totalOrders] = await Promise.all([
      Order.find(filter)
        .limit(limits)
        .skip(skip)
        .sort(sortBy)
        .populate("products.product"),

      Order.countDocuments(filter),
    ]);

    const totalPages =
      totalOrders === 0
        ? 1
        : Math.ceil(totalOrders / limit);

    return res.status(200).json({
      status: "Success",

      orders,

      noOfOrders: orders.length,

      pagination: {
        currentPage: page,
        itemsPerPage: limit,
        totalOrders,
        totalPages,
        hasPreviousPage: page > 1,
        hasNextPage: page < totalPages,
      },
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
