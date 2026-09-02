import express from "express";
import { getAdminDashboard, trackVisitor } from "../controllers/dashboard_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const dashboardRouter = express.Router();

// Public: called by the storefront when a visitor/session is seen.
dashboardRouter.post("/visit", trackVisitor);

// Admin only: dashboard aggregate data.
dashboardRouter.get("/", requireAuth, restrictTo("admin"), getAdminDashboard);
