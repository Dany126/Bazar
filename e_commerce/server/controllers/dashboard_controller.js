import { Order } from "../models/order_model.js";
import { Product } from "../models/product_model.js";
import { Category } from "../models/category_model.js";
import { User } from "../models/user_model.js";
import { Variant } from "../models/product_variants_model.js";
import { Visitor } from "../models/visitor_model.js";
import { StoreSettings } from "../models/store_settings_model.js";

const DAY_MS = 24 * 60 * 60 * 1000;

const DEFAULT_LOW_STOCK_THRESHOLD = 15;

function getDateRange(period = "month") {
  const now = new Date();

  let start;
  let previousStart;
  let previousEnd;

  if (period === "week") {
    start = new Date(now);

    start.setHours(0, 0, 0, 0);

    const day = start.getDay();

    start.setDate(
      start.getDate() - day,
    );

    previousStart = new Date(
      start.getTime() - 7 * DAY_MS,
    );

    previousEnd = new Date(start);
  } else if (period === "year") {
    start = new Date(
      now.getFullYear(),
      0,
      1,
    );

    previousStart = new Date(
      now.getFullYear() - 1,
      0,
      1,
    );

    previousEnd = new Date(
      now.getFullYear(),
      0,
      1,
    );
  } else {
    start = new Date(
      now.getFullYear(),
      now.getMonth(),
      1,
    );

    previousStart = new Date(
      now.getFullYear(),
      now.getMonth() - 1,
      1,
    );

    previousEnd = new Date(
      now.getFullYear(),
      now.getMonth(),
      1,
    );
  }

  return {
    start,
    end: now,
    previousStart,
    previousEnd,
  };
}

function percentageChange(
  current,
  previous,
) {
  if (previous === 0) {
    return current === 0 ? 0 : null;
  }

  return (
    ((current - previous) /
      previous) *
    100
  );
}

function round(value, digits = 2) {
  const factor = 10 ** digits;

  return (
    Math.round(value * factor) /
    factor
  );
}

function isRevenueOrder(order) {
  return (
    order.paymentStatus === "paid" &&
    order.orderStatus !== "cancelled"
  );
}

function revenueFromOrders(orders) {
  return orders
    .filter(isRevenueOrder)
    .reduce(
      (sum, order) =>
        sum + Number(order.totalPrice || 0),
      0,
    );
}

async function getRevenue(
  start,
  end,
) {
  const result =
    await Order.aggregate([
      {
        $match: {
          createdAt: {
            $gte: start,
            $lt: end,
          },
          paymentStatus: "paid",
          orderStatus: {
            $ne: "cancelled",
          },
        },
      },
      {
        $group: {
          _id: null,
          total: {
            $sum: "$totalPrice",
          },
        },
      },
    ]);

  return Number(
    result[0]?.total ?? 0,
  );
}

