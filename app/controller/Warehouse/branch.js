"use strict";
const response = require("../../response");
const models = require("../../models");
const { humanizeText } = require("../../utils");
const moment = require("moment");
const { getBranch } = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    let data = await getBranch(req.query);
    return response.response(data, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.insert = async function (req, res) {
  var data = { data: req.body };
  try {
    let body = req.body;
    var require_data = ["wh_mst_branch_code", "wh_mst_branch_name"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${humanizeText(row)} is required!`);
      }
    }
    var _res = await models.insert_query({
      data: body,
      table: "wh_mst_branch",
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
    let body = req.body;
    var require_data = [
      "wh_mst_branch_id",
      "wh_mst_branch_code",
      "wh_mst_branch_name",
    ];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${humanizeText(row)} is required!`);
      }
    }
    var _res = await models.update_query({
      data: body,
      table: "wh_mst_branch",
      key: "wh_mst_branch_id",
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
    const require_data = ["wh_mst_branch_id"];
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
      table: "wh_mst_branch",
      key: "wh_mst_branch_id",
      deleted: true,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
