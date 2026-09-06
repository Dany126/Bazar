import express from "express";

import { upload } from "../utils/imageStore.js";

import {
  register,
  login,
  refresh,
  forgetPassword,
  resetPassword,
  logoutHandler,
} from "../controllers/auth_controller.js";

import {
  deleteUser,
  getAllUsers,
  updateUser,
  updateMyProfile,
} from "../controllers/user_controller.js";

import { requireAuth } from "../middleware/requireAuth.js";
import { orderRouter } from "./order_routes.js";
import { cartRouter } from "./cart_routes.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const userRouter = express.Router();

// ============================================================
// PUBLIC ROUTES
// ============================================================

userRouter.post("/register", register);

userRouter.post("/login", login);

userRouter.post("/refresh", refresh);

userRouter.post("/logout", logoutHandler);

userRouter.post("/forget-password", forgetPassword);

userRouter.post("/reset-password", resetPassword);

// ============================================================
// AUTHENTICATED ROUTES
// ============================================================

userRouter.use(requireAuth);

// Update currently logged-in user's profile
userRouter.patch(
  "/profile",
  upload.single("image"),
  updateMyProfile,
);

// User orders
userRouter.use(
  "/:user/order",
  orderRouter,
);

// User cart
userRouter.use(
  "/:user/cart",
  cartRouter,
);

// ============================================================
// ADMIN ROUTES
// ============================================================

userRouter.use(restrictTo("admin"));

userRouter.route("/").get(getAllUsers);

userRouter
  .route("/:id")
  .patch(updateUser)
  .delete(deleteUser);