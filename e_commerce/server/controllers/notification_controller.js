import { Notification } from "../models/notification_model";

export const createNotification = async (messageData) => {
  try {
    const message = {
      notification: {
        title: messageData.title,
        body: messageData.body,
      },
      token: messageData.fcm_token,
    };

    const response = await admin.messaging().send(message);
    await Notification.create(messageData);
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Something went wrong",
    });
  }
};

export const getAllNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find();
    if (!notifications || notifications.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "No Notifications Found",
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
      message: "Something went wrong",
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
