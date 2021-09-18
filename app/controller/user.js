"use strict";
const response = require("../response");
const models = require("../models");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA
    perf.start();
    console.log(`req : ${JSON.stringify(req.query)}`);
    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA
    var $query = `
    SELECT *,a.status AS status
    FROM user AS a 
    LEFT JOIN user_section AS b ON a.section_id = b.section_id
    Left JOIN user_department AS c ON b.department_id = c.department_id
    WHERE 1+1=2 `;
    for (const k in req.query) {
      if (k != "page" && k != "limit") {
        $query += ` AND a.${k}='${req.query[k]}'`;
      }
    }
    if (req.query.page || req.query.limit) {
      var start =
        parseInt(req.query.page) == 1 ? 0 : req.query.page * req.query.limit;
      var end = parseInt(start) + parseInt(req.query.limit);
      $query += ` LIMIT ${start},${end} `;
    }
    // console.log($query);
    // query
    const check = await models.get_query($query);
    // query
    if (check.error) {
      return response.response(check, res);
    }
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
    console.log(`req : ${JSON.stringify(req.body)}`);
    const require_data = [
      "user_name",
      "user_email",
      "user_password",
      "section_id",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
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
    perf.start();
    console.log(`req : ${JSON.stringify(req.body)}`);
    const require_data = ["user_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
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
    perf.start();
    console.log(`req : ${JSON.stringify(req.body)}`);
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
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
