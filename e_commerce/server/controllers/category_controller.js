import { Category } from "../models/category_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";

export const createCategory = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        status: "Failed",
        message: "Image is required",
      });
    }
    const imageUrl = `${req.protocol}://${req.get("host")}/public/${req.file.filename}`;
    console.log(imageUrl);
    const body = { ...req.body, image: imageUrl };
    const category = await Category.create(body);
    if (!category) {
      return res.status(400).json({
        status: "Failed",
        message: "Something went wrong",
      });
    }
    return res.status(201).json({
      status: "success",
      message: "Category Created Successfuly",
      category,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllCategories = async (req, res) => {
  try {
    const { filter, skip, limits, sortBy } = apiFeatures(req.query);
    const categories = await Category.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy)
      .select("-__v");
    if (!categories) {
      return res.status(400).json({
        status: "Failed",
        message: "No category found",
      });
    }
    return res.status(200).json({
      status: "Success",
      categories,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const category = await Category.findById(id);
    if (!category) {
      return res.status(404).json({
        status: "Failed",
        message: "No Category Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      category,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const category = await Category.findById(id);

    if (!category) {
      return res.status(404).json({
        status: "Failed",
        message: "No Category Found With This ID",
      });
    }

    // Build the fields that are allowed to be updated.
    const updateData = {};

    if (req.body.name !== undefined) {
      updateData.name = req.body.name;
    }

    // If a new image was uploaded, replace the image URL.
    if (req.file) {
      updateData.image = `${req.protocol}://${req.get("host")}/public/${req.file.filename}`;
    }

    const updatedCategory = await Category.findByIdAndUpdate(
      id,
      updateData,
      {
        new: true,
        runValidators: true,
      },
    );

    return res.status(200).json({
      status: "Success",
      message: "Category updated successfully",
      updatedCategory,
    });
  } catch (err) {
    console.log("UPDATE CATEGORY ERROR:", err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
export const deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const category = await Category.findByIdAndDelete(id);
    if (!category) {
      return res.status(400).json({
        status: "Failed",
        message: "Category Not Found",
      });
    }
    return res.status(200).json({
      status: "Success",
      message: "Category deleted successfuly",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
