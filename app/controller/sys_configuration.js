"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA
    perf.start();
    console.log(`req : ${JSON.stringify(req.query)}`);
    // LINE WAJIB DIBAWA
    var $query = `SELECT * FROM  sys_configuration AS a LIMIT 1 `;
    // query
    var conf = await models.exec_query($query);
    return response.response(conf, res);
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
    var _res = await models.update_query({
      data: req.body,
      key: "id",
      table: "sys_configuration",
    });
    return response.response(_res, res);

  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
