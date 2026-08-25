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

export const variantRouter = express.Router({ mergeParams: true });

variantRouter.use(requireAuth);

variantRouter.route("/").post(createVariant).get(getAllVariants);

variantRouter
  .route("/:id")
  .patch(checkID, updateVariant)
  .get(checkID, getVariant)
  .delete(checkID, deleteVariant);
