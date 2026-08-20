import express from "express";
import {
	createPaymobPayment,
	handlePaymobCallback,
} from "../controllers/payment_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";

export const paymentRouter = express.Router();

paymentRouter.post("/paymob", requireAuth, createPaymobPayment);
paymentRouter.post("/paymob/callback", handlePaymobCallback);
