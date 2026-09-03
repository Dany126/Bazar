import { Order } from "../models/order_model.js";
import { Product } from "../models/product_model.js";
import { Category } from "../models/category_model.js";
import { User } from "../models/user_model.js";
import { Variant } from "../models/product_variants_model.js";
import { Visitor } from "../models/visitor_model.js";
import { StoreSettings } from "../models/store_settings_model.js";

const DAY_MS = 24 * 60 * 60 * 1000;

const DEFAULT_LOW_STOCK_THRESHOLD = 15;

const VALID_PERIODS = [
  "week",
  "month",
  "year",
];

function getDateRange(period) {
  const end = new Date();

  let duration;

  switch (period) {
    case "week":
      duration = 7 * DAY_MS;
      break;

    case "year":
      duration = 365 * DAY_MS;
      break;

    case "month":
    default:
      duration = 30 * DAY_MS;
      break;
  }

  return {
    start: new Date(
      end.getTime() - duration,
    ),
    end,
  };
}

function getPreviousRange(start, end) {
  const duration =
    end.getTime() -
    start.getTime();

  return {
    start: new Date(
      start.getTime() - duration,
    ),
    end: new Date(start),
  };
}

function round(value, digits = 2) {
  if (
    value === null ||
    value === undefined ||
    Number.isNaN(Number(value))
  ) {
    return null;
  }

  return Number(
    Number(value).toFixed(digits),
  );
}

function percentageChange(
  current,
  previous,
) {
  if (previous === 0) {
    return current === 0
      ? 0
      : null;
  }

  return (
    ((current - previous) /
      Math.abs(previous)) *
    100
  );
}

const validOrderMatch = {
  orderStatus: {
    $nin: [
      "cancelled",
      "canceled",
    ],
  },
};

/*
|--------------------------------------------------------------------------
| VISITOR TRACKING
|--------------------------------------------------------------------------
*/

export const trackVisitor =
  async (req, res) => {
    try {
      const {
        visitorId,
        path,
      } = req.body;

      if (!visitorId) {
        return res.status(400).json({
          status: "Failed",
          message:
            "visitorId is required",
        });
      }

      const now = new Date();

      /*
       * IMPORTANT:
       * Visitor schema requires monthKey.
       */

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
                    lastPath:
                      path,
                  }
                : {}),
            },

            $setOnInsert: {
              visitorId,
              monthKey,
              converted: false,
            },
          },

          {
            new: true,
            upsert: true,
            setDefaultsOnInsert:
              true,
          },
        );

      return res.status(200).json({
        status: "Success",
        visitor,
      });
    } catch (error) {
      console.error(
        "TRACK VISITOR ERROR:",
        error,
      );

      return res.status(500).json({
        status: "Failed",
        message:
          "Failed to track visitor",
      });
    }
  };

/*
|--------------------------------------------------------------------------
| ADMIN DASHBOARD
|--------------------------------------------------------------------------
*/

