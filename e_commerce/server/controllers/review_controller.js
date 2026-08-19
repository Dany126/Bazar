import { Product } from "../models/product_model.js";
import { Review } from "../models/review_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";

export const createReview = async (req, res) => {
  try {
    const review = await Review.create({
      user: req.user.id,
      ...req.body,
    });
    if (!review) {
      return res.status(400).json({
        status: "Failed",
        message: "Review created successfully",
      });
    }
    const product = await Product.findById(req.body.product);

    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "Product is not found",
      });
    }
    const newAvg = Number(
      (
        (product.avg_rating * product.ratingsQuantity +
          Number(req.body.rating)) /
        (product.ratingsQuantity + 1)
      ).toFixed(1),
    );

    await Product.findByIdAndUpdate(product.id, {
      $inc: {
        ratingsQuantity: 1,
      },
      $set: {
        avg_rating: newAvg,
      },
    });

    return res.status(201).json({
      status: "Success",
      review,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getReview = async (req, res) => {
  try {
    const { id } = req.params;
    const review = await Review.findById(id);
    if (!review) {
      return res.status(200).json({
        status: "Failed",
        message: "Review Not Found",
      });
    }
    return res.status(200).json({
      status: "Success",
      review,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllReviews = async (req, res) => {
  try {
    const { filter, skip, limits, sortBy } = apiFeatures(req.query);
    const reviews = await Review.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy);
    if (!reviews || reviews.length <= 0) {
      return res.status(200).json({
        status: "Failed",
        message: "No review found",
      });
    }
    return res.status(200).json({
      status: "Success",
      reviews,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteReview = async (req, res) => {
  try {
    const { id } = req.params;
    const review = await Review.findById(id);
    const product = await Product.findById(review.Product);

    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "Product is not found",
      });
    }
    const newQuantity = product.ratingsQuantity - 1;

    const newAvg =
      newQuantity === 0
        ? 0
        : Number(
            (
              (product.avg_rating * product.ratingsQuantity - review.rating) /
              newQuantity
            ).toFixed(1),
          );

    await Product.findByIdAndUpdate(review.product, {
      $inc: {
        ratingsQuantity: -1,
      },
      $set: {
        avg_rating: newAvg,
      },
    });
    const deletedreview = await Review.findByIdAndDelete(id);
    if (!deletedreview) {
      return res.status(400).json({
        status: "Failed",
        message: "Review Not Found",
      });
    }
    return res.status(200).json({
      status: "Success",
      message: "Review deleted successfuly",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