export const getAdminDashboard =
  async (req, res) => {
    try {
      const period = [
        "week",
        "month",
        "year",
      ].includes(req.query.period)
        ? req.query.period
        : "month";

      const {
        start,
        end,
        previousStart,
        previousEnd,
      } = getDateRange(period);

      let storeSettings =
        await StoreSettings.findOne();

      if (!storeSettings) {
        storeSettings =
          await StoreSettings.create({
            storeName: "Bazar",
            description: "",
            email: "",
            phone: "",
            address: "",
            city: "",
            country: "",
            postalCode: "",
            currency: "EGP",
            taxRate: 0,
            shippingFee: 0,
            freeShippingThreshold: 0,
            minimumOrderAmount: 0,
            lowStockThreshold:
              DEFAULT_LOW_STOCK_THRESHOLD,
            storeEnabled: true,
            acceptOrders: true,
          });
      }

      const lowStockThreshold =
        Number(
          storeSettings.lowStockThreshold ??
            DEFAULT_LOW_STOCK_THRESHOLD,
        );

      const [
        totalProducts,
        totalCategories,
        totalUsers,
        totalOrders,
        currentOrders,
        previousOrders,
        currentVisitors,
        previousVisitors,
        currentConversionVisitors,
        previousConversionVisitors,
        categoryBreakdown,
        lowStockCount,
        lowInventory,
      ] = await Promise.all([
        Product.countDocuments(),

        Category.countDocuments(),

        User.countDocuments({
          role: {
            $not: {
              $regex: "^admin$",
              $options: "i",
            },
          },
        }),

        Order.countDocuments(),

        Order.find({
          createdAt: {
            $gte: start,
            $lt: end,
          },
        })
          .populate(
            "user",
            "name email",
          )
          .sort({
            createdAt: -1,
          }),

        Order.find({
          createdAt: {
            $gte: previousStart,
            $lt: previousEnd,
          },
        }),

        Visitor.countDocuments({
          createdAt: {
            $gte: start,
            $lt: end,
          },
        }),

        Visitor.countDocuments({
          createdAt: {
            $gte: previousStart,
            $lt: previousEnd,
          },
        }),

        Visitor.countDocuments({
          createdAt: {
            $gte: start,
            $lt: end,
          },
          converted: true,
        }),

        Visitor.countDocuments({
          createdAt: {
            $gte: previousStart,
            $lt: previousEnd,
          },
          converted: true,
        }),

        Product.aggregate([
          {
            $group: {
              _id: "$category",
              count: {
                $sum: 1,
              },
            },
          },

          {
            $lookup: {
              from: "categories",
              localField: "_id",
              foreignField: "_id",
              as: "category",
            },
          },

          {
            $unwind: "$category",
          },

          {
            $sort: {
              count: -1,
            },
          },

          {
            $project: {
              _id: 0,
              name: "$category.name",
              count: 1,
            },
          },
        ]),

        Variant.countDocuments({
          stock: {
            $lte: lowStockThreshold,
          },
        }),

        Variant.aggregate([
          {
            $match: {
              stock: {
                $lte: lowStockThreshold,
              },
            },
          },

          {
            $lookup: {
              from: "products",
              localField: "product",
              foreignField: "_id",
              as: "product",
            },
          },

          {
            $unwind: "$product",
          },

          {
            $sort: {
              stock: 1,
            },
          },

          {
            $limit: 10,
          },

          {
            $project: {
              _id: 1,
              productId:
                "$product._id",
              name:
                "$product.name",
              size: 1,
              color: 1,
              stock: 1,
            },
          },
        ]),
      ]);

      const currentRevenue =
        await getRevenue(
          start,
          end,
        );

      const previousRevenue =
        await getRevenue(
          previousStart,
          previousEnd,
        );

      const conversionRate =
        currentVisitors === 0
          ? null
          : round(
              (
                currentConversionVisitors /
                currentVisitors
              ) *
                100,
            );

      const previousConversionRate =
        previousVisitors === 0
          ? null
          : round(
              (
                previousConversionVisitors /
                previousVisitors
              ) *
                100,
            );

      const categoryTotal =
        categoryBreakdown.reduce(
          (sum, item) =>
            sum + Number(item.count || 0),
          0,
        );

      const categoryData =
        categoryBreakdown.map(
          (item) => ({
            name: item.name,
            count: Number(
              item.count || 0,
            ),
            percent:
              categoryTotal === 0
                ? 0
                : round(
                    (
                      Number(
                        item.count || 0,
                      ) /
                        categoryTotal
                    ) *
                      100,
                  ),
          }),
        );

      const recentOrders =
        currentOrders
          .slice(0, 6)
          .map((order) => ({
            id: String(order._id),

            customer:
              order.user?.name ??
              "Guest",

            total:
              Number(
                order.totalPrice || 0,
              ),

            status:
              order.orderStatus,

            paymentStatus:
              order.paymentStatus,

            createdAt:
              order.createdAt,
          }));

      const revenueChart =
        await buildRevenueChart(
          period,
          start,
          end,
        );

      const dashboard = {
        period,

        range: {
          start,
          end,
        },

        store: {
          name:
            storeSettings.storeName,

          currency:
            storeSettings.currency,

          storeEnabled:
            storeSettings.storeEnabled,

          acceptOrders:
            storeSettings.acceptOrders,

          lowStockThreshold,
        },

        stats: {
          totalRevenue:
            round(currentRevenue),

          periodRevenue:
            round(currentRevenue),

          totalOrders,

          periodOrders:
            currentOrders.length,

          totalProducts,

          totalCategories,

          totalUsers,

          totalVisitors:
            currentVisitors,

          conversionRate,

          lowStockAlerts:
            lowStockCount,

          changes: {
            revenue:
              percentageChange(
                currentRevenue,
                previousRevenue,
              ),

            orders:
              percentageChange(
                currentOrders.length,
                previousOrders.length,
              ),

            visitors:
              percentageChange(
                currentVisitors,
                previousVisitors,
              ),

            conversionRate:
              conversionRate === null ||
              previousConversionRate ===
                null
                ? null
                : round(
                    conversionRate -
                      previousConversionRate,
                    2,
                  ),
          },
        },

        categoryBreakdown:
          categoryData,

        revenueChart,

        recentOrders,

        lowInventory,
      };

      return res.status(200).json({
        status: "Success",
        dashboard,
      });
    } catch (err) {
      console.error(
        "Admin dashboard error:",
        err,
      );

      return res.status(500).json({
        status: "Failed",
        message:
          "Internal Server Error",
      });
    }
  };

