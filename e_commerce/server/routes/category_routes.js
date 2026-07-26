const express = require("express");
const {
  createCategory,
  getAllCategories,
} = require("../controllers/category_controller");

const categoryRouter = express.Router();

categoryRouter.route("/").post(createCategory).get(getAllCategories);

module.exports = categoryRouter;
