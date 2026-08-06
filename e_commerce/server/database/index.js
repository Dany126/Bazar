import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config({ path: "./.env" });

export const connectToDB = mongoose
  .connect(process.env.DB_URI)
  .then(() => {
    console.log("Mongoose Connected Successfully");
  })
  .catch((err) => {
    console.log(err);
  });
