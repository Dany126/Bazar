const express = require("express");
const cookieParser = require("cookie-parser");
const cors = require("cors");
const dotenv = require("dotenv");
dotenv.config({ path: "./.env" });

const connectToDB = require("./database/index");
const userRouter = require("./routes/user_routes");
const categoryRouter = require("./routes/category_routes");
const productRouter = require("./routes/product_routes");

const app = express();

connectToDB;

app.use(cookieParser());
app.use(express.json());

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

app.listen(process.env.PORT || 5000, () => {
  console.log("Server is running at port 5000");
});
