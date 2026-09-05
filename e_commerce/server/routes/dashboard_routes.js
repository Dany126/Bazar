import express from "express";

import {
  getAdminDashboard,
  trackVisitor,
} from "../controllers/dashboard_controller.js";

import {
  getAdminConversionRate,
} from "../controllers/conversion_controller.js";

import { requireAuth } from "../middleware/requireAuth.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const dashboardRouter = express.Router();

/*
|--------------------------------------------------------------------------
| Public visitor tracking
|--------------------------------------------------------------------------
*/
dashboardRouter.post(
  "/visit",
  trackVisitor,
);

/*
|--------------------------------------------------------------------------
| Admin dashboard
|--------------------------------------------------------------------------
*/
dashboardRouter.get(
  "/",
  requireAuth,
  restrictTo("admin"),
  getAdminDashboard,
);

/*
|--------------------------------------------------------------------------
| Admin conversion rate
|--------------------------------------------------------------------------
*/
dashboardRouter.get(
  "/conversion-rate",
  requireAuth,
  restrictTo("admin"),
  getAdminConversionRate,
);