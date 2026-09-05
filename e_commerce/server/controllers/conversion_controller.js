import { Order } from "../models/order_model.js";
import { Visitor } from "../models/visitor_model.js";

const DAY_MS = 24 * 60 * 60 * 1000;

function getDateRange(period = "month") {
  const now = new Date();

  const end = new Date(now);

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
    end,
  };
}

function getPreviousDateRange(start, end) {
  const duration = end.getTime() - start.getTime();

  return {
    start: new Date(
      start.getTime() - duration,
    ),
    end: new Date(start),
  };
}

/*
|--------------------------------------------------------------------------
| Calculate conversion rate
|--------------------------------------------------------------------------
|
| Conversion rate =
|
| unique visitors who placed at least one non-cancelled order
| ------------------------------------------------------------ x 100
|                  unique visitors
|
|--------------------------------------------------------------------------
*/

export async function calculateDashboardConversion(
  start,
  end,
) {
  /*
  |--------------------------------------------------------------------------
  | Visitors
  |--------------------------------------------------------------------------
  */

  const visitors = await Visitor.aggregate([
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

  const visitorCount =
    visitors.length > 0
      ? visitors[0].count
      : 0;

  /*
  |--------------------------------------------------------------------------
  | Converted visitors
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
    convertedVisitors.length > 0
      ? convertedVisitors[0].count
      : 0;

  /*
  |--------------------------------------------------------------------------
  | Rate
  |--------------------------------------------------------------------------
  */

  const rate =
    visitorCount > 0
      ? (convertedVisitorCount /
          visitorCount) *
        100
      : 0;

  return {
    visitors: visitorCount,
    convertedVisitors: convertedVisitorCount,
    rate,
  };
}

/*
|--------------------------------------------------------------------------
| GET /api/admin/dashboard/conversion-rate
|--------------------------------------------------------------------------
*/

export const getAdminConversionRate =
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

      const [
        current,
        previous,
      ] = await Promise.all([
        calculateDashboardConversion(
          start,
          end,
        ),

        calculateDashboardConversion(
          previousStart,
          previousEnd,
        ),
      ]);

      const change =
        current.rate -
        previous.rate;

      return res.status(200).json({
        status: "Success",

        conversionRate: {
          period,

          range: {
            start,
            end,
          },

          visitors:
            current.visitors,

          convertedVisitors:
            current.convertedVisitors,

          rate: Number(
            current.rate.toFixed(2),
          ),

          previousRate: Number(
            previous.rate.toFixed(2),
          ),

          change: Number(
            change.toFixed(2),
          ),
        },
      });
    } catch (error) {
      console.error(
        "GET ADMIN CONVERSION RATE ERROR:",
        error,
      );

      return res.status(500).json({
        status: "Error",
        message:
          "Failed to calculate conversion rate",
      });
    }
  };