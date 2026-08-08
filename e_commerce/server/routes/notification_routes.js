import express from "express";
import { checkID } from "../middleware/checkID.js";
import {
  deleteNotification,
  getAllNotifications,
} from "../controllers/notification_controller";

const notificationRouter = express.Router();

notificationRouter.route("/").get(getAllNotifications);

notificationRouter.route("/:id").delete(checkID, deleteNotification);
