import express from "express";
import {
  register,
  login,
  refresh,
  forgetPassword,
  resetPassword,
} from "../controllers/auth_controller.js";
import { getAllUsers } from "../controllers/user_controller.js";

export const userRouter = express.Router();

userRouter.post("/register/:fcm-token", register);
userRouter.post("/login", login);
userRouter.post("/refresh", refresh);
userRouter.post("/forget-password", forgetPassword);
userRouter.post("/reset-password", resetPassword);



userRouter.get("/", getAllUsers);
