import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import dotenv from "dotenv";
dotenv.config({ path: "./.env" });

import path from "path";
import { dashboardRouter } from "./routes/dashboard_routes.js";
import { connectToDB } from "./database/index.js";
import { userRouter } from "./routes/user_routes.js";
import { categoryRouter } from "./routes/category_routes.js";
import { productRouter } from "./routes/product_routes.js";
import morgan from "morgan";
import { orderRouter } from "./routes/order_routes.js";
import { notificationRouter } from "./routes/notification_routes.js";
import { reviewRouter } from "./routes/review_routes.js";
import { variantRouter } from "./routes/product_variants_routes.js";
import { cartRouter } from "./routes/cart_routes.js";
import { addressRouter } from "./routes/address_routes.js";
import { wishlistRouter } from "./routes/wishlist_routes.js";
import { paymentRouter } from "./routes/payment_routes.js";
import { paymobWebhookRouter } from "./routes/paymobwebhook_routes.js";
import { storeSettingsRouter } from "./routes/store_settings_routes.js";

import { adminTransactionRouter } from "./routes/admin_transaction_routes.js";
const app = express();

connectToDB;

app.use(
  "/api/payments/paymobwebhook",
  express.raw({
    type: "application/json",
  }),
  paymobWebhookRouter,
);
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded());
app.use(morgan("dev"));

app.use("/public", express.static(path.join(import.meta.dirname, "./public")));

app.use(
  cors({
    origin: true,
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  }),
);

//http://localhost:5000/api/user/register
//http://localhost:5000/api/user/login

app.use("/api/user", userRouter);
app.use("/api/category", categoryRouter);
app.use("/api/product", productRouter);
app.use("/api/order", orderRouter);
app.use("/api/notification", notificationRouter);
app.use("/api/review", reviewRouter);
app.use("/api/variant", variantRouter);
app.use("/api/cart", cartRouter);
app.use("/api/address", addressRouter);
app.use("/api/wishlist", wishlistRouter);
app.use("/api/payments", paymentRouter);
app.use("/api/admin/dashboard", dashboardRouter);
app.use("/api/admin/settings", storeSettingsRouter);

app.use("/api/admin/transactions", adminTransactionRouter);
app.all("*not", (req, res) => {
  return res.status(404).json({
    status: "Failed",
    message: "Endpoint Not Found",
  });
});

app.listen(process.env.PORT || 5000, () => {
  console.log("Server is running at port 5000");
});
