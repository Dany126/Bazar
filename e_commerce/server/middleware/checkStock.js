import { Variant } from "../models/product_variants_model.js";

export const checkStock = async (req, res, next) => {
  const { products } = req.body;
  if (!products || products.length === 0) {
    return res.status(400).json({
      status: "Failed",
      message: "Cannot make order without products! Please provide products",
    });
  }
  for (const el of products) {
    let result = await Variant.findById(el.variant);
    if (!result) {
      return res.status(400).json({
        status: "Failed",
        message: "No variant found with this ID!",
      });
    }
    if (result.stock <= 0 || el.quantity > result.stock) {
      return res.status(400).json({
        status: "Failed",
        message: `There is no available pieces of ${result.name} product`,
      });
    }
  }
  next();
};
