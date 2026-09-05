// import { Order } from "../models/order_model.js";
// import { Variant } from "../models/product_variants_model.js";
// import { User } from "../models/user_model.js";
// import { apiFeatures } from "../utils/apiFeatures.js";
// import { createNotification } from "./notification_controller.js";
// import { Visitor } from "../models/visitor_model.js";

// export const createOrder = async (req, res) => {
//   try {
//     // get order specifications(product, variant, quantity, price) from body
//     const { products } = req.body;

//     const userId = req.user.id;

//     // check if no order specifications
//     if (!products || products.length <= 0) {
//       return res.status(400).json({
//         status: "Failed",
//         message: "Cannot make order without products",
//       });
//     }
//     let totalPrice = 0;

//     // get all variants id in one array to prevent multiple DB queries
//     const variantIDs = products.map((item) => item.variant);

//     // get all variants from db
//     const variants = await Variant.find({
//       _id: { $in: variantIDs },
//     }).populate("product");

//     // put them in a map
//     const variantMap = new Map(variants.map((v) => [v._id.toString(), v]));

//     for (const el of products) {
//       // get variant from map using the variant id
//       const variant = variantMap.get(el.variant.toString());

//       // check whether variant exists
//       if (!variant) {
//         return res.status(404).json({
//           message: "No Variant Found With This ID!",
//         });
//       }

//       // check whether variant exists for this product
//       if (!variant.product.equals(el.product)) {
//         return res.status(404).json({
//           status: "Failed",
//           message: "No Variant With This ID Found For This Product!",
//         });
//       }

//       const expectedPrice = variant.product.price + variant.price;

//       // check whether the price sent by the client is correct
//       if (Math.abs(clientPrice - expectedPrice) > 0.000001) {
//         return res.status(400).json({
//           status: "Failed",
//           message: "Invalid product price",
//         });
//       }

//       // calculate total price and change the stock and soldCount
//       totalPrice += (variant.product.price + variant.price) * el.quantity;
//       await Variant.findByIdAndUpdate(el.variant, {
//         $inc: {
//           stock: -el.quantity,
//           soldCount: el.quantity,
//         },
//       });
//     }

//     // Place The Order
//     const order = await Order.create({
//       user: userId,
//       ...req.body,
//       totalPrice,
//     });

//     // Check if there is a problem creating order
//     if (!order) {
//       return res.status(400).json({
//         status: "Failed",
//         message: "Failed creating an order",
//       });
//     }
//     if (order.visitorId) {
//   const monthKey =
//     `${order.createdAt.getUTCFullYear()}-${String(
//       order.createdAt.getUTCMonth() + 1,
//     ).padStart(2, "0")}`;

//   await Visitor.findOneAndUpdate(
//     {
//       visitorId:
//         order.visitorId,

//       monthKey,
//     },
//     {
//       $set: {
//         converted: true,
//         lastSeenAt:
//           order.createdAt,
//       },

//       $setOnInsert: {
//         visitorId:
//           order.visitorId,

//         monthKey,

//         converted: true,
//       },
//     },
//     {
//       upsert: true,
//       new: true,
//       setDefaultsOnInsert:
//         true,
//     },
//   );
// }

//     return res.status(200).json({
//       status: "Success",
//       message: "Order Placed Successfully",
//       order,
//     });
//   } catch (err) {
//     console.log(err);
//     return res.status(500).json({
//       status: "Failed",
//       message: "Internal Server Error",
//     });
//   }
// };

// export const getAllOrders = async (req, res) => {
  
//   try {
//     res.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
// res.set("Pragma", "no-cache");
// res.set("Expires", "0");
// res.set("Surrogate-Control", "no-store");
//     const query = { ...req.params, ...req.query };

//     const { filter, limits, skip, sortBy } =
//       apiFeatures(query);

//     const page = Number(query.page) || 1;
//     const limit = Number(query.limit) || 10;

//     const [orders, totalOrders] = await Promise.all([
//       Order.find(filter)
//         .limit(limits)
//         .skip(skip)
//         .sort(sortBy)
//         .populate("products.product"),

