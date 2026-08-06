import { User } from "../models/user_model.js";

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
