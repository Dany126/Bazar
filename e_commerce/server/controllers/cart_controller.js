import { Cart } from "../models/cart_model.js";
import { Product } from "../models/product_model.js";
import { Variant } from "../models/product_variants_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";

// export const createCart = async (req, res) => {
//   try {
//     const { products } = req.body;

//     const user = req.user.id;

//     // 1. check if product exists
//     const product = await Product.findById(products[0].product);
//     if (!product) {
//       return res.status(400).json({
//         status: "Failed",
//         message: "No Product Found With This ID",
//       });
//     }

//     // 2. check if variant exists
//     const variant = await Variant.findById(products[0].variant);
//     if (!variant) {
//       return res.status(400).json({
//         status: "Failed",
//         message: "No Variant Found With This ID",
//       });
//     }

//     // 3. check if variant exists for this product
//     const variantOfProduct = await Variant.findOne({
//       _id: products[0].variant,
//       product: products[0].product,
//     });

//     if (!variantOfProduct) {
//       return res.status(400).json({
//         status: "Failed",
//         message: "No Variant With This ID Found For This Product",
//       });
//     }

//     const existingCart = await Cart.findOne({ user });

//     // 4. User doesn't have a cart
//     if (!existingCart) {
//       const cart = await Cart.create(req.body);
//       if (!cart) {
//         return res.status(400).json({
//           status: "Failed",
//           message: "Cart is not created",
//         });
//       }
//       return res.status(201).json({
//         status: "Success",
//         message: "Product added to cart successfully",
//       });
//     }

//     // 5. User have cart
//     let flag = false;
//     for (const el of existingCart.products) {
//       if (
//         el.product.equals(products[0].product) &&
//         el.variant.equals(products[0].variant)
//       ) {
//         flag = true;
//         // 6. check for stock here in addittion to the stock calculated in the route
//         const newQuantity = el.quantity + products[0].quantity;
//         if (newQuantity > variant.stock) {
//           return res.status(400).json({
//             status: "Failed",
//             message: `Quantity specified is not available! only ${variant.stock} pieces are available`,
//           });
//         }
//         el.quantity = newQuantity;
//       }
//     }

//     // 7. If same variant and product increase quantity
//     if (flag) {
//       await existingCart.save();
//       return res.status(201).json({
//         status: "Success",
//         message: "Quantity increased successfully",
//       });
//     }

//     // 8. If new variant or product add new product
//     existingCart.products.push(products[0]);
//     await existingCart.save();
//     return res.status(200).json({
//       status: "Success",
//       message: "Product added successfully with this specific variant",
//     });
//   } catch (err) {
//     console.log(err);
//     return res.status(500).json({
//       status: "Failed",
//       message: "Internal server error",
//     });
//   }
// };
export const createCart = async (req, res) => {
/*************  ✨ Windsurf Command ⭐  *************/
/**
 * Get all carts of a user
 * @param {Object} req - Request object

/*******  9d4c7bd4-ff40-4740-983f-9abad9c11c55  *******/  try {
    const { products } = req.body;

    const user = req.user.id;

    // ------------------------------------------------------------
    // Validate request
    // ------------------------------------------------------------

    if (!products || !Array.isArray(products) || products.length === 0) {
      return res.status(400).json({
        status: "Failed",
        message: "Products are required",
      });
    }

    const productData = products[0];

    if (!productData.product || !productData.variant) {
      return res.status(400).json({
        status: "Failed",
        message: "Product and variant are required",
      });
    }

    if (!productData.quantity || productData.quantity < 1) {
      return res.status(400).json({
        status: "Failed",
        message: "Quantity must be at least 1",
      });
    }

    // ------------------------------------------------------------
    // 1. Check if product exists
    // ------------------------------------------------------------

    const product = await Product.findById(productData.product);

    if (!product) {
      return res.status(400).json({
        status: "Failed",
        message: "No Product Found With This ID",
      });
    }

    // ------------------------------------------------------------
    // 2. Check if variant exists
    // ------------------------------------------------------------

    const variant = await Variant.findById(productData.variant);

    if (!variant) {
      return res.status(400).json({
        status: "Failed",
        message: "No Variant Found With This ID",
      });
    }

    // ------------------------------------------------------------
    // 3. Make sure variant belongs to this product
    // ------------------------------------------------------------

    const variantOfProduct = await Variant.findOne({
      _id: productData.variant,
      product: productData.product,
    });

    if (!variantOfProduct) {
      return res.status(400).json({
        status: "Failed",
        message: "No Variant With This ID Found For This Product",
      });
    }

    // ------------------------------------------------------------
    // 4. Check quantity against stock
    // ------------------------------------------------------------

    if (productData.quantity > variant.stock) {
      return res.status(400).json({
        status: "Failed",
        message: `Quantity specified is not available! only ${variant.stock} pieces are available`,
      });
    }

    // ------------------------------------------------------------
    // 5. Find the user's cart
    // ------------------------------------------------------------

    const existingCart = await Cart.findOne({
      user,
    });

    // ------------------------------------------------------------
    // 6. User doesn't have a cart
    // ------------------------------------------------------------

    if (!existingCart) {
      /*
       * IMPORTANT:
       *
       * The old code was:
       *
       *   Cart.create(req.body)
       *
       * That creates the cart without attaching it to req.user.id.
       *
       * We MUST save:
       *
       *   user: user
       *
       */

      const cart = await Cart.create({
        user,
        products: [
          {
            product: productData.product,
            variant: productData.variant,
            quantity: productData.quantity,
          },
        ],
      });

      if (!cart) {
        return res.status(400).json({
          status: "Failed",
          message: "Cart is not created",
        });
      }

      // Populate product and variant so Flutter receives
      // the same structure as GET /cart/
      await cart.populate("products.product");
      await cart.populate("products.variant");

      return res.status(201).json({
        status: "Success",
        message: "Product added to cart successfully",
        cart,
      });
    }

    // ------------------------------------------------------------
    // 7. User already has a cart
    // ------------------------------------------------------------

    let existingItem = null;

    for (const item of existingCart.products) {
      if (
        item.product.equals(productData.product) &&
        item.variant.equals(productData.variant)
      ) {
        existingItem = item;
        break;
      }
    }

    // ------------------------------------------------------------
    // 8. Same product + same variant
    // ------------------------------------------------------------

    if (existingItem) {
      const newQuantity =
        existingItem.quantity + productData.quantity;

      if (newQuantity > variant.stock) {
        return res.status(400).json({
          status: "Failed",
          message: `Quantity specified is not available! only ${variant.stock} pieces are available`,
        });
      }

      existingItem.quantity = newQuantity;

      await existingCart.save();

      await existingCart.populate("products.product");
      await existingCart.populate("products.variant");

      return res.status(200).json({
        status: "Success",
        message: "Quantity increased successfully",
        cart: existingCart,
      });
    }

    // ------------------------------------------------------------
    // 9. Different product or variant
    // ------------------------------------------------------------

    existingCart.products.push({
      product: productData.product,
      variant: productData.variant,
      quantity: productData.quantity,
    });

    await existingCart.save();

    await existingCart.populate("products.product");
    await existingCart.populate("products.variant");

    return res.status(200).json({
      status: "Success",
      message: "Product added successfully with this specific variant",
      cart: existingCart,
    });
  } catch (err) {
    console.log("CREATE CART ERROR:", err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal server error",
    });
  }
};

