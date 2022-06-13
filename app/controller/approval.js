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
    FROM approval AS a
    WHERE 1+1=2 `;
    for (const k in req.query) {
      if (k != "page" && k != "limit") {
        $query += ` AND a.${k}='${req.query[k]}'`;
      }
    }
    if (req.query.page || req.query.limit) {
      var start = 0;
      if (req.query.page > 1) {
        start = parseInt((req.query.page - 1) * req.query.limit);
      }
      var end = parseInt(start) + parseInt(req.query.limit);
      $query += ` LIMIT ${start},${end} `;
    }
    const check = await models.get_query($query);
    let _data = [];
    for (const it of check.data) {
      let _que = `SELECT * FROM approval_detail WHERE approval_id = '${it.approval_id}'`;
      _que = await models.exec_query(_que);
      it.item = _que.data;
      _data.push(it);
    }
    check.data = _data;
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
    req.body.created_by = req.headers.user_id;
    const require_data = ["approval_ref", "approval_desc", "item"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    let _check_table = `SHOW tables LIKE '${req.body.approval_ref}';`;
    _check_table = await models.exec_query(_check_table);
    if (_check_table.error || _check_table.data.length == 0) {
      data.error = true;
      data.message = `approval_ref ${req.body.approval_ref} does not exist!`;
      return response.response(data, res);
    }
    if (req.body.item.constructor != Array || req.body.item.length == 0) {
      data.error = true;
      data.message = `Item is not an array!`;
      return response.response(data, res);
    }

    let approval_id = `SELECT MAX(approval_id + 1 ) AS approval_id FROM approval LIMIT 1`;
    approval_id = await models.exec_query(approval_id);
    approval_id = approval_id.data[0].approval_id ?? 1;
    req.body.approval_id = approval_id;

    let lvl = 0;
    let _insert_det = "";
    for (const it of req.body.item) {
      lvl += 1;
      if (!it.approval_user_id || !it.approval_level) {
        data.error = true;
        data.message = `User id in item is required!`;
        return response.response(data, res);
      } else if (it.approval_level != lvl) {
        data.error = true;
        data.message = `Level ${lvl} is required!`;
        return response.response(data, res);
      }
      it.approval_id = approval_id;
      _insert_det += await models.generate_query_insert({
        table: "approval_detail",
        values: it,
      });
    }
    req.body.approval_total = lvl;
    let _insert = await models.generate_query_insert({
      table: "approval",
      values: req.body,
    });

    let query = _insert + "\n" + _insert_det;
    console.log(query);
    let _res = await models.exec_query(query);
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
    req.body.created_by = req.headers.user_id;
    const require_data = [
      "approval_ref",
      "approval_id",
      "approval_desc",
      "item",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    let _check_table = `SHOW tables LIKE '${req.body.approval_ref}';`;
    _check_table = await models.exec_query(_check_table);
    if (_check_table.error || _check_table.data.length == 0) {
      data.error = true;
      data.message = `approval_ref ${req.body.approval_ref} does not exist!`;
      return response.response(data, res);
    }
    if (req.body.item.constructor != Array || req.body.item.length == 0) {
      data.error = true;
      data.message = `Item is not an array!`;
      return response.response(data, res);
    }

    let approval_id = req.body.approval_id;
    let lvl = 0;
    let _update_det = "";
    for (const it of req.body.item) {
      lvl += 1;
      if (
        !it.approval_user_id ||
        !it.approval_level ||
        !it.approval_detail_id
      ) {
        data.error = true;
        data.message = `item detail is required!`;
        return response.response(data, res);
      } else if (it.approval_level != lvl) {
        data.error = true;
        data.message = `Level ${lvl} is required!`;
        return response.response(data, res);
      }
      it.approval_id = approval_id;
      _update_det += await models.generate_query_update({
        table: "approval_detail",
        values: it,
        key: "approval_detail_id",
      });
    }
    req.body.approval_total = lvl;
    let _update = await models.generate_query_update({
      table: "approval",
      values: req.body,
      key: "approval_id",
    });

    let query = _update + "\n" + _update_det;
    let _res = await models.exec_query(query);
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
