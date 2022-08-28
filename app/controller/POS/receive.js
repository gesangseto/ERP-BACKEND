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
  getPosUserBranchCode,
} = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    const check = await getReceive(req.query);
    if (check.data.length > 0 && req.query.hasOwnProperty("pos_receive_id")) {
      let child = await getDetailReceive({
        pos_receive_id: req.query.pos_receive_id,
      });
      check.data[0].detail = child.data;
    }
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.getByBranch = async function (req, res) {
  var data = { data: req.query };
  try {
    let user_id = req.headers.user_id;
    let branch = await getPosUserBranchCode({ user_id: user_id });
    let check = await getReceive({ ...req.query, pos_branch_code: branch });
    if (check.data.length > 0 && req.query.hasOwnProperty("pos_receive_id")) {
      let child = await getDetailReceive({
        pos_receive_id: req.query.pos_receive_id,
      });
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
    let body = req.body;
    body.pos_receive_id = utils.generateId();
    body.status = 0;
    let items = [];
    var req_data = ["mst_supplier_id", "pos_branch_code", "item"];
    for (const row of req_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    if (Array.isArray(body.item) == false) {
      throw new Error(`Item must be an array!`);
    }

    for (const it of body.item) {
      // var req_data = ["batch_no", "mfg_date", "exp_date", "qty"];
      var req_data = ["mfg_date", "exp_date", "qty"];
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
        it.qty = it.qty;
        it.qty_stock = it.qty * _getItem.mst_item_variant_qty;
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
    let body = req.body;
    var require_data = ["pos_receive_id", "is_approve"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _body = {
      pos_receive_id: body.pos_receive_id,
      is_approve: body.is_approve,
      pos_receive_note: body.pos_receive_note,
    };

    // Reject;
    if (_body.is_approve == "false") {
      if (!_body.pos_receive_note) {
        throw new Error(`Receive Note is required!`);
      }
      _body.status = "-1";
      _body.is_received = false;
      var update_data = await models.update_query({
        data: _body,
        table: "pos_receive",
        key: "pos_receive_id",
      });
      return response.response(update_data, res);
    }
    // Approve;
    // delete body.pos_receive_note;
    let _check = await getReceive(_body);
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Receive is not found!`);
    } else if (_check.data[0].status != 0) {
      throw new Error(`Receive has already processed!`);
    }
    _body.status = "1";
    _body.is_received = true;
    var update_data = await models.update_query({
      data: _body,
      table: "pos_receive",
      key: "pos_receive_id",
    });
    if (update_data.error) {
      throw new Error(update_data.message);
    }
    let _data = { ..._check.data[0], ..._body };
    let _inbound = await proccessToInbound(_data);
    let _stock = await proccessToStock(_data);
    let _res = await models.exec_query(`${_inbound}${_stock}`);
    if (_res.error) {
      throw new Error(_res.message);
    }
    return response.response(_res, res, false);
  } catch (error) {
    // ROLLBACK
    req.body.status = "0";
    req.body.is_received = null;
    var update_data = await models.update_query({
      data: req.body,
      table: "pos_receive",
      key: "pos_receive_id",
    });
    data.error = true;
    data.message = `${error}`;
    // data.message = `ROLLBACK`;
    return response.response(data, res, false);
  }
};
