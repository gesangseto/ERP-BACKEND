"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");
const { getSysRelation } = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    let _res = await getSysRelation(req.query);

    let newData = [];
    for (let it of _res.data) {
      if (req.query.sys_relation_code || req.query.sys_relation_ref_id) {
        let table = it.sys_relation_code.replace("_default", "");
        let getDetail = `SELECT * FROM ${table} WHERE ${table}_id = '${it.sys_relation_ref_id}' LIMIT 1`;
        getDetail = await models.exec_query(getDetail);
        it.detail = getDetail.data[0];
      }
      newData.push(it);
    }
    _res.data = newData;
    return response.response(_res, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.getRelationList = async function (req, res) {
  var data = { data: req.query };
  try {
    const require_data = ["sys_relation_id"];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let check = await getSysRelation({
      sys_relation_id: req.query.sys_relation_id,
    });
    if (check.total == 0) {
      throw new Error(`Id not found`);
    }
    check = check.data[0];
    let table = check.sys_relation_code.replace("_default", "");
    let query = `SELECT * FROM ${table} AS a WHERE a.status ='1' `;
    if (req.query.hasOwnProperty("search")) {
      let search = req.query.search;
      query += `
        AND (LOWER(a.${table}_name) LIKE LOWER('%${search}%') ) `;
    }
    check = await models.get_query(query);
    return response.response(check, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.update = async function (req, res) {
  var data = { data: req.body };
  try {
    const require_data = [
      "sys_relation_id",
      "sys_relation_code",
      "sys_relation_ref_id",
      "sys_relation_name",
    ];

    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    let body = req.body;

    let table = body.sys_relation_code.replace("_default", "");
    let checkData = `SELECT * FROM ${table} WHERE ${table}_id = '${body.sys_relation_ref_id}' LIMIT 1`;
    checkData = await models.get_query(checkData);
    if (checkData.total == 0) {
      throw new Error(`Relation ID not found!`);
    }

    var _res = await models.update_query({
      data: req.body,
      key: "sys_relation_id",
      table: "sys_relation",
    });
    return response.response(_res, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
