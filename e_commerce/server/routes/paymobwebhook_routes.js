import express from "express";

import { paymobWebhook } from "../controllers/paymobwebhook_controller.js";

export const paymobWebhookRouter = express.Router();

paymobWebhookRouter.post("/", paymobWebhook);
