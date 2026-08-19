import express from "express";
import { requireAuth } from "../middleware/requireAuth.js";
import {
  addToWishlist,
  deleteFromWishlist,
  getWishlistByUserId,
} from "../controllers/wishlist_controller.js";
import { checkID } from "../middleware/checkID.js";

export const wishlistRouter = express.Router();

wishlistRouter.use(requireAuth);

wishlistRouter.route("/").get(getWishlistByUserId);

wishlistRouter
  .route("/:id")
  .post(checkID, addToWishlist)
  .delete(checkID, deleteFromWishlist);
