import express from "express";
import { createPayment } from "../controllers/payment_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";

export const paymentRouter = express.Router();

paymentRouter.use(requireAuth);

paymentRouter.post("/orders/:orderId/pay", createPayment);
