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

// ============================================================
// GET EXISTING SETTINGS
// ============================================================

const getSettingsDocument = async () => {
  let settings = await StoreSettings.findOne();

  if (!settings) {
    console.log(
      "No store settings document found. Creating default settings..."
    );

    settings = await StoreSettings.create(
      DEFAULT_SETTINGS
    );
  }

  return settings;
};

// ============================================================
// GET SETTINGS
// ============================================================

export const getStoreSettings = async (req, res) => {
  try {
    console.log(
      "=============================================="
    );

    console.log("GET /api/admin/settings");

    const settings =
      await getSettingsDocument();

    console.log("SETTINGS FROM DATABASE:");
    console.log(settings.toObject());

    console.log(
      "=============================================="
    );

    // Prevent browser from caching settings.
    res.setHeader(
      "Cache-Control",
      "no-store, no-cache, must-revalidate, proxy-revalidate"
    );

    res.setHeader(
      "Pragma",
      "no-cache"
    );

    res.setHeader(
      "Expires",
      "0"
    );

    return res.status(200).json({
      status: "Success",
      settings: settings.toObject(),
    });
  } catch (error) {
    console.error(
      "GET STORE SETTINGS ERROR:",
      error
    );

    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

// ============================================================
// UPDATE SETTINGS
// ============================================================

export const updateStoreSettings = async (
  req,
  res
) => {
  try {
    console.log("");
    console.log(
      "=============================================="
    );
    console.log(
      "PATCH /api/admin/settings"
    );
    console.log(
      "=============================================="
    );

    console.log("REQUEST BODY:");
    console.log(req.body);

    // --------------------------------------------------------
    // Make sure body exists
    // --------------------------------------------------------

    if (
      !req.body ||
      typeof req.body !== "object"
    ) {
      return res.status(400).json({
        status: "Failed",
        message: "Request body is required",
      });
    }

    // --------------------------------------------------------
    // Allowed fields
    // --------------------------------------------------------

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

    console.log("FIELDS TO UPDATE:");
    console.log(updates);

    // --------------------------------------------------------
    // Store name
    // --------------------------------------------------------

    if (
      updates.storeName !== undefined &&
      typeof updates.storeName !== "string"
    ) {
      return res.status(400).json({
        status: "Failed",
        message: "storeName must be a string",
      });
    }

    // --------------------------------------------------------
    // Numeric fields
    // --------------------------------------------------------

    const numericFields = [
      "taxRate",
      "shippingFee",
      "freeShippingThreshold",
      "minimumOrderAmount",
      "lowStockThreshold",
    ];

    for (const field of numericFields) {
      if (updates[field] !== undefined) {
        const value = Number(
          updates[field]
        );

        if (
          !Number.isFinite(value) ||
          value < 0
        ) {
          return res.status(400).json({
            status: "Failed",
            message:
              `${field} must be a valid non-negative number`,
          });
        }

        updates[field] = value;
      }
    }

    // --------------------------------------------------------
    // Tax validation
    // --------------------------------------------------------

    if (
      updates.taxRate !== undefined &&
      updates.taxRate > 100
    ) {
      return res.status(400).json({
        status: "Failed",
        message:
          "taxRate cannot be greater than 100",
      });
    }

    // --------------------------------------------------------
    // Boolean fields
    // --------------------------------------------------------

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
          message:
            `${field} must be a boolean`,
        });
      }
    }

    // --------------------------------------------------------
    // If store disabled, don't accept orders
    // --------------------------------------------------------

    if (
      updates.storeEnabled === false
    ) {
      updates.acceptOrders = false;
    }

    // --------------------------------------------------------
    // Find existing settings
    // --------------------------------------------------------

    let settings =
      await StoreSettings.findOne();

    // --------------------------------------------------------
    // First save
    // --------------------------------------------------------

    if (!settings) {
      console.log(
        "No existing settings. Creating document..."
      );

      settings =
        await StoreSettings.create({
          ...DEFAULT_SETTINGS,
          ...updates,
        });
    }

    // --------------------------------------------------------
    // Existing settings
    // --------------------------------------------------------

    else {
      console.log(
        "Existing settings found."
      );

      console.log(
        "MongoDB document ID:",
        settings._id.toString()
      );

      Object.assign(
        settings,
        updates
      );

      console.log(
        "Saving document..."
      );

      await settings.save();
    }

    // --------------------------------------------------------
    // Read AGAIN from MongoDB
    // --------------------------------------------------------

    const savedSettings =
      await StoreSettings.findById(
        settings._id
      );

    if (!savedSettings) {
      throw new Error(
        "Settings disappeared after save"
      );
    }

    console.log(
      "=============================================="
    );

    console.log(
      "STORE SETTINGS SAVED SUCCESSFULLY"
    );

    console.log(
      "DATABASE ID:",
      savedSettings._id.toString()
    );

    console.log(
      "DATABASE DATA:"
    );

    console.log(
      savedSettings.toObject()
    );

    console.log(
      "=============================================="
    );

    return res.status(200).json({
      status: "Success",
      message:
        "Store settings updated successfully",
      settings:
        savedSettings.toObject(),
    });
  } catch (error) {
    console.error(
      "=============================================="
    );

    console.error(
      "UPDATE STORE SETTINGS ERROR"
    );

    console.error(error);

    console.error(
      "=============================================="
    );

    return res.status(500).json({
      status: "Failed",
      message:
        error.message ||
        "Internal Server Error",
    });
  }
};