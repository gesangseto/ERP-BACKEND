"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");
const { getSysMenu } = require("./get_data");
const perf = require("execution-time")();

const _flag = {
  flag_create: 0,
  flag_read: 0,
  flag_update: 0,
  flag_delete: 0,
  flag_print: 0,
  flag_download: 0,
};

const generateMenuRole = async (array, section_id, show_all) => {
  let SA = section_id == `${process.env.DEV_TOKEN}`;
  let _format_data = [];
  for (const it of array) {
    let _data = {
      role_section_id: null,
      section_id: section_id,
      ..._flag,
      ...it,
    };
    if (_data.hasOwnProperty("children") && _data.children.length > 0) {
      let _ch = await generateMenuRole(_data.children, section_id, show_all);
      _data.children = _ch;
    } else {
      let get_role = `SELECT * FROM sys_role_section WHERE menu_id='${_data.menu_id}' AND user_section_id='${section_id}' LIMIT 1`;
      get_role = await models.exec_query(get_role);
      if (get_role.total == 1 || SA) {
        var role = get_role.data[0];
        _data.role_section_id = SA ? null : role.role_section_id;
        _data.flag_create = SA ? 1 : role.flag_create;
        _data.flag_read = SA ? 1 : role.flag_read;
        _data.flag_update = SA ? 1 : role.flag_update;
        _data.flag_delete = SA ? 1 : role.flag_delete;
        _data.flag_print = SA ? 1 : role.flag_print;
        _data.flag_download = SA ? 1 : role.flag_download;
      }
    }
    if (show_all) {
      _format_data.push(_data);
    } else {
      if (
        _data.flag_create == 1 ||
        _data.flag_read == 1 ||
        _data.flag_update == 1 ||
        _data.flag_delete == 1 ||
        _data.children.length > 0
      ) {
        _format_data.push(_data);
      }
    }
  }
  return _format_data;
};

const generateQueryMenuRole = async (array) => {
  let sa_token = `${process.env.DEV_TOKEN}`;
  let query = [];
  for (const it of array) {
    if (sa_token == it.section_id) {
      return "";
    }
    if (it.hasOwnProperty("children") && it.children.length > 0) {
      let _query = await generateQueryMenuRole(it.children);
      query = query.concat(_query);
    } else {
      if (it.role_section_id) {
        query.push(
          await models.generate_query_update({
            table: "sys_role_section",
            values: it,
            key: "role_section_id",
          })
        );
      } else {
        query.push(
          await models.generate_query_insert({
            table: "sys_role_section",
            values: it,
          })
        );
      }
    }
  }
  return query;
};

exports.getRoleMenu = async function (req, res) {
  var data = { data: req.query };
  try {
    perf.start();

    const require_data = ["user_section_id"];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // var $query = `SELECT  * FROM  sys_menu AS a WHERE a.status='1' `;
    // query
    // var _menu = await models.exec_query($query);
    let _menu = await getSysMenu(req.query);
    // query
    if (_menu.error || _menu.total == 0) {
      return response.response(_menu, res);
    }

    let show_all = req.query.show_all;
    let section_id = req.query.user_section_id;

    var treeObj = utils.treeify(_menu.data, "menu_id", "menu_parent_id");
    let _format = await generateMenuRole(treeObj, section_id, show_all);
    _menu.data = _format;
    return response.response(_menu, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.insertUpdateRoleMenu = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();

    let roles = req.body;
    if (Array.isArray(roles)) {
      if (roles.length === 0) {
        data.error = true;
        data.message = `No data to change`;
        return response.response(data, res);
      } else {
        for (const it of roles) {
          if (!it.menu_id || !it.section_id) {
            data.error = true;
            data.message = `Data must include [menu_id,section_id]`;
            return response.response(data, res);
          }
        }
      }
    }
    let query = await generateQueryMenuRole(roles);
    query = query.join("");
    let result = await models.exec_query(query);

    return response.response(result, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
