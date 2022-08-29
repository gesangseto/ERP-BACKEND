"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");

const total_approval = 5;
exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA
    let $query = `SELECT * FROM approval_flow WHERE 1+1=2;`;
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
      $query += ` LIMIT ${start} OFFSET ${end} `;
    }
    const check = await models.get_query($query, false);
    let _flow = [];
    for (const it of check.data) {
      let child = `SELECT * FROM "${it.approval_ref_table}" WHERE "${it.approval_ref_table}_id"='${it.approval_ref_id}' LIMIT 1`;
      child = await models.exec_query(child);
      it.approval_data = child.data[0];
      _flow.push(it);
    }
    check.data = _flow;
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.update = async function (req, res) {
  var data = { data: req.body };
  try {
    req.body.created_by = req.headers.user_id;
    req.body.updated_by = req.headers.user_id;

    if (!req.body.approval_flow_id) {
      data.error = true;
      data.message = `approval_flow_id is required!`;
      return response.response(data, res);
    }
    if (!req.body.hasOwnProperty("is_approve")) {
      data.error = true;
      data.message = `is_approve is required!`;
      return response.response(data, res);
    }
    if (typeof req.body.is_approve != "boolean") {
      data.error = true;
      data.message = `is_approve must boolean!`;
      return response.response(data, res);
    }
    if (req.body.is_approve == false && !req.body.rejected_note) {
      data.error = true;
      data.message = `rejected_note is required!`;
      return response.response(data, res);
    }
    data = await models.exec_query(
      `SELECT * FROM approval_flow WHERE approval_flow_id='${req.body.approval_flow_id}' LIMIT 1`
    );
    if (data.error) {
      data.error = true;
      data.message = `Approval not found!`;
      return response.response(data, res);
    }
    data = data.data[0];
    let current_id = null;
    for (var i = 1; i <= 5; i++) {
      if (data.approval_current_user_id == data[`approval_user_id_${i}`]) {
        current_id = data[`approval_user_id_${i + 1}`] ?? null;
      }
    }
    req.body.approval_current_user_id = current_id;
    let _update = await models.generate_query_update({
      table: "approval_flow",
      values: req.body,
      key: "approval_flow_id",
    });
    let _res = await models.exec_query(_update);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
