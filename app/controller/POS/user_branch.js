"use strict";
const response = require("../../response");
const models = require("../../models");
const { strToBool } = require("../../utils");
const { getPosBranch, getPosUserBranch, getPosUser } = require("./get_data");

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
    // LINE WAJIB DIBAWA
    const check = await getPosUserBranch(req.query);
    if (req.query.pos_branch_id) {
      let newData = [];
      for (const it of check.data) {
        let sql = await getPosUser({ pos_branch_id: it.pos_branch_id });
        it.detail = sql.data;
        newData.push(it);
      }
      check.data = newData;
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
    let body = req.body;
    var req_data = ["user_id", "pos_branch_id"];
    for (const row of req_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let check = await getPosUser({ user_id: body.user_id, status: 1 });
    for (const it of check.data) {
      if (it.is_cashier === true) {
        throw new Error(`User is cashier!`);
      }
    }
    if (check.total > 0 && body.is_cashier == "true") {
      throw new Error(`User already register!`);
    }
    let _sql = await models.insert_query({
      data: body,
      table: "pos_user_branch",
      onlyQuery: true,
    });
    let exec = await models.exec_query(`${_sql}`);
    exec.data = [body];
    return response.response(exec, res);
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
    var req_data = ["pos_user_branch_id", "user_id"];
    for (const row of req_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let check = await getPosUser({ user_id: body.user_id, status: 1 });
    for (const it of check.data) {
      if (body.pos_user_branch_id != it.pos_user_branch_id) {
        if (strToBool(it.is_cashier)) {
          throw new Error(
            `Cannot change user cause the user is cashier on other branch!`
          );
        } else if (strToBool(body.is_cashier)) {
          throw new Error(
            `Cannot change user to cashier, must delete all this user on other branch!`
          );
        }
      }
    }
    let exec = await models.update_query({
      data: body,
      table: "pos_user_branch",
      key: "pos_user_branch_id",
    });
    exec.data = [body];
    return response.response(exec, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.delete = async function (req, res) {
  var data = { data: req.body };
  try {
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
      deleted: true,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
