import express from "express";
import {
  createProduct,
  deleteProduct,
  getAllProducts,
  getProduct,
  updateProduct,
} from "../controllers/product_controller.js";
import { checkID } from "../middleware/checkID.js";
import { upload } from "../utils/imageStore.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { variantRouter } from "./product_variants_routes.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const productRouter = express.Router({ mergeParams: true });

productRouter.use(requireAuth);

productRouter.use("/:product/variant", variantRouter);

productRouter
  .route("/")
  .post(restrictTo('admin'), upload.array("image"), createProduct)
  .get(getAllProducts);
productRouter
  .route("/:id")
  .get(checkID, getProduct)
  .patch(restrictTo('admin'), checkID, updateProduct)
  .delete(restrictTo('admin'), checkID, deleteProduct);
