import { initializeApp, cert } from "firebase-admin";
import serviceAccountKey from "../firebase-service.json" with { type: "json" };
import { getMessaging } from "firebase-admin/messaging";

const admin = initializeApp({
  credential: cert(serviceAccountKey),
});

export { admin, getMessaging };
