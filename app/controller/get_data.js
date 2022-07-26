const { get_query, getLimitOffset } = require("../models");
const { isJsonString } = require("../utils");

async function getCustomer(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
    AND (LOWER(a.mst_customer_name) LIKE LOWER('%${search}%')
    OR  LOWER(a.mst_customer_email) LIKE LOWER('%${search}%')
    OR  LOWER(a.mst_customer_address) LIKE LOWER('%${search}%')
    OR  LOWER(a.mst_customer_pic) LIKE LOWER('%${search}%')
    OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `
  SELECT *
  FROM mst_customer AS a 
  WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("mst_customer_id")) {
    _sql += ` AND a.mst_customer_id = '${data.mst_customer_id}'`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
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

async function getDepartment(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
    AND (LOWER(a.user_department_name) LIKE LOWER('%${search}%')
    OR  LOWER(a.user_department_code) LIKE LOWER('%${search}%')
    OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = ` SELECT * 
  FROM user_department AS a 
  WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("user_department_id")) {
    _sql += ` AND a.user_department_id = '${data.user_department_id}'`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
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

async function getSection(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
    AND (LOWER(b.user_department_name) LIKE LOWER('%${search}%')
    OR  LOWER(b.user_department_code) LIKE LOWER('%${search}%')
    OR  LOWER(a.user_section_code) LIKE LOWER('%${search}%')
    OR  LOWER(a.user_section_name) LIKE LOWER('%${search}%')
    OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
    *,
    a.flag_delete as flag_delete ,
    a.status AS status,
    CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' END AS status_desc
  FROM user_section AS a 
  LEFT JOIN user_department AS b ON a.user_department_id = b.user_department_id
  WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("user_section_id")) {
    _sql += ` AND a.user_section_id = '${data.user_section_id}'`;
  }
  if (data.hasOwnProperty("user_department_id")) {
    _sql += ` AND b.user_department_id = '${data.user_department_id}'`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }

  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }

  _sql += ` ORDER BY user_section_id DESC`;
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getUser(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
    AND (LOWER(a.user_name) LIKE LOWER('%${search}%')
    OR  LOWER(a.user_email) LIKE LOWER('%${search}%')
    OR  LOWER(c.user_department_name) LIKE LOWER('%${search}%')
    OR  LOWER(b.user_section_name) LIKE LOWER('%${search}%')
    OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
    *,
    a.flag_delete as flag_delete ,
    a.status AS status,
    CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' END AS status_desc
  FROM "user" AS a 
  LEFT JOIN user_section AS b ON a.user_section_id = b.user_section_id
  Left JOIN user_department AS c ON b.user_department_id = c.user_department_id
  WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND a.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("user_section_id")) {
    _sql += ` AND b.section_id = '${data.user_section_id}'`;
  }
  if (data.hasOwnProperty("user_department_id")) {
    _sql += ` AND c.user_department_id = '${data.user_department_id}'`;
  }

  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }

  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
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
async function getApproval(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
    AND (LOWER(a.approval_desc) LIKE LOWER('%${search}%')
    OR  LOWER(b.user_name) LIKE LOWER('%${search}%')
    OR  LOWER(c.user_name) LIKE LOWER('%${search}%')
    OR  LOWER(d.user_name) LIKE LOWER('%${search}%')
    OR  LOWER(e.user_name) LIKE LOWER('%${search}%')
    OR  LOWER(f.user_name) LIKE LOWER('%${search}%')
    OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
    *,
    b.user_name AS approval_user_name_1,
    c.user_name AS approval_user_name_2,
    d.user_name AS approval_user_name_3,
    e.user_name AS approval_user_name_4,
    f.user_name AS approval_user_name_5,
    a.flag_delete as flag_delete ,
    a.status AS status,
    CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' END AS status_desc
  FROM "approval" AS a 
  LEFT JOIN "user" AS b ON a.approval_user_id_1 = b.user_id
  LEFT JOIN "user" AS c ON a.approval_user_id_2 = c.user_id
  LEFT JOIN "user" AS d ON a.approval_user_id_3 = d.user_id
  LEFT JOIN "user" AS e ON a.approval_user_id_4 = e.user_id
  LEFT JOIN "user" AS f ON a.approval_user_id_5 = f.user_id
  WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("approval_id")) {
    _sql += ` AND a.approval_id = '${data.approval_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  console.log(_sql);
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getSysMenu(data = Object, onlyQuery = false) {
  let _sql = `SELECT  
    *, 
    a.status AS status
  FROM  sys_menu AS a 
  LEFT JOIN sys_menu_module AS b ON a.sys_menu_module_id=b.sys_menu_module_id
  WHERE a.status='1' 
  `;
  if (data.hasOwnProperty("sys_menu_id")) {
    _sql += ` AND a.sys_menu = '${data.sys_menu}'`;
  }
  if (data.hasOwnProperty("sys_menu_module_id")) {
    _sql += ` AND b.sys_menu_module_id = '${data.sys_menu_module_id}'`;
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }

  _sql += ` ORDER BY a.sys_menu_order ASC`;
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

module.exports = {
  getDepartment,
  getUser,
  getSysMenu,
  getSection,
  getApproval,
  getCustomer,
};
