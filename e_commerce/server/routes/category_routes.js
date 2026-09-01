import express from "express";
import {
  createCategory,
  deleteCategory,
  getAllCategories,
  getCategory,
  updateCategory,
} from "../controllers/category_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { productRouter } from "./product_routes.js";
import { upload } from "../utils/imageStore.js";
import { checkID } from "../middleware/checkID.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const categoryRouter = express.Router();

categoryRouter.use(requireAuth);

categoryRouter.use("/:category/product", productRouter);

categoryRouter
  .route("/")
  .post(restrictTo("admin"), upload.single("image"), createCategory)
  .get(getAllCategories);

categoryRouter
  .route("/:id")
  .get(checkID, getCategory)
  .delete(restrictTo("admin"), checkID, deleteCategory)
  .patch(restrictTo("admin"), checkID, updateCategory);
