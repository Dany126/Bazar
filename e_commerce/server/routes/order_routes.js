import express from "express";
import {
  createOrder,
  deleteOrder,
  getAllOrders,
  getOrder,
  updateOrder,
} from "../controllers/order_controller.js";
import { checkID } from "../middleware/checkID.js";
import { checkStock } from "../middleware/checkStock.js";
import { requireAuth } from "../middleware/requireAuth.js";

export const orderRouter = express.Router({ mergeParams: true });

orderRouter.use(requireAuth);

orderRouter.route("/").post(checkStock, createOrder).get(getAllOrders);
orderRouter
  .route("/:id")
  .get(checkID, getOrder)
  .patch(checkID, updateOrder)
  .delete(checkID, deleteOrder);
