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

export const productRouter = express.Router({ mergeParams: true });

// productRouter.use(requireAuth);

productRouter
  .route("/")
  .post(upload.array("image"), createProduct)
  .get(getAllProducts);
productRouter
  .route("/:id")
  .get(checkID, getProduct)
  .patch(checkID, updateProduct)
  .delete(checkID, deleteProduct);
