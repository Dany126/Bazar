import express from "express";
import { checkID } from "../middleware/checkID.js";
import {
  deleteNotification,
  getAllNotifications,
  updateNotification,
} from "../controllers/notification_controller.js";

export const notificationRouter = express.Router();

notificationRouter.route("/").get(getAllNotifications);

<<<<<<< HEAD
notificationRouter.route("/:id").delete(checkID, deleteNotification);


=======
notificationRouter
  .route("/:id")
  .delete(checkID, deleteNotification)
  .patch(checkID, updateNotification);
>>>>>>> 7c297722b87d19fb5b8dbb8a1a982975301bcc83
