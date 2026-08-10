import express from "express";
import { checkID } from "../middleware/checkID.js";
import {
  deleteNotification,
  getAllNotifications,
  updateNotification,
} from "../controllers/notification_controller.js";

export const notificationRouter = express.Router();

notificationRouter.route("/").get(getAllNotifications);

notificationRouter
  .route("/:id")
  .delete(checkID, deleteNotification)
  .patch(checkID, updateNotification);
