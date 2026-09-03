import mongoose from "mongoose";
import { Order } from "../models/order_model.js";
import { StoreSettings } from "../models/store_settings_model.js";

const normalizeStatus = (paymentStatus) => {
  switch (paymentStatus) {
    case "paid":
      return "completed";
    case "failed":
      return "failed";
    case "pending":
    default:
      return "pending";
  }
};

const buildSearchFilter = (search) => {
  if (!search) {
    return {};
  }

  const value = search.trim();

  if (!value) {
    return {};
  }

  const conditions = [
    {
      paymentMethod: {
        $regex: value,
        $options: "i",
      },
    },
    {
      paymentStatus: {
        $regex: value,
        $options: "i",
      },
    },
  ];

  if (mongoose.Types.ObjectId.isValid(value)) {
    conditions.push({
      _id: new mongoose.Types.ObjectId(value),
    });

    conditions.push({
      user: new mongoose.Types.ObjectId(value),
    });
  }

  return {
    $or: conditions,
  };
};

const buildDateFilter = (from, to) => {
  if (!from && !to) {
    return {};
  }

  const createdAt = {};

  if (from) {
    const fromDate = new Date(from);

    if (!Number.isNaN(fromDate.getTime())) {
      createdAt.$gte = fromDate;
    }
  }

  if (to) {
    const toDate = new Date(to);

    if (!Number.isNaN(toDate.getTime())) {
      toDate.setHours(23, 59, 59, 999);
      createdAt.$lte = toDate;
    }
  }

  if (Object.keys(createdAt).length === 0) {
    return {};
  }

  return { createdAt };
};

const serializeTransaction = (order) => {
  const user = order.user;

  return {
    id: order._id.toString(),
    orderId: order._id.toString(),

    customer: user
      ? {
          id: user._id.toString(),
          name: user.name ?? "",
          email: user.email ?? "",
        }
      : null,

    amount: Number(order.totalPrice ?? 0),

    paymentMethod: order.paymentMethod,

    paymentStatus: order.paymentStatus,

    transactionStatus: normalizeStatus(order.paymentStatus),

    orderStatus: order.orderStatus,

    createdAt: order.createdAt,

    updatedAt: order.updatedAt,
  };
};

/**
 * GET /api/admin/transactions
 *
 * Admin only.
 *
 * Query:
 * ?search=
 * ?status=all|pending|completed|failed
 * ?paymentMethod=all|card|cash
 * ?page=1
 * ?limit=20
 * ?from=2026-01-01
 * ?to=2026-12-31
 */
