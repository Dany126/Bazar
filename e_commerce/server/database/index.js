const mongoose = require("mongoose");

const connectToDB = mongoose
  .connect(process.env.DB_URI)
  .then(() => {
    console.log("Mongoose Connected Successfully");
  })
  .catch((err) => {
    console.log(err);
  });

module.exports = connectToDB;
