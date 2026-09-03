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

  switch (period) {
    case "week":
      start = new Date(
        now.getTime() - 7 * DAY_MS,
      );
      break;

    case "year":
      start = new Date(
        now.getTime() - 365 * DAY_MS,
      );
      break;

    case "month":
    default:
      start = new Date(
        now.getTime() - 30 * DAY_MS,
      );
      break;
  }

  return {
    start,
    end: now,
  };
}

function getPreviousDateRange(start, end) {
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

function calculatePercentageChange(
  current,
  previous,
) {
  if (previous === 0) {
    if (current === 0) {
      return 0;
    }

    return null;
  }

  return (
    ((current - previous) /
      Math.abs(previous)) *
    100
  );
}

function round(value, digits = 2) {
  if (
    value === null ||
    value === undefined ||
    Number.isNaN(value)
  ) {
    return null;
  }

  return Number(
    Number(value).toFixed(digits),
  );
}

/*
|--------------------------------------------------------------------------
| Track visitor
|--------------------------------------------------------------------------
*/

export const trackVisitor =
  async (req, res) => {
    try {
      const {
        visitorId,
      } = req.body;

      if (!visitorId) {
        return res.status(400).json({
          status: "Error",
          message:
            "visitorId is required",
        });
      }

      const now = new Date();

      const visitor =
        await Visitor.findOneAndUpdate(
          {
            visitorId,
          },

          {
            $set: {
              lastSeenAt: now,
            },

            $setOnInsert: {
              visitorId,
              createdAt: now,
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
    } catch (error) {
      console.error(
        "TRACK VISITOR ERROR:",
        error,
      );

      return res.status(500).json({
        status: "Error",
        message:
          "Failed to track visitor",
      });
    }
  };

/*
|--------------------------------------------------------------------------
| Admin dashboard
|--------------------------------------------------------------------------
*/

export const getAdminDashboard =
  async (req, res) => {
    try {
      const period =
        req.query.period || "month";

      const {
        start,
        end,
      } = getDateRange(period);

      const {
        start: previousStart,
        end: previousEnd,
      } =
        getPreviousDateRange(
          start,
          end,
        );

      /*
      |--------------------------------------------------------------------------
      | Revenue
      |--------------------------------------------------------------------------
      */

      const revenueAggregation =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: start,
                $lt: end,
              },

              orderStatus: {
                $nin: [
                  "cancelled",
                  "canceled",
                ],
              },
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

      const previousRevenueAggregation =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: previousStart,
                $lt: previousEnd,
              },

              orderStatus: {
                $nin: [
                  "cancelled",
                  "canceled",
                ],
              },
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
        revenueAggregation[0]?.total || 0;

      const previousRevenue =
        previousRevenueAggregation[0]?.total ||
        0;

      /*
      |--------------------------------------------------------------------------
      | Orders
      |--------------------------------------------------------------------------
      */

      const periodOrders =
        await Order.countDocuments({
          createdAt: {
            $gte: start,
            $lt: end,
          },

          orderStatus: {
            $nin: [
              "cancelled",
              "canceled",
            ],
          },
        });

      const previousOrders =
        await Order.countDocuments({
          createdAt: {
            $gte: previousStart,
            $lt: previousEnd,
          },

          orderStatus: {
            $nin: [
              "cancelled",
              "canceled",
            ],
          },
        });

      /*
      |--------------------------------------------------------------------------
      | Customers
      |--------------------------------------------------------------------------
      */

      const totalCustomers =
        await User.countDocuments({
          role: {
            $ne: "admin",
          },
        });

      /*
      |--------------------------------------------------------------------------
      | Products
      |--------------------------------------------------------------------------
      */

      const totalProducts =
        await Product.countDocuments();

      /*
      |--------------------------------------------------------------------------
      | Categories
      |--------------------------------------------------------------------------
      */

      const totalCategories =
        await Category.countDocuments();

      /*
      |--------------------------------------------------------------------------
      | Visitors
      |--------------------------------------------------------------------------
      */

      const visitorAggregation =
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
            $count: "count",
          },
        ]);

      const totalVisitors =
        visitorAggregation[0]?.count ||
        0;

      /*
      |--------------------------------------------------------------------------
      | Previous visitors
      |--------------------------------------------------------------------------
      */

      const previousVisitorAggregation =
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
            $count: "count",
          },
        ]);

      const previousVisitors =
        previousVisitorAggregation[0]?.count ||
        0;

      /*
      |--------------------------------------------------------------------------
      | Conversion
      |--------------------------------------------------------------------------
      */

      const convertedVisitors =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: start,
                $lt: end,
              },

              visitorId: {
                $exists: true,
                $nin: [
                  null,
                  "",
                ],
              },

              orderStatus: {
                $nin: [
                  "cancelled",
                  "canceled",
                ],
              },
            },
          },

          {
            $group: {
              _id: "$visitorId",
            },
          },

          {
            $count: "count",
          },
        ]);

      const convertedVisitorCount =
        convertedVisitors[0]?.count ||
        0;

      const conversionRate =
        totalVisitors > 0
          ? (convertedVisitorCount /
              totalVisitors) *
            100
          : null;

      /*
      |--------------------------------------------------------------------------
      | Previous conversion
      |--------------------------------------------------------------------------
      */

      const previousConvertedVisitors =
        await Order.aggregate([
          {
            $match: {
              createdAt: {
                $gte: previousStart,
                $lt: previousEnd,
              },

              visitorId: {
                $exists: true,
                $nin: [
                  null,
                  "",
                ],
              },

              orderStatus: {
                $nin: [
                  "cancelled",
                  "canceled",
                ],
              },
            },
          },

          {
            $group: {
              _id: "$visitorId",
            },
          },

          {
            $count: "count",
          },
        ]);

      const previousConvertedCount =
        previousConvertedVisitors[0]?.count ||
        0;

      const previousConversionRate =
        previousVisitors > 0
          ? (previousConvertedCount /
              previousVisitors) *
            100
          : null;

      let conversionChange = null;

      if (
        conversionRate !== null &&
        previousConversionRate !== null
      ) {
        conversionChange =
          conversionRate -
          previousConversionRate;
      }

      /*
      |--------------------------------------------------------------------------
      | Low inventory threshold
      |--------------------------------------------------------------------------
      */

      let lowStockThreshold =
        DEFAULT_LOW_STOCK_THRESHOLD;

      try {
        const settings =
          await StoreSettings.findOne();

        if (
          settings?.lowStockThreshold !==
          undefined
        ) {
          lowStockThreshold =
            Number(
              settings.lowStockThreshold,
            );
        }
      } catch (error) {
        console.warn(
          "Could not load store settings:",
          error.message,
        );
      }

      /*
      |--------------------------------------------------------------------------
      | Low inventory
      |--------------------------------------------------------------------------
      |
      | NO LIMIT.
      | The dashboard receives every low-stock product.
      |
      */

      const lowInventory =
        await Product.aggregate([
          {
            $match: {
              stock: {
                $lte:
                  lowStockThreshold,
              },
            },
          },

          {
            $sort: {
              stock: 1,
            },
          },

          {
            $project: {
              _id: 1,
              name: 1,
              stock: 1,
              price: 1,
              thumbnailUrl: 1,
              category: 1,
            },
          },
        ]);

      /*
      |--------------------------------------------------------------------------
      | Category breakdown
      |--------------------------------------------------------------------------
      |
      | IMPORTANT:
      | This is based on ORDERS, not product count.
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

              orderStatus: {
                $nin: [
                  "cancelled",
                  "canceled",
                ],
              },
            },
          },

          {
            $unwind: {
              path: "$items",
              preserveNullAndEmptyArrays:
                false,
            },
          },

          {
            $lookup: {
              from: "products",

              localField:
                "items.product",

              foreignField: "_id",

              as: "product",
            },
          },

          {
            $unwind: {
              path: "$product",
              preserveNullAndEmptyArrays:
                true,
            },
          },

          {
            $lookup: {
              from: "categories",

              localField:
                "product.category",

              foreignField: "_id",

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
                $first:
                  "$category.name",
              },

              orders: {
                $sum: 1,
              },
            },
          },

          {
            $sort: {
              orders: -1,
            },
          },

          {
            $project: {
              _id: 0,

              categoryId:
                "$_id",

              categoryName: {
                $ifNull: [
                  "$categoryName",
                  "Uncategorized",
                ],
              },

              orders: 1,
            },
          },
        ]);

      /*
      |--------------------------------------------------------------------------
      | Revenue chart
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

              orderStatus: {
                $nin: [
                  "cancelled",
                  "canceled",
                ],
              },
            },
          },

          {
            $group: {
              _id: {
                $dateToString: {
                  format: "%Y-%m-%d",
                  date: "$createdAt",
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
      | Response
      |--------------------------------------------------------------------------
      */

      return res.status(200).json({
        status: "Success",

        data: {
          period,

          range: {
            start,
            end,
          },

          revenue: {
            total: round(
              periodRevenue,
            ),

            previous: round(
              previousRevenue,
            ),

            change: round(
              calculatePercentageChange(
                periodRevenue,
                previousRevenue,
              ),
            ),
          },

          orders: {
            total:
              periodOrders,

            previous:
              previousOrders,

            change: round(
              calculatePercentageChange(
                periodOrders,
                previousOrders,
              ),
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
              totalCustomers,
          },

          visitors: {
            total:
              totalVisitors,

            previous:
              previousVisitors,

            change: round(
              calculatePercentageChange(
                totalVisitors,
                previousVisitors,
              ),
            ),
          },

          conversionRate: {
            rate:
              conversionRate === null
                ? null
                : round(
                    conversionRate,
                  ),

            previousRate:
              previousConversionRate ===
              null
                ? null
                : round(
                    previousConversionRate,
                  ),

            change:
              conversionChange === null
                ? null
                : round(
                    conversionChange,
                  ),

            visitors:
              totalVisitors,

            convertedVisitors:
              convertedVisitorCount,
          },

          lowStockThreshold,

          lowInventory,

          categoryBreakdown,

          revenueChart,
        },
      });
    } catch (error) {
      console.error(
        "GET ADMIN DASHBOARD ERROR:",
        error,
      );

      return res.status(500).json({
        status: "Error",
        message:
          "Failed to load admin dashboard",
      });
    }
  };