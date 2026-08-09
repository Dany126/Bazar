import { User } from "../models/user_model.js";
import { comparePassword, hashPassword } from "../utils/hash.js";

export const getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    if (!users || users.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "No users found",
      });
    }
    return res.status(200).json({
      status: "Success",
      users,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const updateUser = async (req, res) => {
  try {
    const user = await User.findById(req.id);

    if (!user) {
      return res.status(404).json({
        status: "Failed",
        message: "User not found",
      });
    }

    const { newPassword, currentPassword, email, phone, name } = req.body;

    const updateData = {};

    if (newPassword) {
      if (!currentPassword) {
        return res.status(400).json({
          status: "Failed",
          message: "Current password is required",
        });
      }

      const isCorrect = await comparePassword(
        currentPassword,
        user.password_hash,
      );

      if (!isCorrect) {
        return res.status(400).json({
          status: "Failed",
          message: "Current password is not correct",
        });
      }

      updateData.password_hash = await hashPassword(newPassword);
    }

    if (email) {
      updateData.email = email;
    }

    if (phone) {
      updateData.phone = phone;
    }

    if (name) {
      updateData.name = name;
    }

    const updatedUser = await User.findByIdAndUpdate(req.id, updateData, {
      new: true,
      runValidators: true,
    }).select("-password_hash");

    return res.status(200).json({
      status: "success",
      message: "User updated successfully",
      user: updatedUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const deleteUser = async (req, res) => {
  const user = await User.findByIdAndDelete(req.id);
  if (!user) {
    return res.status(404).json({
      status: "Failed",
      message: "User not found",
    });
  }
  return res.status(200).json({
    status: "success",
    message: "user deleted successfuly",
  });
};
