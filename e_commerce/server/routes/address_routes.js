import express from "express";
import {
  createAddress,
  deleteAddress,
  getAddress,
  getAllAddresses,
  updateAddress,
} from "../controllers/address_controller.js";
import { checkID } from "../middleware/checkID.js";
import { requireAuth } from "../middleware/requireAuth.js";

export const addressRouter = express.Router();

// addressRouter.use(requireAuth);

addressRouter.route("/").post(createAddress).get(getAllAddresses);

addressRouter
  .route("/:id")
  .get(checkID, getAddress)
  .patch(checkID, updateAddress)
  .delete(checkID, deleteAddress);
