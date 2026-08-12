import express, { application } from "express";
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
} from "../controllers/user_controller.js";
import { requireAuth } from "../middleware/requireAuth.js";

export const userRouter = express.Router();

userRouter.post("/register", register);
userRouter.post("/login", login);
userRouter.post("/refresh", refresh);
userRouter.post("/logout", logoutHandler);
userRouter.post("/forget-password", forgetPassword);
userRouter.post("/reset-password", resetPassword);

userRouter.use(requireAuth);

userRouter.route("/").get(getAllUsers);

userRouter.route("/:id").patch(updateUser).delete(deleteUser);
