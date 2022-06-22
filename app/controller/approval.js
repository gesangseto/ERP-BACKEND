"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");
const perf = require("execution-time")();

const total_approval = 5;
exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA
    perf.start();

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA
    let $query = `SELECT * FROM approval WHERE 1+1=2;`;
    for (const k in req.query) {
      if (k != "page" && k != "limit") {
        $query += ` AND a.${k}='${req.query[k]}'`;
      }
    }
    if (req.query.page || req.query.limit) {
      var start = 0;
      if (req.query.page > 1) {
        start = parseInt((req.query.page - 1) * req.query.limit);
      }
      var end = parseInt(start) + parseInt(req.query.limit);
      $query += ` LIMIT ${start} OFFSET ${end} `;
    }
    const check = await models.get_query($query);
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
exports.insert = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    req.body.created_by = req.headers.user_id;
    const require_data = [
      "approval_ref_table",
      "approval_desc",
      "approval_user_id_1",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    if (!(await models.checkIsTableExist(req.body.approval_ref_table))) {
      data.error = true;
      data.message = `Table ${req.body.approval_ref_table} does not exist!`;
      return response.response(data, res);
    }
    let usr_id = [];
    for (var i = 1; i <= total_approval; i++) {
      usr_id.push(req.body[`approval_user_id_${i}`]);
    }
    if (utils.hasDuplicatesArray(usr_id)) {
      data.error = true;
      data.message = `User approval is duplicate!`;
      return response.response(data, res);
    }
    let _insert = await models.generate_query_insert({
      table: "approval",
      values: req.body,
    });

    let _res = await models.exec_query(_insert);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.update = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    req.body.created_by = req.headers.user_id;
    const require_data = [
      "approval_id",
      "approval_ref_table",
      "approval_desc",
      "approval_user_id_1",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    if (!(await models.checkIsTableExist(req.body.approval_ref_table))) {
      data.error = true;
      data.message = `Table ${req.body.approval_ref_table} does not exist!`;
      return response.response(data, res);
    }
    let usr_id = [];
    for (var i = 1; i <= total_approval; i++) {
      usr_id.push(req.body[`approval_user_id_${i}`]);
    }
    if (utils.hasDuplicatesArray(usr_id)) {
      data.error = true;
      data.message = `User approval is duplicate!`;
      return response.response(data, res);
    }
    let _update = await models.generate_query_update({
      table: "approval",
      values: req.body,
      key: "approval_id",
    });

    let _res = await models.exec_query(_update);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.delete = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();

    const require_data = ["approval_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA
    var _res = await models.delete_query({
      data: req.body,
      table: "approval",
      key: "approval_id",
      deleted: true,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
