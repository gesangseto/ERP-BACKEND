"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");

const moment = require("moment");
const dotenv = require("dotenv");
dotenv.config(); //- MYSQL Module

exports.user_login = async function (req, res) {
  // LINE WAJIB DIBAWA
  var data = { data: req.body };

  try {
    const require_data = ["user_name", "user_password"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    // LINE WAJIB DIBAWA
    req.body.user_password = await utils.encrypt({
      string: req.body.user_password,
    });
    // CHECK IS SUPER ADMIN
    let $query = `
    SELECT *, 
    '0' AS user_id,
    'super_admin' AS user_name,
    '${process.env.DEV_TOKEN}' AS token,
    '${process.env.DEV_TOKEN}' AS user_section_id, 
    'super_admin' AS section_name,
    'super_admin' AS department_id,
    'super_admin' AS department_name
    FROM sys_configuration AS a 
    WHERE a.user_name='${req.body.user_name}' AND a.user_password='${req.body.user_password}' LIMIT 1`;
    var check = await models.exec_query($query);
    if (check.total > 0) {
      return response.response(check, res, false);
    }

    let configuration = await models.get_configuration({});
    let token = await utils.encrypt({ string: moment().format("YMMDHHmmss") });
    // CHECK IS USER
    $query = `
    SELECT *, '${token}' AS token
    FROM "user" AS a
    LEFT JOIN user_section AS b ON a.user_section_id  = b.user_section_id
    Left JOIN user_department AS c ON b.user_department_id = c.user_department_id
    WHERE a.status='1' AND user_name='${req.body.user_name}' AND user_password='${req.body.user_password}' LIMIT 1`;
    var check = await models.exec_query($query);
    if (check.error || check.total == 0) {
      check.error = true;
      check.message = "Wrong Username Or Password !";
      return response.response(check, res);
    }
    if (check.data[0]) {
      var _temp = {
        user_id: check.data[0].user_id,
        created_at: `${moment().format("YYYY-MM-DD HH:mm:ss")}`,
        expired_at: `${moment()
          .add(configuration.expired_token, "days")
          .format("YYYY-MM-DD HH:mm:ss")}`,
        token: token,
      };
      if (configuration.multi_login != 1) {
        await models.delete_query({
          data: _temp,
          key: "user_id",
          table: "user_authentication",
        });
      }
      await models.insert_query({
        data: _temp,
        table: "user_authentication",
      });
    }
    return response.response(check, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error.message} is required!`;
    return response.response(data, res);
  }
};
