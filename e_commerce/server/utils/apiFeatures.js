export const apiFeatures = (query) => {
  const { categoryId, name, price, page, limit, sort } = query;
  let filter = {};
  if (name) {
    filter.name = name;
  }
  if (categoryId) {
    filter.category = categoryId;
  }
  if (price) {
    filter.price = price;
  }

  const sortBy = sort || "name";
  const pages = page || 1;
  const limits = limit || 10;
  const skip = (pages - 1) * limits;
  console.log(filter);
  const obj = {
    filter,
    limits,
    skip,
    sortBy,
  };
  return obj;
};
