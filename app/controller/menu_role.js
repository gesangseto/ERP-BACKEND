"use strict";
const response = require("../response");
const utils = require("../utils");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  // LINE WAJIB DIBAWA
  perf.start();
  console.log(`req : ${JSON.stringify(req.query)}`);
  var data = { data: req.query };
  const require_data = ["section_id"];
  for (const row of require_data) {
    if (!req.query[`${row}`]) {
      data.error = true;
      data.message = `${row} is required!`;
      return response.response(data, res);
    }
  }
  // LINE WAJIB DIBAWA
  var $query = `SELECT * FROM sys_menu_role AS a 
  LEFT JOIN sys_menu_child AS b ON b.menu_child_id = a.menu_child_id
  LEFT JOIN user_section AS c ON c.section_id = a.section_id
  LEFT JOIN sys_menu_parent AS d ON d.menu_parent_id = b.menu_parent_id
  WHERE c.section_id='${req.query.section_id}' `;
  // query
  var _menu = await utils.exec_query($query);
  // query
  if (_menu.error || _menu.total == 0) {
    return response.response(_menu, res);
  }
  var _new_parent = [];
  var _temp_parent = {};
  for (const parent of _menu.data) {
    _temp_parent.menu_parent_id = parent.menu_parent_id;
    _temp_parent.menu_parent_name = parent.menu_parent_name;
    _temp_parent.menu_parent_url = parent.menu_parent_url;
    _temp_parent.menu_parent_icon = parent.menu_parent_icon;
    for (const child of _menu.data) {
      var _new_child = [];
      var _temp_child = {};
      if (parent.menu_parent_id == child.menu_parent_id) {
        _temp_child.menu_child_id = child.menu_child_id;
        _temp_child.menu_child_name = child.menu_child_name;
        _temp_child.menu_child_url = child.menu_child_url;
        _temp_child.menu_child_icon = child.menu_child_icon;
        _temp_child.flag_create = child.flag_create;
        _temp_child.flag_read = child.flag_read;
        _temp_child.flag_update = child.flag_update;
        _temp_child.flag_delete = child.flag_delete;
        _temp_child.flag_print = child.flag_print;
        _temp_child.flag_download = child.flag_download;
        _new_child.push(_temp_child);
      }
    }
    _temp_parent.menu_child = _new_child;
    _new_parent.push(_temp_parent);
  }
  _menu.data = _new_parent;
  return response.response(_menu, res);
};

exports.insert = async function (req, res) {
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
  const require_data = ["menu_child_id", "section_id"];
  for (const row of require_data) {
    if (!req.body[`${row}`]) {
      data.error = true;
      data.message = `${row} is required!`;
      return response.response(data, res);
    }
  }
  var key = [];
  var val = [];
  for (const k in req.body) {
    key.push(k);
    val.push(req.body[k]);
  }
  key = key.toString();
  val = "'" + val.join("','") + "'";
  // LINE WAJIB DIBAWA

  var _insert = `INSERT INTO sys_menu_role (${key}) VALUES (${val})`;
  var _res = await utils.exec_query(_insert);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};

exports.update = async function (req, res) {
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
  const require_data = ["menu_role_id"];
  for (const row of require_data) {
    if (!req.body[`${row}`]) {
      data.error = true;
      data.message = `${row} is required!`;
      return response.response(data, res);
    }
  }
  var _data = [];
  for (const k in req.body) {
    _data.push(` ${k} = '${req.body[k]}'`);
  }
  _data = _data.join(",");
  // LINE WAJIB DIBAWA
  var _update = `UPDATE sys_menu_role SET ${_data} WHERE menu_role_id='${req.body.menu_role_id}'`;
  var _res = await utils.exec_query(_update);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};

exports.delete = async function (req, res) {
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
  const require_data = ["menu_role_id"];
  for (const row of require_data) {
    if (!req.body[`${row}`]) {
      data.error = true;
      data.message = `${row} is required!`;
      return response.response(data, res);
    }
  }
  // LINE WAJIB DIBAWA
  var _delete = `DELETE FROM sys_menu_role  WHERE menu_role_id = ${req.body.menu_parent_id}`;
  var _res = await utils.exec_query(_delete);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};