export const getAllCarts = async (req, res) => {
  try {
    const query = { ...req.params, ...req.query, user: req.user.id };
    const { filter, skip, limits, sortBy } = apiFeatures(query);
    const carts = await Cart.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy)
      .select("-__v")
      .populate("products.variant")
      .populate("products.product");
    if (!carts || carts.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "No cart found",
      });
    }
    return res.status(200).json({
      status: "Success",
      carts,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateCartProduct = async (req, res) => {
  try {
    const { itemId, quantity } = req.body;
    const userId = req.user.id;

    // Find user's cart
    const cart = await Cart.findOne({ user: userId })
      .populate("products.product")
      .populate("products.variant");

    if (!cart) {
      return res.status(404).json({
        status: "Failed",
        message: "Cart not found",
      });
    }

    // Find the specific cart item
    const cartItem = cart.products.find((el) => el._id.equals(itemId));

    if (!cartItem) {
      return res.status(404).json({
        status: "Failed",
        message: "Product not found in cart",
      });
    }

    // Update quantity
    cartItem.quantity = quantity;

    await cart.save();

    return res.status(200).json({
      status: "Success",
      message: "Cart quantity updated successfully",
      cart,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal server error",
    });
  }
};

export const deleteCartProduct = async (req, res) => {
  try {
    const { itemId } = req.body;
    const userId = req.user.id;

    // Find user's cart
    const cart = await Cart.findOne({ user: userId })
      .populate("products.product")
      .populate("products.variant");

    if (!cart) {
      return res.status(404).json({
        status: "Failed",
        message: "Cart not found",
      });
    }

    // Check if cart item exists
    const cartItem = cart.products.find((el) => el._id.equals(itemId));

    if (!cartItem) {
      return res.status(404).json({
        status: "Failed",
        message: "Product not found in cart",
      });
    }

    // Remove the cart item
    cart.products = cart.products.filter((el) => !el._id.equals(itemId));

    await cart.save();

    return res.status(200).json({
      status: "Success",
      message: "Product removed from cart successfully",
      cart,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteAllCartProducts = async (req, res) => {
  try {
    const user = req.user.id;

    // get cart of this user
    const cart = await Cart.findOne({ user });

    // check if the cart exists
    if (!cart) {
      return res.status(404).json({
        status: "Failed",
        message: "No Cart Found For This User!",
      });
    }

    // empty the cart
    cart.products = [];
    await cart.save();

    return res.status(200).json({
      status: "Success",
      message: "Cart Now Is Empty",
      cart,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
