const joi = require("joi");
const { hashPassword, comparePassword } = require("../utils/hash");
const User = require("../models/user_model");
const generateToken = require("../utils/token");

const registerSchema = joi.object({
  name: joi.string().required(),
  email: joi.string().email().required(),
  phone: joi.string().required().min(11),
  password: joi.string().required(),
});

const loginSchema = joi.object({
  email: joi.string().email().required(),
  password: joi.string().min(6).required(),
});

const register = async (req, res, next) => {
  try {
    const { name, email, phone, password } = req.body;
    const { error } = registerSchema.validate({ name, email, phone, password });
    if (error) {
      return res.status(400).json({
        status: "failed",
        message: error.details[0].message,
      });
    }
    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      return res.status(400).json({
        success: false,
        message: "User email already exists! Please try with different email",
      });
    }
    const hashedPassword = await hashPassword(password);
    const newlyCreatedUser = await User.create({
      name,
      email,
      phone,
      password_hash: hashedPassword,
    });
    if (newlyCreatedUser) {
      const token = await generateToken(newlyCreatedUser?.id);
      res.cookie("token", token, {
        withCredentials: true,
        httpOnly: false,
      });
    }

    return res.status(200).json({
      status: "success",
      message: "User registeration successful",
      userInfo: {
        name: newlyCreatedUser.name,
        email: newlyCreatedUser.email,
        id: newlyCreatedUser._id,
      },
    });
    next();
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "failed",
      message: "Some Error Occurred",
    });
  }
};

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const { error } = loginSchema.validate({ email, password });
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message,
      });
    }
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Email Not Found",
      });
    }
    const checkAuth = await comparePassword(password, user.password_hash);
    if (!checkAuth) {
      return res.status(400).json({
        success: false,
        message: "Incorrect password",
      });
    }

    const token = generateToken(user._id);
    res.cookie("token", token, {
      withCredentials: true,
      httpOnly: false,
    });

    return res.status(201).json({
      success: true,
      message: "User logged in",
    });
    next();
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      success: false,
      message: "Something went wrong! Please try again later",
    });
  }
};

module.exports = { register, login };
