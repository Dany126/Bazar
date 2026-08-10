import jwt from "jsonwebtoken";

export const generateAccessToken = (id) => {
  const token = jwt.sign({ id }, process.env.ACCESS_TOKEN_SECRET, {
    expiresIn: "30m",
  });
  return token;
};

export const generateRefreshToken = ({ id, tokenVersion }) => {
  const token = jwt.sign(
    { id, tokenVersion },
    process.env.REFRESH_TOKEN_SECRET,
    {
      expiresIn: "7d",
    },
  );
  return token;
};

export const verifyAccessToken = (token) => {
  return jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
};

export const verifyRefreshToken = (token) => {
  return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
};
