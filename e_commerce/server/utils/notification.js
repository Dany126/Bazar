import admin from "../config/firebase.js";

export const sendNotification = async (token, title, body, data = {}) => {
  const message = {
    notification: {
      title,
      body,
    },

    data,

    token,
  };

  try {
    const response = await admin.messaging().send(message);

    console.log("Notification sent:", response);

    return response;
  } catch (error) {
    console.error("FCM Error:", error);
    throw error;
  }
};
