import { StoreSettings } from "../models/store_settings_model.js";

const DEFAULT_SETTINGS = {
  storeName: "Bazar",
  description: "",
  email: "",
  phone: "",
  address: "",
  city: "",
  country: "",
  postalCode: "",
  currency: "EGP",
  taxRate: 0,
  shippingFee: 0,
  freeShippingThreshold: 0,
  minimumOrderAmount: 0,
  lowStockThreshold: 15,
  storeEnabled: true,
  acceptOrders: true,
};

const getSettingsDocument = async () => {
  let settings = await StoreSettings.findOne();

  if (!settings) {
    settings = await StoreSettings.create(DEFAULT_SETTINGS);
  }

  return settings;
};

export const getStoreSettings = async (req, res) => {
  try {
    const settings = await getSettingsDocument();

    return res.status(200).json({
      status: "Success",
      settings,
    });
  } catch (err) {
    console.error("Get store settings error:", err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateStoreSettings = async (req, res) => {
  try {
    const allowedFields = [
      "storeName",
      "description",
      "email",
      "phone",
      "address",
      "city",
      "country",
      "postalCode",
      "currency",
      "taxRate",
      "shippingFee",
      "freeShippingThreshold",
      "minimumOrderAmount",
      "lowStockThreshold",
      "storeEnabled",
      "acceptOrders",
    ];

    const updates = {};

    for (const field of allowedFields) {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    }

    if (
      updates.storeName !== undefined &&
      typeof updates.storeName !== "string"
    ) {
      return res.status(400).json({
        status: "Failed",
        message: "storeName must be a string",
      });
    }

    const numericFields = [
      "taxRate",
      "shippingFee",
      "freeShippingThreshold",
      "minimumOrderAmount",
      "lowStockThreshold",
    ];

    for (const field of numericFields) {
      if (updates[field] !== undefined) {
        const value = Number(updates[field]);

        if (!Number.isFinite(value) || value < 0) {
          return res.status(400).json({
            status: "Failed",
            message: `${field} must be a valid positive number`,
          });
        }

        updates[field] = value;
      }
    }

    if (
      updates.taxRate !== undefined &&
      updates.taxRate > 100
    ) {
      return res.status(400).json({
        status: "Failed",
        message: "taxRate cannot be greater than 100",
      });
    }

    const booleanFields = [
      "storeEnabled",
      "acceptOrders",
    ];

    for (const field of booleanFields) {
      if (
        updates[field] !== undefined &&
        typeof updates[field] !== "boolean"
      ) {
        return res.status(400).json({
          status: "Failed",
          message: `${field} must be a boolean`,
        });
      }
    }

    let settings = await StoreSettings.findOne();

    if (!settings) {
      settings = await StoreSettings.create({
        ...DEFAULT_SETTINGS,
        ...updates,
      });
    } else {
      Object.assign(settings, updates);
      await settings.save();
    }

    return res.status(200).json({
      status: "Success",
      message: "Store settings updated successfully",
      settings,
    });
  } catch (err) {
    console.error("Update store settings error:", err);

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};