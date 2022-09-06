"use strict";
const response = require("../../response");
const models = require("../../models");
const { humanizeText } = require("../../utils");
const moment = require("moment");
const { getWhType } = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let data = await getWhType(req.query);
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
    var require_data = ["wh_mst_wh_type_code", "wh_mst_wh_type_name"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${humanizeText(row)} is required!`);
      }
    }
    var _res = await models.insert_query({
      data: body,
      table: "wh_mst_wh_type",
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
      "wh_mst_wh_type_id",
      "wh_mst_wh_type_code",
      "wh_mst_wh_type_name",
    ];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${humanizeText(row)} is required!`);
      }
    }
    var _res = await models.update_query({
      data: body,
      table: "wh_mst_wh_type",
      key: "wh_mst_wh_type_id",
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
    const require_data = ["wh_mst_wh_type_id"];
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
      table: "wh_mst_wh_type",
      key: "wh_mst_wh_type_id",
      deleted: true,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
