const {
  exec_query,
  generate_query_insert,
  generate_query_update,
  get_query,
  getLimitOffset,
} = require("../models");
const { isJsonString } = require("../utils");

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
  // let _data = await exec_query(_sql);
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
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await exec_query(_sql);
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
  let _data = await exec_query(_sql);
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
  let _data = await exec_query(_sql);
  return _data;
}

module.exports = { getDepartment, getUser, getSysMenu, getSection };
