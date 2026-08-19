import { Product } from "../models/product_model.js";
import { Wishlist } from "../models/wishlist_model.js";

export const addToWishlist = async (req, res) => {
  try {
    const { id } = req.params;

    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({
        status: "Failed",
        message: "Product not found",
      });
    }

    let wishlist = await Wishlist.findOne({
      user: req.user.id,
    });

    if (wishlist) {
      wishlist = await Wishlist.findOneAndUpdate(
        { user: req.user.id },
        {
          $addToSet: {
            product: id,
          },
        },
        {
          returnDocument: "after",
        },
      );
    } else {
      wishlist = await Wishlist.create({
        user: req.user.id,
        product: [id],
      });
    }

    return res.status(200).json({
      status: "Success",
      wishlist,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getWishlistByUserId = async (req, res) => {
  try {
    const wishList = await Wishlist.find({
      user: req.user.id,
    }).populate("product");
    if (!wishList || wishList.length <= 0) {
      return res.status(404).json({
        status: "Failed",
        message: "No wishlist found for this user",
      });
    }
    return res.status(200).json({
      status: "Success",
      wishList,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteFromWishlist = async (req, res) => {
  try {
    const { id } = req.params;

    const wishlist = await Wishlist.findOneAndUpdate(
      { user: req.user.id },
      {
        $pull: {
          product: id,
        },
      },
      {
        returnDocument: "after",
      },
    );

    if (!wishlist) {
      return res.status(404).json({
        status: "Failed",
        message: "Wishlist not found!",
      });
    }

    return res.status(200).json({
      status: "Success",
      message: "Product removed from wishlist successfully",
      wishlist,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
