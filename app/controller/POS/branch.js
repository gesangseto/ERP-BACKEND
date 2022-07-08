"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA
    perf.start();

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    // LINE WAJIB DIBAWA
    var $query = `
    SELECT *,a.status AS status
    FROM pos_branch AS a 
    WHERE a.flag_delete='0' `;
    $query = await models.filter_query($query, req.query);
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
    const require_data = [
      "pos_branch_name",
      "pos_branch_code",
      "pos_branch_address",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    var _res = await models.insert_query({
      data: req.body,
      table: "pos_branch",
    });
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

    const require_data = [
      "pos_branch_id",
      "pos_branch_name",
      "pos_branch_code",
      "pos_branch_address",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    var _res = await models.update_query({
      data: req.body,
      key: "pos_branch_id",
      table: "pos_branch",
    });
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

    const require_data = ["pos_branch_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    // LINE WAJIB DIBAWA
    var _res = await models.delete_query({
      data: req.body,
      table: "pos_branch",
      key: "pos_branch_id",
      deleted: false,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
