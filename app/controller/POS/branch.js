"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getPosBranch, getPosUserBranch } = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    const check = await getPosBranch(req.query);
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.getByUser = async function (req, res) {
  var data = { data: req.query };
  try {
    let user_id = req.headers.user_id;
    let check = {};
    if (user_id === 0) {
      check = await getPosUserBranch();
    } else {
      check = await getPosUserBranch({ user_id: user_id });
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
    body.pos_receive_id = utils.generateId();
    var req_data = ["pos_branch_name", "pos_branch_address"];
    for (const row of req_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _sql = await models.insert_query({
      data: body,
      table: "pos_branch",
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
    body.pos_receive_id = utils.generateId();
    let items = [];
    var req_data = ["pos_branch_id", "pos_branch_name", "pos_branch_address"];
    for (const row of req_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let exec = await models.update_query({
      data: body,
      table: "pos_branch",
      key: "pos_branch_id",
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
