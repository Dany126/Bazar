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

/*
 * ============================================================
 * CREATE ORDER
 * ============================================================
 *
 * Used for:
 * 1. CASH orders
 * 2. Creating the REAL order after successful CARD payment
 *
 * Prices are ALWAYS taken from the database.
 */
export const createOrder = async (req, res) => {
  try {
    const { products, shippingAddress, paymentMethod } = req.body;
    const userId = req.user.id;

    if (!products || !Array.isArray(products) || products.length === 0) {
      return res.status(400).json({
        status: "Failed",
        message: "Cannot make order without products",
      });
    }

    if (!paymentMethod) {
      return res.status(400).json({
        status: "Failed",
        message: "Payment method is required",
      });
    }

    if (!["cash", "card"].includes(paymentMethod)) {
      return res.status(400).json({
        status: "Failed",
        message: "Invalid payment method",
      });
    }

    /*
     * Get all variants in one query.
     */
    const variantIds = products.map((item) => item.variant);

    const variants = await Variant.find({
      _id: { $in: variantIds },
    }).populate("product");

    const variantMap = new Map(
      variants.map((variant) => [
        variant._id.toString(),
        variant,
      ]),
    );

    const orderProducts = [];
    let totalPrice = 0;

    /*
     * Validate every product.
     */
    for (const item of products) {
      const variant = variantMap.get(
        String(item.variant),
      );

      if (!variant) {
        return res.status(404).json({
          status: "Failed",
          message: "Product variant not found",
        });
      }

      /*
       * Make sure this variant belongs to the
       * product sent by Flutter.
       */
      if (
        !variant.product ||
        variant.product._id.toString() !==
          String(item.product)
      ) {
        return res.status(400).json({
          status: "Failed",
          message: "Variant does not belong to this product",
        });
      }

      /*
       * Validate quantity.
       */
      const quantity = Number(item.quantity);

      if (
        !Number.isInteger(quantity) ||
        quantity <= 0
      ) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid product quantity",
        });
      }

      /*
       * Validate stock.
       */
      if (variant.stock < quantity) {
        return res.status(400).json({
          status: "Failed",
          message:
            `Not enough stock for ${variant.product.name}. ` +
            `Available stock: ${variant.stock}`,
        });
      }

      /*
       * IMPORTANT:
       *
       * Variant.price is the actual customer price.
       *
       * Do NOT use:
       * product.price + variant.price
       */
      const price = Number(variant.price);

      if (!Number.isFinite(price) || price < 0) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid variant price",
        });
      }

      orderProducts.push({
        product: variant.product._id,
        variant: variant._id,
        quantity,
        price,
      });

      totalPrice += price * quantity;
    }

    totalPrice = Number(totalPrice.toFixed(2));

    /*
     * Decrease stock and increase sold count.
     */
    for (const item of orderProducts) {
      const updatedVariant =
        await Variant.findOneAndUpdate(
          {
            _id: item.variant,
            stock: { $gte: item.quantity },
          },
          {
            $inc: {
              stock: -item.quantity,
              soldCount: item.quantity,
            },
          },
          {
            new: true,
          },
        );

      /*
       * This protects against two users buying
       * the last item simultaneously.
       */
      if (!updatedVariant) {
        return res.status(400).json({
          status: "Failed",
          message:
            "Some products are no longer available in the requested quantity",
        });
      }
    }

    /*
     * Create order.
     */
    const order = await Order.create({
      user: userId,
      products: orderProducts,
      totalPrice,
      shippingAddress,
      paymentMethod,
      paymentStatus:
        paymentMethod === "cash"
          ? "pending"
          : "paid",
      orderStatus: "pending",
    });

    if (!order) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating an order",
      });
    }

    /*
     * Mark visitor as converted.
     */
    if (order.visitorId) {
      const monthKey =
        `${order.createdAt.getUTCFullYear()}-` +
        `${String(
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

    return res.status(200).json({
      status: "Success",
      message: "Order Placed Successfully",
      order,
    });
  } catch (error) {
    console.error("CREATE ORDER ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message:
        error.message || "Internal Server Error",
    });
  }
};

/*
 * ============================================================
 * GET ALL ORDERS
 * ============================================================
 */
export const getAllOrders = async (req, res) => {
  try {
    res.set(
      "Cache-Control",
      "no-store, no-cache, must-revalidate, proxy-revalidate",
    );
    res.set("Pragma", "no-cache");
    res.set("Expires", "0");
    res.set("Surrogate-Control", "no-store");

    const query = {
      ...req.params,
      ...req.query,
    };

    const {
      filter,
      limits,
      skip,
      sortBy,
    } = apiFeatures(query);

    const page = Number(query.page) || 1;
    const limit = Number(query.limit) || 10;

    const [orders, totalOrders] =
      await Promise.all([
        Order.find(filter)
          .limit(limits)
          .skip(skip)
          .sort(sortBy)
          .populate("products.product")
          .populate("products.variant")
          .populate("user", "-password"),

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
  } catch (error) {
    console.error("GET ALL ORDERS ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message:
        error.message || "Internal Server Error",
    });
  }
};

/*
 * ============================================================
 * GET ONE ORDER
 * ============================================================
 */
export const getOrder = async (req, res) => {
  try {
    const { id } = req.params;

    const order = await Order.findById(id)
      .populate("products.product")
      .populate("products.variant")
      .populate("user", "-password");

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
  } catch (error) {
    console.error("GET ORDER ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message:
        error.message || "Internal Server Error",
    });
  }
};

/*
 * ============================================================
 * UPDATE ORDER
 * ============================================================
 */
export const updateOrder = async (req, res) => {
  try {
    const { id } = req.params;

    const updatedOrder =
      await Order.findByIdAndUpdate(
        id,
        req.body,
        {
          new: true,
          runValidators: true,
        },
      );

    if (!updatedOrder) {
      return res.status(404).json({
        status: "Failed",
        message: "No Order Found With This ID",
      });
    }

    /*
     * Send notification when order status changes.
     */
    if (req.body?.orderStatus) {
      const user = await User.findById(
        updatedOrder.user,
      );

      if (user) {
        try {
          await createNotification({
            title: "Order Status Changed",
            body:
              `Order Status is ${req.body.orderStatus}`,
            fcm_token: user.fcm_token,
            userId: user.id,
            type: "ORDER",
          });
        } catch (notificationError) {
          console.error(
            "ORDER NOTIFICATION ERROR:",
            notificationError,
          );
        }
      }
    }

    return res.status(200).json({
      status: "Success",
      updatedOrder,
    });
  } catch (error) {
    console.error("UPDATE ORDER ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message:
        error.message || "Internal Server Error",
    });
  }
};

/*
 * ============================================================
 * DELETE ORDER
 * ============================================================
 */
export const deleteOrder = async (req, res) => {
  try {
    const { id } = req.params;

    const order =
      await Order.findByIdAndDelete(id);

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
  } catch (error) {
    console.error("DELETE ORDER ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message:
        error.message || "Internal Server Error",
    });
  }
};