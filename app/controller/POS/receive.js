"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const {
  getItem,
  proccessToInbound,
  proccessToStock,
  getReceive,
  getDetailReceive,
} = require("./get_data");
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
    // LINE WAJIB DIBAWA
    const check = await getReceive(req.query);
    if (check.data.length > 0 && req.query.hasOwnProperty("pos_receive_id")) {
      let child = await getDetailReceive(req.query.pos_receive_id);
      check.data[0].detail = child.data;
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
    perf.start();
    let body = req.body;
    body.pos_receive_id = utils.generateId();
    let items = [];
    var req_data = ["mst_supplier_id", "item"];
    for (const row of req_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    if (Array.isArray(body.item) == false) {
      throw new Error(`Item must be an array!`);
    }

    for (const it of body.item) {
      var req_data = ["batch_no", "mfg_date", "exp_date", "qty"];
      for (const row of req_data) {
        if (!it[`${row}`]) {
          throw new Error(`${row} on Item is required!`);
        }
      }
      if (!it["mst_item_variant_id"] && !it["barcode"]) {
        throw new Error(`Item (barcode or mst_item_variant_id) is required!`);
      } else {
        let _getItem = await getItem(it);
        if (_getItem.error || _getItem.data.length == 0) {
          throw new Error(`Item not found!`);
        }
        _getItem = _getItem.data[0];
        it.qty = it.qty * _getItem.mst_item_variant_qty;
        it.pos_receive_id = body.pos_receive_id;
        delete _getItem.created_at;
        delete _getItem.updated_at;
        items.push({ ..._getItem, ...it });
      }
    }
    let _header = await models.insert_query({
      data: body,
      table: "pos_receive",
      onlyQuery: true,
    });
    let _detail = "";
    for (const it of items) {
      _detail += await models.generate_query_insert({
        values: it,
        table: "pos_receive_detail",
      });
    }
    let exec = await models.exec_query(`${_header}${_detail}`);
    exec.data = [body];
    return response.response(exec, res);
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
    let body = req.body;
    var require_data = ["pos_receive_id", "is_approve"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }

    // Reject;
    if (body.is_approve == "false") {
      if (!body.pos_receive_note) {
        throw new Error(`Receive Note is required!`);
      }
      body.status = "-1";
      var update_data = await models.update_query({
        data: body,
        table: "pos_receive",
        key: "pos_receive_id",
      });
      return response.response(update_data, res);
    }
    // Approve;
    delete body.pos_receive_note;

    let _check = await getReceive(body);
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Receive is not found!`);
    } else if (_check.data[0].status != 0) {
      throw new Error(`Receive has already processed!`);
    }
    body.status = "1";
    var update_data = await models.update_query({
      data: body,
      table: "pos_receive",
      key: "pos_receive_id",
    });
    if (update_data.error) {
      throw new Error(update_data.message);
    }
    let _data = { ..._check.data[0], ...body };
    let _inbound = await proccessToInbound(_data);
    let _stock = await proccessToStock(_data);
    let _res = await models.exec_query(`${_inbound}${_stock}`);
    if (_res.error) {
      throw new Error(_res.message);
    }
    return response.response(_res, res);
  } catch (error) {
    // ROLLBACK
    req.body.status = "0";
    var update_data = await models.update_query({
      data: req.body,
      table: "pos_receive",
      key: "pos_receive_id",
    });
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
