const jwt = require("jsonwebtoken");

const generateToken = async (id) => {
  const token = jwt.sign({ id }, process.env.TOKEN_SECRET);
  return token;
};

module.exports = generateToken;
