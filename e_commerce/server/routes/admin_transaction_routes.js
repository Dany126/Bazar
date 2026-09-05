import express from "express";

import {
  getAdminTransaction,
  getAdminTransactions,
} from "../controllers/admin_transaction_controller.js";

import { requireAuth } from "../middleware/requireAuth.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const adminTransactionRouter = express.Router();

adminTransactionRouter.use(requireAuth);
adminTransactionRouter.use(restrictTo("admin"));

adminTransactionRouter.get("/", getAdminTransactions);

adminTransactionRouter.get("/:id", getAdminTransaction);