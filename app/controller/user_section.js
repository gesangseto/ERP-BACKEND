"use strict";
const response = require("../response");
const utils = require("../utils");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  // LINE WAJIB DIBAWA
  perf.start();
  console.log(`req : ${JSON.stringify(req.query)}`);
  var data = { data: req.query };
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
    FROM user_section AS a 
    WHERE 1+1=2 `;
  for (const k in req.query) {
    if (k != "page" || k != "limit") {
      $query += ` AND a.${k}='${req.query[k]}'`;
    }
  }
  if (req.query.page || req.query.limit) {
    var start =
      parseInt(req.query.page) == 1 ? 0 : req.query.page * req.query.limit;
    var end = parseInt(start) + parseInt(req.query.limit);
    $query += ` LIMIT ${start},${end} `;
  }
  // query
  const check = await utils.exec_query($query);
  // query
  if (check.error) {
    return response.response(check, res);
  }
  return response.response(check, res);
};

exports.insert = async function (req, res) {
  perf.start();
  console.log(`req : ${JSON.stringify(req.body)}`);
  var data = { data: req.body };
  const require_data = ["section_name", "section_code", "department_id"];
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

  var _insert = `INSERT INTO user_section (${key}) VALUES (${val})`;
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
  const require_data = ["section_id"];
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
  var _update = `UPDATE user_section SET ${_data} WHERE section_id='${req.body.section_id}'`;
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
  const require_data = ["section_id"];
  for (const row of require_data) {
    if (!req.body[`${row}`]) {
      data.error = true;
      data.message = `${row} is required!`;
      return response.response(data, res);
    }
  }
  // LINE WAJIB DIBAWA
  var _delete = `DELETE FROM user_section  WHERE section_id = ${req.body.section_id}`;
  var _res = await utils.exec_query(_delete);
  if (_res.error) {
    return response.response(_res, res);
  }
  return response.response(_res, res);
};
