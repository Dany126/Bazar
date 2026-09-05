// import express from "express";
// import { createPayment } from "../controllers/payment_controller.js";
// import { requireAuth } from "../middleware/requireAuth.js";

// export const paymentRouter = express.Router();

// paymentRouter.use(requireAuth);

// paymentRouter.post("/orders/:orderId/pay", createPayment);
import express from "express";

import {
  createPaymentSession,
  getPaymentSessionStatus,
} from "../controllers/payment_controller.js";

import {
  requireAuth,
} from "../middleware/requireAuth.js";


export const paymentRouter =
  express.Router();


/*
 * ============================================================
 * AUTHENTICATION
 * ============================================================
 *
 * Both endpoints require the user to be logged in.
 *
 * WHY:
 *
 * We need req.user.id to:
 *
 * - create the session for the correct user
 * - prevent another user from checking the session
 */
paymentRouter.use(
  requireAuth,
);


/*
 * ============================================================
 * CREATE CARD PAYMENT SESSION
 * ============================================================
 *
 * POST:
 *
 * /api/payments/create-session
 *
 * IMPORTANT:
 *
 * This does NOT create an Order.
 */
paymentRouter.post(
  "/create-session",
  createPaymentSession,
);


/*
 * ============================================================
 * CHECK PAYMENT STATUS
 * ============================================================
 *
 * GET:
 *
 * /api/payments/sessions/:paymentSessionId/status
 */
paymentRouter.get(
  "/sessions/:paymentSessionId/status",
  getPaymentSessionStatus,
);