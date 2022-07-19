"use strict";
const response = require("../response");
const models = require("../models");
const { getDepartment } = require("./get_data");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
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
    let getData = await getDepartment(req.query);
    return response.response(getData, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
  // LINE WAJIB DIBAWA
};

exports.insert = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();

    const require_data = ["user_department_name", "user_department_code"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    req.body.created_by = req.headers.user_id;
    var _res = await models.insert_query({
      data: req.body,
      table: "user_department",
    });

    if (_res.error) {
      return response.response(_res, res);
    }
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

    const require_data = ["user_department_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    var _res = await models.update_query({
      data: req.body,
      key: "user_department_id",
      table: "user_department",
    });
    if (_res.error) {
      return response.response(_res, res);
    }
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

    const require_data = ["user_department_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    var _res = await models.delete_query({
      data: req.body,
      key: "user_department_id",
      table: "user_department",
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
