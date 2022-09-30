const { Op } = require("sequelize");

function limitOffset(data) {
  const { page, limit } = data;
  if (!page && !limit) return {};
  var start = 0;
  if (page > 1) {
    start = parseInt((page - 1) * limit);
  }
  var end = parseInt(limit);
  return { limit: end, offset: start };
}

function search(data = Object, allowSearch = Array) {
  const { search } = data;
  if (!search || !allowSearch) return {};
  let _arrSearch = [];
  for (const it of allowSearch) {
    _arrSearch.push({ [it]: { [Op.like]: `%${search}%` } });
  }
  let _res = { [Op.or]: _arrSearch };
  return _res;
}

function exactSearch(data = Object, allowSearch = Array) {
  let _data = JSON.parse(JSON.stringify(data));
  delete _data.search;
  delete _data.page;
  delete _data.limit;
  let _res = {};
  for (const it of allowSearch) {
    if (_data[it]) {
      _res[it] = { [Op.eq]: `${_data[it]}` };
    }
  }
  return _res;
}

function betweenDate(data = Object, allowSearch = Array) {
  const { start_date, end_date } = data;
  if (!start_date || !end_date) return {};
  let _res = { [Op.between]: [start_date, end_date] };
  return _res;
}

module.exports = {
  limitOffset,
  search,
  exactSearch,
  betweenDate,
};
