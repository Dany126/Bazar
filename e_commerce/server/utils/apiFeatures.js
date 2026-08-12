export const apiFeatures = (query) => {
  const allowedFilters = ["name", "category", "price", "isRead", "isFavourite"];

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
