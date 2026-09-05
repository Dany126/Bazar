import { Variant } from "../models/product_variants_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";
import convert from "color-convert";

export const createVariant = async (req, res) => {
  try {
    const color = `#${convert.keyword.hex(req.body.color)}`;
    const variant = await Variant.create(req.body, color);
    if (!variant) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed Creating Variant",
      });
    }
    return res.status(201).json({
      status: "Success",
      variant,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllVariants = async (req, res) => {
  try {
    const query = { ...req.params, ...req.query };
    console.log(query);
    const { filter, limits, skip, sortBy } = apiFeatures(query);
    const variants = await Variant.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy)
      .populate("product");
    if (!variants) {
      return res.status(400).json({
        status: "Failed",
        message: "No Variants Found",
      });
    }
    return res.status(200).json({
      status: "Success",
      variants,
      noOfVariants: variants.length,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getVariant = async (req, res) => {
  try {
    const { id } = req.params;
    const variant = await Variant.findById(id);
    if (!variant) {
      return res.status(404).json({
        status: "Failed",
        message: "No Variant Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      variant,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateVariant = async (req, res) => {
  try {
    const { id } = req.params;
    let body = { ...req.body };
    if (req.body.color) {
      const color = `#${convert.keyword.hex(req.body.color)}`;
      body = { ...req.body, color: color };
    }
    const updatedVariant = await Variant.findByIdAndUpdate(id, body, {
      returnDocument: "after",
    });
    if (!updatedVariant) {
      return res.status(400).json({
        status: "Failed",
        message: "No Variant Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      updatedVariant,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteVariant = async (req, res) => {
  try {
    const { id } = req.params;
    const Variant = await Variant.findByIdAndDelete(id);
    if (!Variant) {
      return res.status(404).json({
        status: "Failed",
        message: "No Variant Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      message: "Variant Deleted Successfuly",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