export const getAdminTransactions = async (req, res) => {
  try {
    const {
      search = "",
      status = "all",
      paymentMethod = "all",
      page = 1,
      limit = 20,
      from,
      to,
    } = req.query;

    const currentPage = Math.max(Number(page) || 1, 1);
    const pageSize = Math.min(Math.max(Number(limit) || 20, 1), 100);

    const filter = {
      ...buildSearchFilter(search),
      ...buildDateFilter(from, to),
    };

    if (paymentMethod !== "all") {
      if (!["cash", "card"].includes(paymentMethod)) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid payment method",
        });
      }

      filter.paymentMethod = paymentMethod;
    }

    if (status !== "all") {
      const paymentStatusMap = {
        pending: "pending",
        completed: "paid",
        failed: "failed",
      };

      const paymentStatus = paymentStatusMap[status];

      if (!paymentStatus) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid transaction status",
        });
      }

      filter.paymentStatus = paymentStatus;
    }

    const skip = (currentPage - 1) * pageSize;

    const [
      orders,
      totalCount,
      summaryAggregation,
      settings,
    ] = await Promise.all([
      Order.find(filter)
        .populate("user", "name email")
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(pageSize)
        .lean(),

      Order.countDocuments(filter),

      Order.aggregate([
        {
          $match: filter,
        },
        {
          $group: {
            _id: null,

            totalAmount: {
              $sum: "$totalPrice",
            },

            paidAmount: {
              $sum: {
                $cond: [
                  {
                    $eq: ["$paymentStatus", "paid"],
                  },
                  "$totalPrice",
                  0,
                ],
              },
            },

            pendingAmount: {
              $sum: {
                $cond: [
                  {
                    $eq: ["$paymentStatus", "pending"],
                  },
                  "$totalPrice",
                  0,
                ],
              },
            },

            failedAmount: {
              $sum: {
                $cond: [
                  {
                    $eq: ["$paymentStatus", "failed"],
                  },
                  "$totalPrice",
                  0,
                ],
              },
            },

            completedCount: {
              $sum: {
                $cond: [
                  {
                    $eq: ["$paymentStatus", "paid"],
                  },
                  1,
                  0,
                ],
              },
            },

            pendingCount: {
              $sum: {
                $cond: [
                  {
                    $eq: ["$paymentStatus", "pending"],
                  },
                  1,
                  0,
                ],
              },
            },

            failedCount: {
              $sum: {
                $cond: [
                  {
                    $eq: ["$paymentStatus", "failed"],
                  },
                  1,
                  0,
                ],
              },
            },
          },
        },
      ]),

      StoreSettings.findOne().select("currency").lean(),
    ]);

    const summary = summaryAggregation[0] ?? {
      totalAmount: 0,
      paidAmount: 0,
      pendingAmount: 0,
      failedAmount: 0,
      completedCount: 0,
      pendingCount: 0,
      failedCount: 0,
    };

    const transactions = orders.map(serializeTransaction);

    return res.status(200).json({
      status: "Success",

      data: {
        transactions,

        summary: {
          totalAmount: Number(summary.totalAmount ?? 0),
          paidAmount: Number(summary.paidAmount ?? 0),
          pendingAmount: Number(summary.pendingAmount ?? 0),
          failedAmount: Number(summary.failedAmount ?? 0),

          completedCount: Number(summary.completedCount ?? 0),
          pendingCount: Number(summary.pendingCount ?? 0),
          failedCount: Number(summary.failedCount ?? 0),
        },

        currency: settings?.currency ?? "",

        pagination: {
          page: currentPage,
          limit: pageSize,
          total: totalCount,
          pages: Math.ceil(totalCount / pageSize),
          hasNextPage: currentPage * pageSize < totalCount,
          hasPreviousPage: currentPage > 1,
        },
      },
    });
  } catch (error) {
    console.error("GET ADMIN TRANSACTIONS ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message: "Could not load transactions",
    });
  }
};

/**
 * GET /api/admin/transactions/:id
 */
export const getAdminTransaction = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "Failed",
        message: "Invalid transaction ID",
      });
    }

    const order = await Order.findById(id)
      .populate("user", "name email phone")
      .populate("products.product")
      .populate("products.variant")
      .lean();

    if (!order) {
      return res.status(404).json({
        status: "Failed",
        message: "Transaction not found",
      });
    }

    const settings = await StoreSettings.findOne()
      .select("currency")
      .lean();

    return res.status(200).json({
      status: "Success",

      data: {
        transaction: {
          ...serializeTransaction(order),

          customer: order.user
            ? {
                id: order.user._id.toString(),
                name: order.user.name ?? "",
                email: order.user.email ?? "",
                phone: order.user.phone ?? "",
              }
            : null,

          shippingAddress: order.shippingAddress ?? null,

          products: (order.products ?? []).map((item) => ({
            product: item.product
              ? {
                  id: item.product._id?.toString(),
                  name: item.product.name,
                }
              : null,

            variant: item.variant
              ? {
                  id: item.variant._id?.toString(),
                }
              : null,

            quantity: item.quantity,
            price: item.price,
          })),

          currency: settings?.currency ?? "",
        },
      },
    });
  } catch (error) {
    console.error("GET ADMIN TRANSACTION ERROR:", error);

    return res.status(500).json({
      status: "Failed",
      message: "Could not load transaction",
    });
  }
};