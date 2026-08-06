import joi from "joi";
import crypto from "crypto";
import { hashPassword, comparePassword } from "../utils/hash.js";
import { User } from "../models/user_model.js";
import {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
} from "../utils/token.js";
import { sendEmail } from "../utils/Email.js";

const registerSchema = joi.object({
  name: joi.string().required(),
  email: joi.string().email().required(),
  phone: joi.string().required().min(11),
  password: joi.string().required(),
});

const getAppUrl = () => {
  return process.env.APP_URL;
};

const loginSchema = joi.object({
  email: joi.string().email().required(),
  password: joi.string().min(6).required(),
});

export const register = async (req, res, next) => {
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
    const normalizedEmail = email.toLowerCase().trim();
    const hashedPassword = await hashPassword(password);
    const newlyCreatedUser = await User.create({
      name,
      email: normalizedEmail,
      phone,
      password_hash: hashedPassword,
    });
    if (newlyCreatedUser) {
      const accessToken = generateAccessToken(newlyCreatedUser._id);
      const refreshToken = generateRefreshToken({
        id: newlyCreatedUser._id,
        tokenVersion: newlyCreatedUser.tokenVersion,
      });
      res.cookie("refreshToken", refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        maxAge: 7 * 24 * 60 * 60 * 1000,
      });

      return res.status(201).json({
        success: true,
        message: "Login successfuly",
        accessToken,
        user: {
          id: newlyCreatedUser.id,
          name: newlyCreatedUser.name,
          email: newlyCreatedUser.email,
          phone: newlyCreatedUser.phone,
        },
      });
    }
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "failed",
      message: "Some Error Occurred",
    });
  }
};

export const login = async (req, res, next) => {
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

    const accessToken = generateAccessToken(user._id);
    const refreshToken = generateRefreshToken({
      id: user._id,
      tokenVersion: user.tokenVersion,
    });
    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    return res.status(201).json({
      success: true,
      message: "Login successfuly",
      accessToken,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
      },
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      success: false,
      message: "Something went wrong! Please try again later",
    });
  }
};

export const refresh = async (req, res, next) => {
  try {
    const token = req.cookies?.refreshToken;
    if (!token) {
      return res.status(400).json({
        message: "refresh token is missing",
      });
    }
    const payload = verifyRefreshToken(token);
    const user = await User.findById(payload.id);
    if (!user) {
      return res.status(401).json({
        message: "User  not found",
      });
    }
    if (user.tokenVersion !== payload.tokenversion) {
      return res.status(401).json({
        message: "Refresh token invalid",
      });
    }

    const newAccessToken = generateAccessToken(user.id);
    const newRefreshToken = generateRefreshToken({
      id: user.id,
      tokenVersion: user.tokenVersion,
    });
    res.cookie("refreshToken", newRefreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV,
      sameSite: "lax",
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    return res.status(200).json({
      message: "TokenRefreshed",
      accessToken: newAccessToken,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
      },
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      messsage: "internal server error",
    });
  }
};

export const forgetPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({
        success: false,
        message: "Please Enter Your Email",
      });
    }
    const normalizedEmail = email.toLowerCase().trim();
    const user = await User.findOne({ email: normalizedEmail });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "No user found with this email",
      });
    }
    const rawToken = crypto.randomBytes(32).toString("hex");
    const hashedToken = crypto
      .createHash("sha256")
      .update(rawToken)
      .digest("hex");

    user.resetPasswordToken = hashedToken;
    user.resetPasswordExpires = new Date(Date.now() + 15 * 60 * 1000);
    await user.save();
    const resetUrl = `${getAppUrl()}${process.env.PORT}/api/user/reset-password?token=${rawToken}`;
    const { data, error } = await sendEmail(
      user.email,
      "onboarding@resend.dev",
      "Reset your password",
      `
        <p>You requested password reset. click on the below link to reset the password:</p>
          <p><a href="${resetUrl}">${resetUrl}</a></p>
        `,
    );
    if (error) {
      return res.status(400).json({
        success: false,
        message: "Failed sending email",
      });
    }
    return res.status(200).json({
      message: "If email exists! we will send a reset link to you",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "failed",
      message: "Some Error Occurred",
    });
  }
};

export const resetPassword = async (req, res, next) => {
  try {
    const { token, password } = req.body;
    if (!token) {
      return res.status(400).json({
        success: false,
        message: "Invalid token",
      });
    }
    if (!password || password.length < 6) {
      return res.status(400).json({
        message: "Password should be at least 6 char long",
      });
    }
    const hashedToken = crypto.createHash("sha256").update(token).digest("hex");
    const user = await User.findOne({
      resetPasswordToken: hashedToken,
      resetPasswordExpires: { $gt: new Date(Date.now()) },
    });
    if (!user) {
      return res.status(400).json({
        success: false,
        message: "No user found",
      });
    }
    const newleyCreatedPassword = await hashPassword(password);
    user.password_hash = newleyCreatedPassword;
    user.resetPasswordToken = undefined;
    user.resetPasswordExpires = undefined;
    await user.save();
    return res.status(200).json({
      message: "password reset successfully",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      messsage: "internal server error",
    });
  }
};
