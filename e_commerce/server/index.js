import express from "express";
import cookieParser from "cookie-parser";
import cors from "cors";
import dotenv from "dotenv";
dotenv.config({ path: "./.env" });

import path from "path";
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

const app = express();

connectToDB;

app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded());
app.use(morgan("dev"));

app.use("/public", express.static(path.join(import.meta.dirname, "./public")));

app.use(
  cors({
    origin: "*",
    methods: ["POST", "GET", "PUT", "DELETE"],
    credentials: true,
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

app.all("*not", (req, res) => {
  return res.status(404).json({
    status: "Failed",
    message: "Endpoint Not Found",
  });
});

app.listen(process.env.PORT || 5000, () => {
  console.log("Server is running at port 5000");
});