//       Order.countDocuments(filter),
//     ]);

//     const totalPages =
//       totalOrders === 0
//         ? 1
//         : Math.ceil(totalOrders / limit);

//     return res.status(200).json({
//       status: "Success",

//       orders,

//       noOfOrders: orders.length,

//       pagination: {
//         currentPage: page,
//         itemsPerPage: limit,
//         totalOrders,
//         totalPages,
//         hasPreviousPage: page > 1,
//         hasNextPage: page < totalPages,
//       },
//     });
//   } catch (err) {
//     console.log(err);

//     return res.status(500).json({
//       status: "Failed",
//       message: "Internal Server Error",
//     });
//   }
// };

// export const getOrder = async (req, res) => {
//   try {
//     const { id } = req.params;
//     const order = await Order.findById(id);
//     if (!order) {
//       return res.status(404).json({
//         status: "Failed",
//         message: "No Order Found With This ID",
//       });
//     }
//     return res.status(200).json({
//       status: "Success",
//       order,
//     });
//   } catch (err) {
//     console.log(err);
//     return res.status(500).json({
//       status: "Failed",
//       message: "Internal Server Error",
//     });
//   }
// };

// export const updateOrder = async (req, res) => {
//   try {
//     const { id } = req.params;
//     const updatedOrder = await Order.findByIdAndUpdate(id, req.body, {
//       returnDocument: "after",
//     });
//     if (!updatedOrder) {
//       return res.status(404).json({
//         status: "Failed",
//         message: "No Order Found With This ID",
//       });
//     }
//     if (req.body?.orderStatus) {
//       const user = await User.findById(updatedOrder.user);
//       await createNotification({
//         title: "Order Status Changed",
//         body: `Order Status is ${req.body.orderStatus}`,
//         fcm_token: user.fcm_token,
//         userId: user.id,
//         type: "ORDER",
//       });
//     }
//     return res.status(200).json({
//       status: "Success",
//       updatedOrder,
//     });
//   } catch (err) {
//     console.log(err);
//     return res.status(500).json({
//       status: "Failed",
//       message: "Internal Server Error",
//     });
//   }
// };

// export const deleteOrder = async (req, res) => {
//   try {
//     const { id } = req.params;
//     const order = await Order.findByIdAndDelete(id);
//     if (!order) {
//       return res.status(404).json({
//         status: "Failed",
//         message: "No Order Found With This ID",
//       });
//     }
//     return res.status(200).json({
//       status: "Success",
//       message: "Product Deleted Successfuly",
//     });
//   } catch (err) {
//     console.log(err);
//     return res.status(500).json({
//       status: "Failed",
//       message: "Internal Server Error",
//     });
//   }
// };
import { Order } from "../models/order_model.js";
import { Variant } from "../models/product_variants_model.js";
import { User } from "../models/user_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";
import { createNotification } from "./notification_controller.js";
import { Visitor } from "../models/visitor_model.js";