export const getAdminDashboard =
  async (req, res) => {
    try {
      const requestedPeriod =
        req.query.period || "month";

      const period =
        VALID_PERIODS.includes(
          requestedPeriod,
        )
          ? requestedPeriod
          : "month";

      const {
        start,
        end,
      } = getDateRange(period);

      const {
        start: previousStart,
        end: previousEnd,
      } = getPreviousRange(
        start,
        end,
      );

      /*
      |--------------------------------------------------------------------------
      | TOTAL PRODUCTS
      |--------------------------------------------------------------------------
      */

      const totalProducts =
        await Product.countDocuments();

      /*
      |--------------------------------------------------------------------------
      | TOTAL CATEGORIES
      |--------------------------------------------------------------------------
      */

      const totalCategories =
        await Category.countDocuments();

      /*
      |--------------------------------------------------------------------------
      | TOTAL CUSTOMERS
      |--------------------------------------------------------------------------
      */

      const totalUsers =
        await User.countDocuments({
          role: {
            $ne: "admin",
          },
        });

      /*
      |--------------------------------------------------------------------------
      | ORDERS
      |--------------------------------------------------------------------------
      */

      const periodOrders =
        await Order.countDocuments({
          createdAt: {
            $gte: start,
            $lt: end,
          },

          ...validOrderMatch,
        });

      const previousOrders =
        await Order.countDocuments({
          createdAt: {
            $gte: previousStart,
            $lt: previousEnd,
          },

          ...validOrderMatch,
        });

      /*
      |--------------------------------------------------------------------------
      | REVENUE
      |--------------------------------------------------------------------------
      */

      const revenueResult =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: start,
                $lt: end,
              },

              ...validOrderMatch,
            },
          },

          {
            $group: {
              _id: null,

              total: {
                $sum: {
                  $ifNull: [
                    "$totalPrice",
                    0,
                  ],
                },
              },
            },
          },
        ]);

      const previousRevenueResult =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: previousStart,
                $lt: previousEnd,
              },

              ...validOrderMatch,
            },
          },

          {
            $group: {
              _id: null,

              total: {
                $sum: {
                  $ifNull: [
                    "$totalPrice",
                    0,
                  ],
                },
              },
            },
          },
        ]);

      const periodRevenue =
        Number(
          revenueResult[0]?.total ||
            0,
        );

      const previousRevenue =
        Number(
          previousRevenueResult[0]
            ?.total || 0,
        );

      /*
      |--------------------------------------------------------------------------
      | VISITORS
      |--------------------------------------------------------------------------
      |
      | Visitor documents are monthly.
      |
      */

      const visitors =
        await Visitor.aggregate([
          {
            $match: {
              $or: [
                {
                  createdAt: {
                    $gte: start,
                    $lt: end,
                  },
                },

                {
                  lastSeenAt: {
                    $gte: start,
                    $lt: end,
                  },
                },
              ],
            },
          },

          {
            $group: {
              _id: "$visitorId",
            },
          },

          {
            $count: "total",
          },
        ]);

      const totalVisitors =
        Number(
          visitors[0]?.total || 0,
        );

      const previousVisitorsResult =
        await Visitor.aggregate([
          {
            $match: {
              $or: [
                {
                  createdAt: {
                    $gte: previousStart,
                    $lt: previousEnd,
                  },
                },

                {
                  lastSeenAt: {
                    $gte: previousStart,
                    $lt: previousEnd,
                  },
                },
              ],
            },
          },

          {
            $group: {
              _id: "$visitorId",
            },
          },

          {
            $count: "total",
          },
        ]);

      const previousVisitors =
        Number(
          previousVisitorsResult[0]
            ?.total || 0,
        );

      /*
      |--------------------------------------------------------------------------
      | CONVERTED VISITORS
      |--------------------------------------------------------------------------
      |
      | Use Visitor.converted.
      |
      */

      const convertedVisitorsResult =
        await Visitor.aggregate([
          {
            $match: {
              converted: true,

              $or: [
                {
                  createdAt: {
                    $gte: start,
                    $lt: end,
                  },
                },

                {
                  lastSeenAt: {
                    $gte: start,
                    $lt: end,
                  },
                },
              ],
            },
          },

          {
            $group: {
              _id: "$visitorId",
            },
          },

          {
            $count: "total",
          },
        ]);

      const convertedVisitors =
        Number(
          convertedVisitorsResult[0]
            ?.total || 0,
        );

      const conversionRate =
        totalVisitors > 0
          ? (convertedVisitors /
              totalVisitors) *
            100
          : null;

      /*
      |--------------------------------------------------------------------------
      | PREVIOUS CONVERSION
      |--------------------------------------------------------------------------
      */

      const previousConvertedResult =
        await Visitor.aggregate([
          {
            $match: {
              converted: true,

              $or: [
                {
                  createdAt: {
                    $gte: previousStart,
                    $lt: previousEnd,
                  },
                },

                {
                  lastSeenAt: {
                    $gte: previousStart,
                    $lt: previousEnd,
                  },
                },
              ],
            },
          },

          {
            $group: {
              _id: "$visitorId",
            },
          },

          {
            $count: "total",
          },
        ]);

      const previousConvertedVisitors =
        Number(
          previousConvertedResult[0]
            ?.total || 0,
        );

      const previousConversionRate =
        previousVisitors > 0
          ? (previousConvertedVisitors /
              previousVisitors) *
            100
          : null;

      /*
      |--------------------------------------------------------------------------
      | LOW STOCK
      |--------------------------------------------------------------------------
      |
      | Stock belongs to Variant.
      |
      */

      let lowStockThreshold =
        DEFAULT_LOW_STOCK_THRESHOLD;

      try {
        const settings =
          await StoreSettings.findOne();

        if (
          settings?.lowStockThreshold !=
          null
        ) {
          lowStockThreshold =
            Number(
              settings.lowStockThreshold,
            );
        }
      } catch (_) {}

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

              localField:
                "product",

              foreignField:
                "_id",

              as: "product",
            },
          },

          {
            $unwind: "$product",
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

              price: 1,

              soldCount: 1,
            },
          },

          {
            $sort: {
              stock: 1,
            },
          },
        ]);

      /*
      |--------------------------------------------------------------------------
      | TOP CATEGORIES
      |--------------------------------------------------------------------------
      |
      | ACTUAL ORDER FIELD = products
      |
      */

      const categoryBreakdown =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: start,
                $lt: end,
              },

              ...validOrderMatch,
            },
          },

          {
            $unwind: "$products",
          },

          {
            $lookup: {
              from: "products",

              localField:
                "products.product",

              foreignField:
                "_id",

              as: "product",
            },
          },

          {
            $unwind: "$product",
          },

          {
            $lookup: {
              from: "categories",

              localField:
                "product.category",

              foreignField:
                "_id",

              as: "category",
            },
          },

          {
            $unwind: {
              path: "$category",
              preserveNullAndEmptyArrays:
                true,
            },
          },

          {
            $group: {
              _id:
                "$category._id",

              categoryName: {
                $first: {
                  $ifNull: [
                    "$category.name",
                    "Uncategorized",
                  ],
                },
              },

              count: {
                $sum: {
                  $ifNull: [
                    "$products.quantity",
                    1,
                  ],
                },
              },

              revenue: {
                $sum: {
                  $multiply: [
                    {
                      $ifNull: [
                        "$products.price",
                        0,
                      ],
                    },

                    {
                      $ifNull: [
                        "$products.quantity",
                        1,
                      ],
                    },
                  ],
                },
              },
            },
          },

          {
            $sort: {
              count: -1,
            },
          },
        ]);

      const totalCategoryCount =
        categoryBreakdown.reduce(
          (sum, item) =>
            sum +
            Number(
              item.count || 0,
            ),
          0,
        );

      const categories =
        categoryBreakdown.map(
          (item) => ({
            categoryId:
              item._id,

            categoryName:
              item.categoryName,

            count:
              Number(
                item.count || 0,
              ),

            revenue:
              round(
                item.revenue || 0,
              ),

            percent:
              totalCategoryCount >
              0
                ? round(
                    (Number(
                      item.count || 0,
                    ) /
                      totalCategoryCount) *
                      100,
                  )
                : 0,
          }),
        );

      /*
      |--------------------------------------------------------------------------
      | REVENUE OVER TIME
      |--------------------------------------------------------------------------
      */

      const revenueChart =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: start,
                $lt: end,
              },

              ...validOrderMatch,
            },
          },

          {
            $group: {
              _id: {
                $dateToString: {
                  format:
                    "%Y-%m-%d",

                  date:
                    "$createdAt",
                },
              },

              revenue: {
                $sum: {
                  $ifNull: [
                    "$totalPrice",
                    0,
                  ],
                },
              },
            },
          },

          {
            $sort: {
              _id: 1,
            },
          },

          {
            $project: {
              _id: 0,

              date: "$_id",

              revenue: 1,
            },
          },
        ]);

      /*
      |--------------------------------------------------------------------------
      | STORE
      |--------------------------------------------------------------------------
      */

      let storeName = "";
      let currency = "EGP";
      let storeEnabled = true;
      let acceptOrders = true;

      try {
        const settings =
          await StoreSettings.findOne();

        if (settings) {
          storeName =
            settings.name ??
            settings.storeName ??
            "";

          currency =
            settings.currency ??
            "EGP";

          storeEnabled =
            settings.storeEnabled ??
            true;

          acceptOrders =
            settings.acceptOrders ??
            true;
        }
      } catch (_) {}

      /*
      |--------------------------------------------------------------------------
      | CHANGES
      |--------------------------------------------------------------------------
      */

      const revenueChange =
        percentageChange(
          periodRevenue,
          previousRevenue,
        );

      const ordersChange =
        percentageChange(
          periodOrders,
          previousOrders,
        );

      const visitorsChange =
        percentageChange(
          totalVisitors,
          previousVisitors,
        );

      const conversionChange =
        conversionRate !== null &&
        previousConversionRate !== null
          ? conversionRate -
            previousConversionRate
          : null;

      /*
      |--------------------------------------------------------------------------
      | RESPONSE
      |--------------------------------------------------------------------------
      */

      return res.status(200).json({
        status: "Success",

        data: {
          period,

          revenue: {
            total:
              round(
                periodRevenue,
              ),

            previous:
              round(
                previousRevenue,
              ),

            change:
              round(
                revenueChange,
              ),
          },

          orders: {
            total:
              periodOrders,

            previous:
              previousOrders,

            change:
              round(
                ordersChange,
              ),
          },

          products: {
            total:
              totalProducts,
          },

          categories: {
            total:
              totalCategories,
          },

          customers: {
            total:
              totalUsers,
          },

          visitors: {
            total:
              totalVisitors,

            previous:
              previousVisitors,

            change:
              round(
                visitorsChange,
              ),
          },

          conversionRate: {
            rate:
              conversionRate ===
              null
                ? null
                : round(
                    conversionRate,
                  ),

            previous:
              previousConversionRate ===
              null
                ? null
                : round(
                    previousConversionRate,
                  ),

            change:
              conversionChange ===
              null
                ? null
                : round(
                    conversionChange,
                  ),

            convertedVisitors,

            visitors:
              totalVisitors,
          },

          lowStockThreshold,

          lowStockAlerts:
            lowInventory.length,

          lowInventory,

          categoryBreakdown:
            categories,

          revenueChart,

          store: {
            name:
              storeName,

            currency,

            storeEnabled,

            acceptOrders,

            lowStockThreshold,
          },

          changes: {
            revenue:
              round(
                revenueChange,
              ),

            orders:
              round(
                ordersChange,
              ),

            visitors:
              round(
                visitorsChange,
              ),

            conversionRate:
              conversionChange ===
              null
                ? null
                : round(
                    conversionChange,
                  ),
          },
        },
      });
    } catch (error) {
      console.error(
        "GET ADMIN DASHBOARD ERROR:",
        error,
      );

      return res.status(500).json({
        status: "Failed",
        message:
          "Failed to load admin dashboard",
      });
    }
  };