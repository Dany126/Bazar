import { Order } from "../models/order_model.js";
import { User } from "../models/user_model.js";
import { createPaymobIntention } from "../utils/paymob_service.js";

export const createPayment = async (req, res) => {
  try {
    const { orderId } = req.params;

    // Get the order
    const order = await Order.findById(orderId)
      .populate("user")
      .populate("products.product")
      .populate("products.variant");

    if (!order) {
      return res.status(404).json({
        status: "Failed",
        message: "Order not found",
      });
    }

    // Make sure the order belongs to the logged-in user
    if (order.user._id.toString() !== req.user.id) {
      return res.status(403).json({
        status: "Failed",
        message: "You are not allowed to pay for this order",
      });
    }

    // Don't pay twice
    if (order.paymentStatus === "paid") {
      return res.status(400).json({
        status: "Failed",
        message: "Order is already paid",
      });
    }

    // Make sure this order is supposed to use Paymob/card
    if (order.paymentMethod !== "card") {
      return res.status(400).json({
        status: "Failed",
        message: "This order is not a card payment",
      });
    }

    /*
     * Paymob expects amounts in the smallest currency unit.
     *
     * Example:
     * 100 EGP -> 10000
     */
    const amount = Math.round(order.totalPrice * 100);

    /*
     * Create Paymob items from YOUR order structure.
     *
     * Your structure:
     *
     * products: [
     *   {
     *     product,
     *     variant,
     *     quantity,
     *     price
     *   }
     * ]
     */
    const items = order.products.map((item) => ({
      name: item.product.name,

      amount: Math.round(item.price * 100),

      description: item.product.name,

      quantity: item.quantity,
    }));

    // Create Paymob intention
    const intention = await createPaymobIntention({
      amount,
      orderId: order._id.toString(),
      user: order.user,
      order,
      items,
    });

    /*
     * Unified Checkout URL
     */
    const checkoutUrl =
      `${process.env.PAYMOB_API_URL}/unifiedcheckout/` +
      `?publicKey=${process.env.PAYMOB_PUBLIC_KEY}` +
      `&clientSecret=${intention.client_secret}`;

    return res.status(200).json({
      status: "Success",

      data: {
        checkoutUrl,
        clientSecret: intention.client_secret,
      },
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      status: "Failed",
      message: "Could not create payment",
    });
  }
};
