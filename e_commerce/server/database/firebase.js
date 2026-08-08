import admin from "firebase-admin";
import serviceAccountKey from "../firebase-service.json";

admin.initializeApp({
  credential: admin.credential.cert(serviceAccountKey),
});

export default admin;
