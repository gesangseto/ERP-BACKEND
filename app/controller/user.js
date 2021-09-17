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
    SELECT * 
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
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
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
  var key = [];
  var val = [];
  for (const k in req.body) {
    key.push(k);
    val.push(req.body[k]);
  }
  key = key.toString();
  val = "'" + val.join("','") + "'";
  // LINE WAJIB DIBAWA

  var _insert = `INSERT INTO user (${key}) VALUES (${val})`;
  var _res = await models.exec_query(_insert);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};

exports.update = async function (req, res) {
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
  const require_data = ["user_id"];
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
  var _update = `UPDATE user SET ${_data} WHERE user_id='${req.body.user_id}'`;
  var _res = await models.exec_query(_update);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};

exports.delete = async function (req, res) {
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
  const require_data = ["user_id"];
  for (const row of require_data) {
    if (!req.body[`${row}`]) {
      data.error = true;
      data.message = `${row} is required!`;
      return response.response(data, res);
    }
  }
  // LINE WAJIB DIBAWA
  var _delete = `DELETE FROM user  WHERE user_id = ${req.body.user_id}`;
  var _res = await models.exec_query(_delete);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};