export const createOrder = async (req, res) => {
  try {
    console.log("======================================");
    console.log("CREATE ORDER START");
    console.log("USER:", req.user.id);
    console.log("BODY:", JSON.stringify(req.body, null, 2));

    const { products, shippingAddress, paymentMethod, visitorId } = req.body;

    const userId = req.user.id;

    if (!products || products.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "Cannot make order without products",
      });
    }

    // Get all variants in one database query
    const variantIDs = products.map((item) => item.variant);

    console.log("GETTING VARIANTS...");

    const variants = await Variant.find({
      _id: { $in: variantIDs },
    }).populate("product");

    console.log("VARIANTS FOUND:", variants.length);

    const variantMap = new Map(
      variants.map((variant) => [variant._id.toString(), variant]),
    );

    const orderProducts = [];
    let totalPrice = 0;

    for (const item of products) {
      console.log("--------------------------------------");
      console.log("VALIDATING ITEM");
      console.log("Product:", item.product);
      console.log("Variant:", item.variant);
      console.log("Quantity:", item.quantity);

      const variant = variantMap.get(item.variant.toString());

      if (!variant) {
        return res.status(404).json({
          status: "Failed",
          message: "No Variant Found With This ID!",
        });
      }

      // Check that the variant belongs to this product
      if (!variant.product._id.equals(item.product)) {
        return res.status(404).json({
          status: "Failed",
          message: "No Variant With This ID Found For This Product!",
        });
      }

      if (!item.quantity || Number(item.quantity) <= 0) {
        return res.status(400).json({
          status: "Failed",
          message: "Quantity must be greater than 0",
        });
      }

      if (variant.stock < Number(item.quantity)) {
        return res.status(400).json({
          status: "Failed",
          message: `Not enough stock. Available stock: ${variant.stock}`,
        });
      }

      // Variant price is the final price paid by the customer
      const expectedPrice = Number(variant.price);

      const clientPrice =
        item.price !== undefined && item.price !== null
          ? Number(item.price)
          : null;

      console.log("STOCK:", variant.stock);
      console.log("PRODUCT PRICE:", variant.product.price);
      console.log("VARIANT PRICE:", variant.price);
      console.log("EXPECTED PRICE:", expectedPrice);
      console.log("CLIENT PRICE:", clientPrice);

      // Validate the price sent by Flutter
      if (
        clientPrice !== null &&
        Math.abs(clientPrice - expectedPrice) > 0.000001
      ) {
        console.log("PRICE MISMATCH");

        return res.status(400).json({
          status: "Failed",
          message: `Invalid product price. Expected ${expectedPrice}, received ${clientPrice}`,
        });
      }

      // Use the database price instead of trusting the client price
      orderProducts.push({
        product: item.product,
        variant: item.variant,
        quantity: Number(item.quantity),
        price: expectedPrice,
      });

      totalPrice += expectedPrice * Number(item.quantity);
    }

    console.log("ORDER TOTAL:", totalPrice);

    // Create the order using server-calculated prices
    const order = await Order.create({
      user: userId,
      products: orderProducts,
      totalPrice,
      shippingAddress,
      paymentMethod,
      paymentStatus: req.body.paymentStatus || "pending",
      visitorId: visitorId || null,
    });

    if (!order) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating an order",
      });
    }

    // Update stock only after the order is successfully created
    for (const item of orderProducts) {
      await Variant.findByIdAndUpdate(item.variant, {
        $inc: {
          stock: -item.quantity,
          soldCount: item.quantity,
        },
      });
    }

    // Mark the visitor as converted
    if (order.visitorId) {
      const monthKey =
        `${order.createdAt.getUTCFullYear()}-${String(
          order.createdAt.getUTCMonth() + 1,
        ).padStart(2, "0")}`;

      await Visitor.findOneAndUpdate(
        {
          visitorId: order.visitorId,
          monthKey,
        },
        {
          $set: {
            converted: true,
            lastSeenAt: order.createdAt,
          },
          $setOnInsert: {
            visitorId: order.visitorId,
            monthKey,
            converted: true,
          },
        },
        {
          upsert: true,
          new: true,
          setDefaultsOnInsert: true,
        },
      );
    }

    console.log("ORDER CREATED:", order._id);
    console.log("CREATE ORDER SUCCESS");
    console.log("======================================");

    return res.status(200).json({
      status: "Success",
      message: "Order Placed Successfully",
      order,
    });
  } catch (err) {
    console.log("CREATE ORDER ERROR:", err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllOrders = async (req, res) => {
  try {
    res.set(
      "Cache-Control",
      "no-store, no-cache, must-revalidate, proxy-revalidate",
    );
    res.set("Pragma", "no-cache");
    res.set("Expires", "0");
    res.set("Surrogate-Control", "no-store");

    const query = { ...req.params, ...req.query };

    const { filter, limits, skip, sortBy } = apiFeatures(query);

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
      totalOrders === 0 ? 1 : Math.ceil(totalOrders / limit);

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

      if (user) {
        await createNotification({
          title: "Order Status Changed",
          body: `Order Status is ${req.body.orderStatus}`,
          fcm_token: user.fcm_token,
          userId: user.id,
          type: "ORDER",
        });
      }
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
      message: "Order Deleted Successfully",
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
