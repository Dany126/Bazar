import mongoose from "mongoose";

export const checkID = async (req, res, next) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({
      status: "Failed",
      message: "Please Enter Valid ID",
    });
  }
  next();
};
