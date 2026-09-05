import express from "express";

import {
  getStoreSettings,
  updateStoreSettings,
} from "../controllers/store_settings_controller.js";

import { requireAuth } from "../middleware/requireAuth.js";
import { restrictTo } from "../middleware/restrictTo.js";

export const storeSettingsRouter = express.Router();

storeSettingsRouter.use(requireAuth);
storeSettingsRouter.use(restrictTo("admin"));

storeSettingsRouter
  .route("/")
  .get(getStoreSettings)
  .patch(updateStoreSettings);