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

    start.setDate(
      start.getDate() - start.getDay(),
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
    ((current - previous) / previous) *
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

export const getAdminDashboard = async (
  req,
  res,
) => {
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

    /*
    |--------------------------------------------------------------------------
    | STORE SETTINGS
    |--------------------------------------------------------------------------
    */

    let storeSettings =
      await StoreSettings.findOne();

    /*
    |--------------------------------------------------------------------------
    | Create the default settings document
    | if it doesn't exist yet.
    |--------------------------------------------------------------------------
    */

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
      storeSettings.lowStockThreshold ??
      DEFAULT_LOW_STOCK_THRESHOLD;

    /*
    |--------------------------------------------------------------------------
    | MAIN DASHBOARD DATA
    |--------------------------------------------------------------------------
    */

    const [
      totalProducts,
      totalCategories,
      totalUsers,
      currentOrders,
      previousOrders,
      currentVisitors,
      previousVisitors,
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

      Order.find({
        createdAt: {
          $gte: start,
          $lte: end,
        },
      })
        .populate(
          "user",
          "name email",
        )
        .populate(
          "products.product",
          "name image",
        )
        .sort({
          createdAt: -1,
        }),

      Order.find({
        createdAt: {
          $gte: previousStart,
          $lt: previousEnd,
        },
      }).select(
        "totalPrice user visitorId createdAt orderStatus paymentStatus",
      ),

      Visitor.countDocuments({
        createdAt: {
          $gte: start,
          $lte: end,
        },
      }),

      Visitor.countDocuments({
        createdAt: {
          $gte: previousStart,
          $lt: previousEnd,
        },
      }),
    ]);

    /*
    |--------------------------------------------------------------------------
    | ALL TIME REVENUE
    |--------------------------------------------------------------------------
    */

    const allTimeRevenue =
      await Order.aggregate([
        {
          $match: {
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

    /*
    |--------------------------------------------------------------------------
    | CURRENT PERIOD REVENUE
    |--------------------------------------------------------------------------
    */

    const currentRevenue =
      currentOrders
        .filter(
          (order) =>
            order.paymentStatus ===
              "paid" &&
            order.orderStatus !==
              "cancelled",
        )
        .reduce(
          (sum, order) =>
            sum + order.totalPrice,
          0,
        );

    /*
    |--------------------------------------------------------------------------
    | PREVIOUS PERIOD REVENUE
    |--------------------------------------------------------------------------
    */

    const previousRevenue =
      previousOrders
        .filter(
          (order) =>
            order.paymentStatus ===
              "paid" &&
            order.orderStatus !==
              "cancelled",
        )
        .reduce(
          (sum, order) =>
            sum + order.totalPrice,
          0,
        );

    /*
    |--------------------------------------------------------------------------
    | CONVERSION RATE
    |--------------------------------------------------------------------------
    */

    const conversionVisitors =
      await Visitor.countDocuments({
        createdAt: {
          $gte: start,
          $lte: end,
        },
        converted: true,
      });

    const conversionRate =
      currentVisitors === 0
        ? null
        : round(
            (conversionVisitors /
              currentVisitors) *
              100,
          );

    const previousConversionVisitors =
      await Visitor.countDocuments({
        createdAt: {
          $gte: previousStart,
          $lt: previousEnd,
        },
        converted: true,
      });

    const previousConversionRate =
      previousVisitors === 0
        ? null
        : (previousConversionVisitors /
            previousVisitors) *
          100;

    /*
    |--------------------------------------------------------------------------
    | CATEGORY BREAKDOWN
    |--------------------------------------------------------------------------
    */

    const categoryBreakdown =
      await Product.aggregate([
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
      ]);

    const categoryTotal =
      categoryBreakdown.reduce(
        (sum, item) =>
          sum + item.count,
        0,
      );

    const categoryData =
      categoryBreakdown.map(
        (item) => ({
          name: item.name,
          count: item.count,
          percent:
            categoryTotal === 0
              ? 0
              : round(
                  (item.count /
                    categoryTotal) *
                    100,
                ),
        }),
      );

    /*
    |--------------------------------------------------------------------------
    | LOW INVENTORY
    |
    | IMPORTANT:
    | No more hardcoded "15".
    |
    | It now comes from:
    |
    | StoreSettings.lowStockThreshold
    |--------------------------------------------------------------------------
    */

    const lowInventory =
      await Variant.aggregate([
        {
          $match: {
            stock: {
              $lte:
                lowStockThreshold,
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
            name: "$product.name",
            size: 1,
            color: 1,
            stock: 1,
          },
        },
      ]);

    /*
    |--------------------------------------------------------------------------
    | REVENUE CHART
    |--------------------------------------------------------------------------
    */

    const chartStart =
      new Date(start);

    const chartEnd =
      new Date(end);

    const chartGroup =
      period === "year"
        ? {
            $month:
              "$createdAt",
          }
        : period === "week"
          ? {
              $dayOfWeek:
                "$createdAt",
            }
          : {
              $dayOfMonth:
                "$createdAt",
            };

    const chartRows =
      await Order.aggregate([
        {
          $match: {
            createdAt: {
              $gte: chartStart,
              $lte: chartEnd,
            },

            paymentStatus: "paid",

            orderStatus: {
              $ne: "cancelled",
            },
          },
        },

        {
          $group: {
            _id: chartGroup,
            revenue: {
              $sum: "$totalPrice",
            },
          },
        },

        {
          $sort: {
            _id: 1,
          },
        },
      ]);

    /*
    |--------------------------------------------------------------------------
    | RECENT ORDERS
    |--------------------------------------------------------------------------
    */

    const recentOrders =
      currentOrders
        .slice(0, 6)
        .map((order) => ({
          id: order._id,

          customer:
            order.user?.name ??
            "Guest",

          total:
            order.totalPrice,

          status:
            order.orderStatus,

          paymentStatus:
            order.paymentStatus,

          createdAt:
            order.createdAt,
        }));

    /*
    |--------------------------------------------------------------------------
    | DASHBOARD RESPONSE
    |--------------------------------------------------------------------------
    */

    const dashboard = {
      period,

      range: {
        start,
        end,
      },

      /*
      |--------------------------------------------------------------------------
      | STORE INFORMATION
      |--------------------------------------------------------------------------
      |
      | This makes the dashboard aware of the
      | current store configuration.
      |
      */

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
          round(
            Number(
              allTimeRevenue[0]
                ?.total ?? 0,
            ),
          ),

        periodRevenue:
          round(currentRevenue),

        totalOrders:
          await Order.countDocuments(),

        periodOrders:
          currentOrders.length,

        totalProducts,

        totalCategories,

        totalUsers,

        totalVisitors:
          currentVisitors,

        conversionRate,

        lowStockAlerts:
          lowInventory.length,

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
            percentageChange(
              conversionRate ?? 0,
              previousConversionRate ??
                0,
            ),
        },
      },

      categoryBreakdown:
        categoryData,

      revenueChart:
        chartRows.map((row) => ({
          period: row._id,

          label:
            period === "year"
              ? new Date(
                  2000,
                  Number(row._id) -
                    1,
                  1,
                ).toLocaleString(
                  "en-US",
                  {
                    month:
                      "short",
                  },
                )
              : period === "week"
                ? [
                    "Sun",
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                  ][
                    Number(
                      row._id,
                    ) - 1
                  ]
                : String(
                    row._id,
                  ),

          revenue:
            round(row.revenue),
        })),

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

export const trackVisitor = async (
  req,
  res,
) => {
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
          upsert: true,
          new: true,
          setDefaultsOnInsert: true,
        },
      );

    return res.status(200).json({
      status: "Success",
      visitorId:
        visitor.visitorId,
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