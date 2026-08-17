import { Address } from "../models/addess_model.js";
import { apiFeatures } from "../utils/apiFeatures.js";

export const createAddress = async (req, res) => {
  try {
    const address = await Address.create(req.body);
    if (!address) {
      return res.status(400).json({
        status: "Failed",
        message: "Something went wrong while creating address",
      });
    }
    return res.status(201).json({
      status: "Success",
      address,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAllAddresses = async (req, res) => {
  try {
    const { filter, limits, skip, sortBy } = apiFeatures(req.query);
    const addresses = await Address.find(filter)
      .limit(limits)
      .skip(skip)
      .sort(sortBy);
    if (!addresses || addresses.length <= 0) {
      return res.status(400).json({
        status: "Failed",
        message: "No addresses found",
      });
    }
    return res.status(201).json({
      status: "Success",
      addresses,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const getAddress = async (req, res) => {
  try {
    const { id } = req.params;
    const address = await Address.findById(id);
    if (!address) {
      return res.status(400).json({
        status: "Failed",
        message: "No address found with this id",
      });
    }
    return res.status(201).json({
      status: "Success",
      address,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const updateAddress = async (req, res) => {
  try {
    const { id } = req.params;
    const address = await Address.findByIdAndUpdate(id, req.body, {
      returnDocument: "after",
    });
    if (!address) {
      return res.status(400).json({
        status: "Failed",
        message: "No addresses found with this id",
      });
    }
    return res.status(201).json({
      status: "Success",
      address,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};

export const deleteAddress = async (req, res) => {
  try {
    const { id } = req.params;
    const address = await Address.findByIdAndDelete(id);
    if (!address) {
      return res.status(400).json({
        status: "Failed",
        message: "No addresses found with this id",
      });
    }
    return res.status(201).json({
      status: "Success",
      message: "Address deleted sucessfuly",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      status: "Failed",
      message: "Internal Server Error",
    });
  }
};
