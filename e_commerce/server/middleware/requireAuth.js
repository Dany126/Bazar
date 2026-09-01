import { User } from "../models/user_model.js";
import { verifyAccessToken } from "../utils/token.js";

export async function requireAuth(req, res, next) {
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

    req.user = {
      id: user?.id,
      email: user?.email,
      name: user?.name,
      role: user?.role,
    };
    next();
  } catch (err) {
    return res.status(401).json({
      message: "Invalid Token",
    });
  }
}
