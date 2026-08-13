export const apiFeatures = (query) => {
  const allowedFilters = [
    "name",
    "category",
    "price",
    "user",
    "isRead",
    "isFavourite",
    "rating",
  ];

  const filter = {};

  for (const field of allowedFilters) {
    if (query[field] !== undefined) {
      if (field === "name") {
        filter[field] = {
          $regex: query.name,
          $options: "i",
        };
      } else {
        filter[field] = query[field];
      }
    }
  }

  if (query.minPrice !== undefined || query.maxPrice !== undefined) {
    filter.price = {};

    if (query.minPrice !== undefined) {
      filter.price.$gte = Number(query.minPrice);
    }

    if (query.maxPrice !== undefined) {
      filter.price.$lte = Number(query.maxPrice);
    }
  }
  const sortBy = query.sort || "name";
  const pages = Number(query.page) || 1;
  const limits = Number(query.limit) || 10;
  const skip = (pages - 1) * limits;
  const obj = {
    filter,
    limits,
    skip,
    sortBy,
  };
  return obj;
};