async function buildRevenueChart(
  period,
  start,
  end,
) {
  const rows =
    await Order.aggregate([
      {
        $match: {
          createdAt: {
            $gte: start,
            $lt: end,
          },

          paymentStatus: "paid",

          orderStatus: {
            $ne: "cancelled",
          },
        },
      },

      {
        $group: {
          _id:
            period === "year"
              ? {
                  $month:
                    "$createdAt",
                }
              : period === "month"
                ? {
                    $dayOfMonth:
                      "$createdAt",
                  }
                : {
                    $dayOfWeek:
                      "$createdAt",
                  },

          revenue: {
            $sum: "$totalPrice",
          },
        },
      },
    ]);

  const map = new Map();

  for (const row of rows) {
    map.set(
      Number(row._id),
      round(
        Number(row.revenue || 0),
      ),
    );
  }

  if (period === "year") {
    return Array.from(
      { length: 12 },
      (_, index) => {
        const month = index + 1;

        return {
          period: month,
          label: new Date(
            2000,
            index,
            1,
          ).toLocaleString(
            "en-US",
            {
              month: "short",
            },
          ),
          revenue:
            map.get(month) ?? 0,
        };
      },
    );
  }

  if (period === "month") {
    const days =
      new Date(
        start.getFullYear(),
        start.getMonth() + 1,
        0,
      ).getDate();

    return Array.from(
      { length: days },
      (_, index) => {
        const day = index + 1;

        return {
          period: day,
          label: String(day),
          revenue:
            map.get(day) ?? 0,
        };
      },
    );
  }

  return [
    {
      period: 1,
      label: "Sun",
      revenue: map.get(1) ?? 0,
    },
    {
      period: 2,
      label: "Mon",
      revenue: map.get(2) ?? 0,
    },
    {
      period: 3,
      label: "Tue",
      revenue: map.get(3) ?? 0,
    },
    {
      period: 4,
      label: "Wed",
      revenue: map.get(4) ?? 0,
    },
    {
      period: 5,
      label: "Thu",
      revenue: map.get(5) ?? 0,
    },
    {
      period: 6,
      label: "Fri",
      revenue: map.get(6) ?? 0,
    },
    {
      period: 7,
      label: "Sat",
      revenue: map.get(7) ?? 0,
    },
  ];
}

export const trackVisitor =
  async (req, res) => {
    try {
      const {
        visitorId,
        path = null,
      } = req.body;

      if (
        !visitorId ||
        typeof visitorId !== "string"
      ) {
        return res.status(400).json({
          status: "Failed",
          message:
            "visitorId is required",
        });
      }

      const now = new Date();

      const monthKey =
        `${now.getUTCFullYear()}-${String(
          now.getUTCMonth() + 1,
        ).padStart(2, "0")}`;

      const visitor =
        await Visitor.findOneAndUpdate(
          {
            visitorId,
            monthKey,
          },

          {
            $set: {
              lastSeenAt: now,

              ...(path
                ? {
                    lastPath: path,
                  }
                : {}),
            },

            $setOnInsert: {
              visitorId,
              monthKey,
              createdAt: now,
              converted: false,
            },
          },

          {
            new: true,
            upsert: true,
          },
        );

      return res.status(200).json({
        status: "Success",
        visitor,
      });
    } catch (err) {
      console.error(
        "Track visitor error:",
        err,
      );

      return res.status(500).json({
        status: "Failed",
        message:
          "Internal Server Error",
      });
    }
  };