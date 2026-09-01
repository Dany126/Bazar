import express from "express";
import {
  createVariant,
  deleteVariant,
  getAllVariants,
  getVariant,
  updateVariant,
} from "../controllers/product_variants_controller.js";
import { checkID } from "../middleware/checkID.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const variantRouter = express.Router({ mergeParams: true });

variantRouter.use(requireAuth);

variantRouter.route("/").post(restrictTo('admin'), createVariant).get(getAllVariants);

variantRouter
  .route("/:id")
  .patch(restrictTo('admin'), checkID, updateVariant)
  .get(checkID, getVariant)
  .delete(restrictTo('admin'), checkID, deleteVariant);
