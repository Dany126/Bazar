import express from "express";
import {
  createCart,
  deleteCartProduct,
  getAllCarts,
  updateCartProduct,
} from "../controllers/cart_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { checkStock } from "../middleware/checkStock.js";
import { checkID } from "../middleware/checkID.js";

export const cartRouter = express.Router({ mergeParams: true });

cartRouter.use(requireAuth);

cartRouter
  .route("/")
  .post(checkStock, createCart)
  .get(getAllCarts)
  .patch(updateCartProduct)
  .delete(deleteCartProduct);
