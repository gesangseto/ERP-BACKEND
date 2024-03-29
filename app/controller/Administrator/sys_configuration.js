"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    // LINE WAJIB DIBAWA
    var $query = `SELECT * FROM  sys_configuration AS a LIMIT 1 `;
    // query
    var conf = await models.exec_query($query);
    conf.data.forEach(function (v) {
      delete v.user_password;
    });
    return response.response(conf, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.update = async function (req, res) {
  var data = { data: req.body };
  try {
    if (req.body.user_password) {
      req.body.user_password = await utils.encrypt({
        string: req.body.user_password,
      });
    } else {
      delete req.body.user_password;
    }
    var _res = await models.update_query({
      data: req.body,
      key: "id",
      table: "sys_configuration",
    });
    return response.response(_res, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
