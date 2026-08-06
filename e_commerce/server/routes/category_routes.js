import express from "express";
import {
  createCategory,
  getAllCategories,
} from "../controllers/category_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { productRouter } from "./product_routes.js";

export const categoryRouter = express.Router();

categoryRouter.use("/:categoryId/product", productRouter);

categoryRouter.route("/").post(createCategory).get(getAllCategories);

// requireAuth,
