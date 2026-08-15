import express from "express";
import {
  createCart,
  deleteCart,
  getAllCarts,
} from "../controllers/cart_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { checkStock } from "../middleware/checkStock.js";
import { checkID } from "../middleware/checkID.js";

export const cartRouter = express.Router();

// cartRouter.use(requireAuth);

cartRouter.route("/").post(checkStock, createCart).get(getAllCarts);

cartRouter.route("/:id").delete(checkID, deleteCart);
