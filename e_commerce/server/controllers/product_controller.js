import { Product } from "../models/product_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";
import { Wishlist } from "../models/wishlist_model.js";

export const createProduct = async (req, res) => {
  try {
    if (!req.files) {
      return res.status(400).json({
        status: "Failed",
        message: "Image is required",
      });
    }
    const imageUrls = req.files.map(
      (file) => `${req.protocol}://${req.get("host")}/public/${file.filename}`,
    );

    const body = {
      image: imageUrls,
      
      price: Number(req.body.price),
      name: req.body.name,
      category: req.body.category,
    };
    const product = await Product.create(body);
    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "Failed creating a product",
      });
    }
    return res.status(201).json({
      status: "Success",
      product,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllProducts = async (req, res) => {
  try {
    const query = { ...req.params, ...req.query };

    const { filter, limits, skip, sortBy } = apiFeatures(query);

    const products = await Product.find(filter)
      .sort(sortBy)
      .skip(skip)
      .limit(limits);

    if (!products.length) {
      return res.status(404).json({
        status: "Failed",
        message: "No product found",
      });
    }

    const wishlist = await Wishlist.findOne({
      user: req.user.id,
    }).select("product");

    const wishlistIds = new Set(
      wishlist?.product.map((id) => id.toString()) || [],
    );

    const result = products.map((product) => ({
      ...product.toObject(),
      isFavourite: wishlistIds.has(product._id.toString()),
    }));

    return res.status(200).json({
      status: "Success",
      products: result,
      noOfProducts: result.length,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }
    return res.status(200).json({
      status: "Success",
      product,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
const deleteOldImages = (images) => {
  if (!Array.isArray(images)) {
    return;
  }

  for (const imageUrl of images) {
    try {
      if (!imageUrl) {
        continue;
      }

      const url = new URL(imageUrl);

      const relativePath = decodeURIComponent(
        url.pathname,
      ).replace(/^\/+/, "");

      const filePath = path.join(
        process.cwd(),
        relativePath,
      );

      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);

        console.log(
          "Deleted old product image:",
          filePath,
        );
      }
    } catch (error) {
      console.log(
        "Could not delete old product image:",
        error.message,
      );
    }
  }
};
export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;

    /*
    |--------------------------------------------------------------------------
    | Find existing product
    |--------------------------------------------------------------------------
    */

    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }

    /*
    |--------------------------------------------------------------------------
    | Prepare update
    |--------------------------------------------------------------------------
    */

    const updateData = {};

    /*
    |--------------------------------------------------------------------------
    | Name
    |--------------------------------------------------------------------------
    */

    if (
      req.body.name !== undefined &&
      req.body.name !== null &&
      String(req.body.name).trim() !== ""
    ) {
      updateData.name = String(
        req.body.name,
      ).trim();
    }

    /*
    |--------------------------------------------------------------------------
    | Category
    |--------------------------------------------------------------------------
    */

    if (
      req.body.category !== undefined &&
      req.body.category !== null &&
      String(req.body.category).trim() !== ""
    ) {
      updateData.category = String(
        req.body.category,
      ).trim();
    }

    /*
    |--------------------------------------------------------------------------
    | Price
    |--------------------------------------------------------------------------
    */

    if (
      req.body.price !== undefined &&
      req.body.price !== null &&
      req.body.price !== ""
    ) {
      const price = Number(req.body.price);

      if (!Number.isFinite(price)) {
        return res.status(400).json({
          status: "Failed",
          message: "Invalid product price",
        });
      }

      updateData.price = price;
    }

    /*
    |--------------------------------------------------------------------------
    | IMAGE UPDATE
    |--------------------------------------------------------------------------
    |
    | If the admin selected new images:
    |
    | req.files contains the uploaded files.
    |
    */

    const hasNewImages =
      Array.isArray(req.files) &&
      req.files.length > 0;

    if (hasNewImages) {
      console.log(
        `Updating product ${id} with ${req.files.length} new image(s)`,
      );

      /*
      |--------------------------------------------------------------------------
      | Create URLs for new images
      |--------------------------------------------------------------------------
      */

      const newImageUrls = req.files.map(
        (file) =>
          `${req.protocol}://${req.get("host")}/public/${file.filename}`,
      );

      /*
      |--------------------------------------------------------------------------
      | Delete old images
      |--------------------------------------------------------------------------
      */

      deleteOldImages(product.image);

      /*
      |--------------------------------------------------------------------------
      | Replace image array
      |--------------------------------------------------------------------------
      */

      updateData.image = newImageUrls;
    }

    /*
    |--------------------------------------------------------------------------
    | Nothing to update
    |--------------------------------------------------------------------------
    */

    if (
      Object.keys(updateData).length === 0
    ) {
      return res.status(400).json({
        status: "Failed",
        message:
          "No product fields were provided for update",
      });
    }

    /*
    |--------------------------------------------------------------------------
    | Update MongoDB
    |--------------------------------------------------------------------------
    */

    const updatedProduct =
      await Product.findByIdAndUpdate(
        id,
        updateData,
        {
          new: true,
          runValidators: true,
        },
      );

    if (!updatedProduct) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }

    console.log(
      "PRODUCT UPDATED:",
      updatedProduct._id,
    );

    console.log(
      "UPDATED IMAGES:",
      updatedProduct.image,
    );

    /*
    |--------------------------------------------------------------------------
    | Response
    |--------------------------------------------------------------------------
    */

    return res.status(200).json({
      status: "Success",

      // Keep both names for compatibility.
      product: updatedProduct,
      updatedProduct: updatedProduct,
    });
  } catch (err) {
    console.log(
      "UPDATE PRODUCT ERROR:",
      err,
    );

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;

    const product =
      await Product.findByIdAndDelete(id);

    if (!product) {
      return res.status(404).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }

    /*
    |--------------------------------------------------------------------------
    | Delete product images
    |--------------------------------------------------------------------------
    */

    deleteOldImages(product.image);

    return res.status(200).json({
      status: "Success",
      message: "Product Deleted Successfully",
    });
  } catch (err) {
    console.log(
      "DELETE PRODUCT ERROR:",
      err,
    );

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};