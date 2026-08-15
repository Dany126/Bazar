import express from "express";
import {
  createVariant,
  deleteVariant,
  getAllVariants,
  getVariant,
  updateVariant,
} from "../controllers/product_variants_controller.js";
import { checkID } from "../middleware/checkID.js";

export const variantRouter = express.Router({ mergeParams: true });

variantRouter.route("/").post(createVariant).get(getAllVariants);

variantRouter
  .route("/:id")
  .patch(checkID, updateVariant)
  .get(checkID, getVariant)
  .delete(checkID, deleteVariant);
