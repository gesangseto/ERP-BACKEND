"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getUserBranch } = require("./generate_item");
const perf = require("execution-time")();

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA
    perf.start();

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _res = await getUserBranch(req.query);
    return response.response(_res, res);
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
    let body = req.body;
    const require_data = ["user_id", "pos_branch_id", "is_cashier"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        if (row === "is_cashier" && typeof body[`${row}`] != "boolean") {
          throw new Error(`${row} is required!`);
        } else {
          throw new Error(`${row} is required!`);
        }
      }
    }

    let param = { user_id: body.user_id, flag_delete: 0 };
    if (body.is_cashier == "false") {
      param.is_cashier = true;
    }
    let _check = await getUserBranch(param);
    if (_check.data.length > 0) {
      throw new Error(`Cannot add multiple branch on cashier-user!`);
    }
    var _res = await models.insert_query({
      data: body,
      table: "pos_user",
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
    perf.start();
    let body = req.body;
    const require_data = ["pos_user_id"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    if (!body.hasOwnProperty("is_cashier")) {
      throw new Error(`is_cashier is required!`);
    }

    delete body.user_id;
    delete body.pos_branch_id;
    var _checkCurrent = await getUserBranch({ pos_user_id: body.pos_user_id });
    if (_checkCurrent.error || _checkCurrent.data.length == 0) {
      throw new Error(`Pos User ID not found!`);
    }
    _checkCurrent = _checkCurrent.data[0];
    if (body.is_cashier) {
      var _checkOther = await getUserBranch({ user_id: _checkCurrent.user_id });
      for (const it of _checkOther.data) {
        console.log(it);
        if ((it.is_cashier = "false" && body.pos_user_id != it.pos_user_id)) {
          throw new Error(
            `Cannot update to cashier cause user has multiple branch!`
          );
        }
      }
    }

    let _res = await models.update_query({
      data: body,
      table: "pos_user",
      key: "pos_user_id",
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
    perf.start();

    const require_data = ["pos_user_id"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    // LINE WAJIB DIBAWA
    var _res = await models.delete_query({
      data: req.body,
      table: "pos_user",
      key: "pos_user_id",
      deleted: false,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
