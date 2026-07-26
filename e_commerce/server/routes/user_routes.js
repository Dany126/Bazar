const express = require("express");
const {
  register,
  login,
  forgetPassword,
  resetPassword,
} = require("../controllers/auth_controller");

const userRouter = express.Router();

userRouter.post("/register", register);
userRouter.post("/login", login);
userRouter.post("/forget-password", forgetPassword);
userRouter.post("/reset-password", resetPassword);
module.exports = userRouter;
