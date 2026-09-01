import express from "express";
import { checkID } from "../middleware/checkID.js";
import {
  deleteNotification,
  getAllNotifications,
  updateNotification,
} from "../controllers/notification_controller.js";

import { requireAuth } from "../middleware/requireAuth.js";

export const notificationRouter = express.Router();

notificationRouter.use(requireAuth);

notificationRouter.route("/").get(getAllNotifications);

notificationRouter
  .route("/:id")
  .delete(checkID, deleteNotification)
  .patch(checkID, updateNotification);
