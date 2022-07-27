"use strict";
const response = require("../response");
const models = require("../models");
const utils = require("../utils");
const { getItem } = require("./get_data");
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
    let _data = [];
    let check = await getItem(req.query);
    for (const it of check.data) {
      let _variant = `SELECT *,a.status AS status
      FROM mst_item_variant AS a 
      LEFT JOIN mst_packaging AS b ON a.mst_packaging_id = b.mst_packaging_id
      WHERE a.mst_item_id='${it.mst_item_id}';`;
      _variant = await models.exec_query(_variant);
      it.variant = _variant.data;
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
    var require_data = ["mst_item_no", "mst_item_name", "variant"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    if (Array.isArray(req.body.variant) == false) {
      data.error = true;
      data.message = `Variant must be an array!`;
      return response.response(data, res);
    }
    var mst_item_id = utils.generateId();
    req.body.mst_item_id = mst_item_id;

    var _insert = await models.generate_query_insert({
      table: "mst_item",
      values: req.body,
    });

    for (const it of req.body.variant) {
      var require_data = [
        "mst_item_variant_name",
        "mst_item_variant_price",
        "mst_item_variant_qty",
        "mst_packaging_id",
      ];
      for (const row of require_data) {
        if (!it[`${row}`]) {
          data.error = true;
          data.message = `Variant ${row} is required!`;
          return response.response(data, res);
        }
      }
      it.mst_item_id = mst_item_id;
      _insert += await models.generate_query_insert({
        table: "mst_item_variant",
        values: it,
      });
    }
    let _res = await models.exec_query(_insert);
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

    var require_data = [
      "mst_item_id",
      "mst_item_no",
      "mst_item_name",
      "variant",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    if (Array.isArray(req.body.variant) == false) {
      data.error = true;
      data.message = `Variant must be an array!`;
      return response.response(data, res);
    }
    for (const it of req.body.variant) {
      var require_data = [
        "mst_item_variant_name",
        "mst_item_variant_price",
        "mst_item_variant_qty",
        "mst_packaging_id",
      ];
      for (const row of require_data) {
        if (!it[`${row}`]) {
          data.error = true;
          data.message = `Variant ${row} is required!`;
          return response.response(data, res);
        }
      }
    }
    let query = await models.generate_query_update({
      table: "mst_item",
      values: req.body,
      key: "mst_item_id",
    });
    let mst_item_id = req.body.mst_item_id;
    for (const it of req.body.variant) {
      it.mst_item_id = mst_item_id;
      if (it.mst_item_variant_id) {
        query += await models.generate_query_update({
          table: "mst_item_variant",
          values: it,
          key: "mst_item_variant_id",
        });
      } else {
        query += await models.generate_query_insert({
          table: "mst_item_variant",
          values: it,
        });
      }
    }

    // let _get_item = await models.exec_query(
    //   `SELECT * FROM mst_item WHERE mst_item_id = '${mst_item_id}' LIMIT 1`
    // );
    // console.log(_get_item);

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

    if (!req.body[`mst_item_id`] && !req.body[`mst_item_variant_id`]) {
      data.error = true;
      data.message = `Mst Item ID or Mst Item Variant ID is required!`;
      return response.response(data, res);
    }
    // LINE WAJIB DIBAWA
    let body = req.body;
    if (body.mst_item_id) {
      var _res = await models.delete_query({
        data: body,
        table: "mst_item_variant",
        key: "mst_item_id",
        force_delete: true,
      });
    }
    var _res = await models.delete_query({
      data: body,
      table: body.mst_item_id ? "mst_item" : "mst_item_variant",
      key: body.mst_item_id ? "mst_item_id" : "mst_item_variant_id",
      deleted: true,
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
