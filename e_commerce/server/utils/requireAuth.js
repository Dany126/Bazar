import User from "../models/user_model";
import { verifyAccessToken } from "./token";

async function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      message: "you are not auth user! you cant enter the building",
    });
  }
  const token = authHeader.split(" ")[1];
  try {
    const payload = verifyAccessToken(token);
    const user = await User.findById(payload.id);
    if (!user) {
      return res.status(401).json({
        message: "user not found",
      });
    }
    if (user?.tokenVersion !== payload.tokenversion) {
      return res.status(401).json({
        message: "Token invalid",
      });
    }

    req.user = {
      id: user?.id,
      email: user?.email,
      name: user?.email,
      role: user?.role,
      isEmailVerified: user?.isEmailVerified,
    };
    next();
  } catch (err) {
    return res.status(401).json({
      message: "Invalid Token",
    });
  }
}

export default requireAuth;
