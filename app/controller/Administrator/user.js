"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getUser } = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA
    let query = await getUser(req.query, true);
    const check = await models.get_query(query);
    check.data.forEach(function (v) {
      delete v.user_password;
    });
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
    req.body.created_by = req.headers.user_id;
    const require_data = [
      "user_name",
      "user_email",
      "user_password",
      "user_section_id",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    if (req.body.user_password) {
      req.body.user_password = await utils.encrypt({
        string: req.body.user_password,
      });
    }

    var _res = await models.insert_query({ data: req.body, table: "user" });
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
    const require_data = ["user_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    if (req.body.user_password) {
      req.body.user_password = await utils.encrypt({
        string: req.body.user_password,
      });
    }
    var _res = await models.update_query({
      data: req.body,
      key: "user_id",
      table: "user",
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
    const require_data = ["user_id"];
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
      table: "user",
      key: "user_id",
      deleted: false,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
