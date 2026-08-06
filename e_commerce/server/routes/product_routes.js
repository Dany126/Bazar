import express from "express";
import {
  createProduct,
  deleteProduct,
  getAllProducts,
  getProduct,
  updateProduct,
} from "../controllers/product_controller.js";
import { checkID } from "../middleware/checkID.js";

export const productRouter = express.Router({ mergeParams: true });

productRouter.route("/").post(createProduct).get(getAllProducts);
productRouter
  .route("/:id")
  .get(checkID, getProduct)
  .patch(checkID, updateProduct)
  .delete(checkID, deleteProduct);
