import { Notification } from "../models/notification_model.js";
import { admin, getMessaging } from "../database/firebase.js";
import { apiFeatures } from "../utils/apiFeatures.js";

export const createNotification = async (messageData) => {
  try {
    const message = {
      notification: {
        title: messageData.title,
        body: messageData.body,
      },
      token: messageData.fcm_token,
      data: messageData.data || {},
    };

    const response = await getMessaging(admin).send(message);
    await Notification.create(messageData);
  } catch (err) {
    console.log(err);
  }
};

export const getAllNotifications = async (req, res) => {
  try {
    const query = { ...req.query, ...req.params };
    const { filter, limits, skip, sortBy } = apiFeatures(query);
    const notifications = await Notification.find(filter)
      .sort(sortBy)
      .skip(skip)
      .limit(limits);
    if (!notifications || notifications.length <= 0) {
      return res.status(200).json({
        status: "Failed",
        message: "No Notifications Found",
        notifications,
      });
    }
    return res.status(200).json({
      status: "success",
      notifications,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteNotification = async (req, res) => {
  const { id } = req.params;
  const notification = await Notification.findByIdAndDelete(id);
  if (!notification) {
    return res.status(400).json({
      status: "Failed",
      message: "No Notifications Found",
    });
  }
  return res.status(200).json({
    status: "success",
    message: "Notification deleted successfuly",
  });
};

export const updateNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedNotification = await Notification.findByIdAndUpdate(
      id,
      req.body,
      { returnDocument: "after" },
    );
    if (!updatedNotification) {
      return res.status(404).json({
        status: "Failed",
        message: "Notification With This ID Not Found",
      });
    }
    return res.status(200).json({
      status: "Success",
      updatedNotification,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
