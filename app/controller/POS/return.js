"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const {
  getItem,
  proccessToInbound,
  proccessToStock,
} = require("./generate_item");
const perf = require("execution-time")();

exports.getReturn = async function (req, res) {
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
    FROM pos_trx_return AS a 
    LEFT JOIN mst_item AS b ON a.mst_item_id = b.mst_item_id
    WHERE a.flag_delete='0' `;
    $query = await models.filter_query($query, req.query);
    const check = await models.get_query($query);
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.newReturn = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    req.body.created_by = req.headers.user_id;
    var require_data = [
      "pos_batch_no",
      "pos_batch_exp_date",
      "pos_batch_mfg_date",
      "qty",
      "mst_supplier_id",
    ];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    if (!req.body["mst_item_id"] && !req.body["mst_item_variant_id"]) {
      data.error = true;
      data.message = `Item (mst_item_id or mst_item_variant_id) is required!`;
      return response.response(data, res);
    }

    let body = req.body;
    body.pos_batch_id = utils.generateId();
    let _getItem = await getItem(body);
    if (_getItem.error || _getItem.data.length == 0) {
      data.error = true;
      data.message = `Item not found!`;
      return response.response(data, res);
    }

    if (body["mst_item_variant_id"]) {
      _getItem = _getItem.data[0];
      body.mst_item_id = _getItem.mst_item_id;
      body.qty = body.qty * _getItem.mst_item_variant_qty;
    }

    let _insert = await models.insert_query({
      data: body,
      table: "pos_batch",
    });
    return response.response(_insert, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.ApproveReturn = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    var require_data = ["pos_batch_id", "is_approve"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    // Reject;
    if (req.body.is_approve == "false") {
      if (!req.body.pos_batch_note) {
        data.error = true;
        data.message = `Batch Note is required!`;
        return response.response(data, res);
      }
      req.body.status = "-1";
      var update_batch = await models.update_query({
        data: req.body,
        table: "pos_batch",
        key: "pos_batch_id",
      });
      return response.response(update_batch, res);
    }
    // Approve;
    delete req.body.pos_batch_note;
    let batch = await models.exec_query(
      `SELECT * FROM pos_batch WHERE pos_batch_id='${req.body.pos_batch_id}' AND status = '0' LIMIT 1;`
    );
    if (batch.data.length == 0) {
      data.error = true;
      data.message = `Batch is not found Or has already processed!`;
      return response.response(data, res);
    }
    req.body.status = "1";
    var update_batch = await models.update_query({
      data: req.body,
      table: "pos_batch",
      key: "pos_batch_id",
    });
    if (update_batch.error) {
      return response.response(update_batch, res);
    }
    let _data = { ...batch.data[0], ...req.body };
    let _inbound = await proccessToInbound(_data);
    let _stock = await proccessToStock(_data);
    console.log(_inbound, _stock);
    let _res = await models.exec_query(`${_inbound}${_stock}`);
    if (_res.error) {
      // ROLLBACK
      req.body.status = "0";
      var update_batch = await models.update_query({
        data: req.body,
        table: "pos_batch",
        key: "pos_batch_id",
      });
    }
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
