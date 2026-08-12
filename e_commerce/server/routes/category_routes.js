import express from "express";
import {
  createCategory,
  deleteCategory,
  getAllCategories,
} from "../controllers/category_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { productRouter } from "./product_routes.js";
import { upload } from "../utils/imageStore.js";

export const categoryRouter = express.Router();

categoryRouter.use(requireAuth);

categoryRouter.use("/:category/product", productRouter);

categoryRouter
  .route("/")
  .post(upload.single("image"), createCategory)
  .get(getAllCategories);

categoryRouter.route("/:id").delete(deleteCategory);
