const { get_query, getLimitOffset } = require("../../models");
const moment = require("moment");
const { isJsonString } = require("../../utils");

const genFilterBranch = (branch_code) => {
  let _sql = "";
  if (isArray(branch_code)) {
    let str = JSON.stringify(branch_code).replace(/"/g, "'");
    _sql += ` AND a.wh_mst_branch_code = ANY(ARRAY${str})`;
  } else if (isString(branch_code)) {
    _sql += ` AND a.wh_mst_branch_code = '${branch_code}'`;
  }
  return _sql;
};

async function getWhType(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    let search_query = (str) => {
      return ` 
        AND (CAST(a.wh_mst_wh_type_id AS TEXT) LIKE LOWER('%${str}%')
        OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_wh_type_code) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_wh_type_name) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_wh_type_desc) LIKE LOWER('%${str}%')
        OR  LOWER(b.user_name) LIKE LOWER('%${str}%')
        OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${str}%') ) `;
    };
    if (isJsonString(search)) {
      let query = "";
      for (const it of JSON.parse(search)) {
        query += search_query(it);
      }
      return query;
    }
    return search_query(search);
  };
  let _sql = `SELECT *, a.status AS status FROM wh_mst_wh_type AS a
  LEFT JOIN "user" AS b ON a.created_by = b.user_id
  WHERE 1+1=2 `;

  if (data.hasOwnProperty("wh_mst_wh_type_code")) {
    _sql += ` AND a.wh_mst_wh_type_code = '${data.wh_mst_wh_type_code}'`;
  }
  if (data.hasOwnProperty("wh_mst_wh_type_id")) {
    _sql += ` AND a.wh_mst_wh_type_id = '${data.wh_mst_wh_type_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    _sql += genSearch(data.search);
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getBranch(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    let search_query = (str) => {
      return ` 
        AND (CAST(a.wh_mst_branch_id AS TEXT) LIKE LOWER('%${str}%')
        OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_branch_code) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_branch_name) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_branch_desc) LIKE LOWER('%${str}%')
        OR  LOWER(b.user_name) LIKE LOWER('%${str}%')
        OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${str}%') ) `;
    };
    if (isJsonString(search)) {
      let query = "";
      for (const it of JSON.parse(search)) {
        query += search_query(it);
      }
      return query;
    }
    return search_query(search);
  };
  let _sql = `SELECT *, a.status AS status FROM wh_mst_branch AS a
  LEFT JOIN "user" AS b ON a.created_by = b.user_id
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("wh_mst_branch_code")) {
    _sql += ` AND a.wh_mst_branch_code = '${data.wh_mst_branch_code}'`;
  }
  if (data.hasOwnProperty("search")) {
    _sql += genSearch(data.search);
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getWh(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    let search_query = (str) => {
      return ` 
        AND (CAST(a.wh_mst_wh_type_id AS TEXT) LIKE LOWER('%${str}%')
        OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_wh_type_code) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_wh_type_name) LIKE LOWER('%${str}%')
        OR  LOWER(a.wh_mst_wh_type_desc) LIKE LOWER('%${str}%')
        OR  LOWER(b.user_name) LIKE LOWER('%${str}%')
        OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${str}%') ) `;
    };
    if (data.hasOwnProperty("wh_mst_branch_code")) {
      _sql += genFilterBranch(data.wh_mst_branch_code);
    }

    if (isJsonString(search)) {
      let query = "";
      for (const it of JSON.parse(search)) {
        query += search_query(it);
      }
      return query;
    }
    return search_query(search);
  };
  let _sql = `SELECT *, a.status AS status 
  FROM wh_mst_wh AS a
  LEFT JOIN wh_mst_wh_type AS b ON a.wh_mst_wh_type_code = b.wh_mst_wh_type_code
  LEFT JOIN wh_mst_branch AS c ON a.wh_mst_branch_code = c.wh_mst_branch_code
  WHERE 1+1=2 `;

  if (data.hasOwnProperty("wh_mst_wh_code")) {
    _sql += ` AND a.wh_mst_wh_code = '${data.wh_mst_wh_code}'`;
  }
  if (data.hasOwnProperty("search")) {
    _sql += genSearch(data.search);
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}
module.exports = {
  getWhType,
  getBranch,
  getWh,
};
