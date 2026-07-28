const express = require("express");
const {
  register,
  login,
  forgetPassword,
  resetPassword,
  refresh,
} = require("../controllers/auth_controller");

const userRouter = express.Router();

userRouter.post("/register", register);
userRouter.post("/login", login);
userRouter.post("/refresh", refresh);
userRouter.post("/forget-password", forgetPassword);
userRouter.post("/reset-password", resetPassword);
module.exports = userRouter;
