import express from "express";
import {
  createReview,
  deleteReview,
  getAllReviews,
  getReview,
} from "../controllers/review_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";
import { checkID } from "../middleware/checkID.js";

export const reviewRouter = express.Router();

reviewRouter.use(requireAuth);

reviewRouter.route("/").get(getAllReviews).post(createReview);

reviewRouter
  .route("/:id")
  .get(checkID, getReview)
  .delete(checkID, deleteReview);
