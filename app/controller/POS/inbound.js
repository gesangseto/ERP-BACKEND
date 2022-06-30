"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
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
    FROM pos_batch AS a 
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

exports.inbound = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    req.body.created_by = req.headers.user_id;
    var require_data = [
      "pos_batch_no",
      "pos_batch_exp_date",
      "pos_batch_mfg_date",
      "mst_item_id",
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
    req.body.pos_batch_id = utils.generateId();
    let _insert = await models.insert_query({
      data: req.body,
      table: "pos_batch",
    });
    // console.log(_insert);
    // return;
    return response.response(_insert, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.approve = async function (req, res) {
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

const proccessToInbound = async (data) => {
  let _data = { ...data };
  _data.pos_trx_inbound_id = utils.generateId();
  _data.pos_trx_id = _data.pos_trx_inbound_id;
  if (data.hasOwnProperty("mst_supplier_id")) {
    _data.mst_supplier_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "direct";
  } else if (data.hasOwnProperty("mst_customer_id")) {
    _data.mst_customer_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "return";
  } else if (data.hasOwnProperty("mst_warehouse_id")) {
    _data.mst_warehouse_id = data.mst_warehouse_id;
    _data.pos_trx_inbound_type = "warehouse";
  }
  let _insert = await models.generate_query_insert({
    table: "pos_trx_inbound",
    values: _data,
  });
  return _insert;
};

const proccessToStock = async (data) => {
  let _data = { ...data };
  _data.pos_trx_inbound_id = utils.generateId();
  _data.pos_trx_id = _data.pos_trx_inbound_id;
  if (data.hasOwnProperty("mst_supplier_id")) {
    _data.mst_supplier_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "direct";
  } else if (data.hasOwnProperty("mst_customer_id")) {
    _data.mst_customer_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "return";
  } else if (data.hasOwnProperty("mst_warehouse_id")) {
    _data.mst_warehouse_id = data.mst_warehouse_id;
    _data.pos_trx_inbound_type = "warehouse";
  }
  let _current_stock = `SELECT * FROM pos_item_stock WHERE mst_item_id='${_data.mst_item_id}' LIMIT 1;`;
  _current_stock = await models.exec_query(_current_stock);
  let _update_stock = "";
  if (_current_stock.data.length == 0) {
    _update_stock = await models.generate_query_insert({
      table: "pos_item_stock",
      values: _data,
    });
  } else {
    _current_stock = _current_stock.data[0];
    _current_stock.qty = parseInt(_data.qty) + parseInt(_current_stock.qty);
    _update_stock = await models.generate_query_update({
      table: "pos_item_stock",
      values: _current_stock,
      key: "pos_item_stock_id",
    });
  }
  return _update_stock;
};
