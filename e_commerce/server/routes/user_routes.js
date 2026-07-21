const express = require("express");
const { register, login } = require("../controllers/auth_controller");

const userRouter = express.Router();

userRouter.post("/register", register);
userRouter.post("/login", login);

module.exports = userRouter;
