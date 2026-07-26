const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
    min: 11,
  },
  password_hash: {
    type: String,
    required: true,
  },
  resetPasswordToken: {
    type: String,
    default: undefined,
  },
  resetPasswordExpires: {
    type: Date,
    default: undefined,
  },
});

const User = mongoose.model("User", userSchema);

module.exports = User;
