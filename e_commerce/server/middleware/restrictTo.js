export const restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        status: "Failed",
        message: "Your are not allowed to use this endpoint!",
      });
    }
    next();
  };
};
