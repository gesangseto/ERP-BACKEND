"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const {
  getItem,
  proccessToStock,
  getDestroy,
  getTrxDetailItem,
} = require("./get_data");
const { calculateSale } = require("./utils");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    // LINE WAJIB DIBAWA
    const check = await getDestroy(req.query);
    if (check.total > 0 && req.query.hasOwnProperty("pos_trx_destroy_id")) {
      let child = await getTrxDetailItem({
        pos_trx_ref_id: req.query.pos_trx_destroy_id,
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
    const check = await getDestroy({ ...req.query, pos_branch_code: branch });
    if (check.total > 0 && req.query.hasOwnProperty("pos_trx_destroy_id")) {
      let child = await getTrxDetailItem({
        pos_trx_ref_id: req.query.pos_trx_destroy_id,
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
    body.pos_trx_destroy_id = utils.generateId();
    body.status = 0;
    let items = [];
    if (!body.item || Array.isArray(body.item) == false) {
      throw new Error(`Item must be an array!`);
    }
    if (!body.pos_branch_code) {
      throw new Error(`Branch is required!`);
    }

    for (const it of body.item) {
      if (!it["mst_item_variant_id"] && !it["barcode"]) {
        throw new Error(`Item (barcode or mst_item_variant_id) is required!`);
      } else {
        let _getItem = await getItem();
        if (_getItem.error || _getItem.data.length == 0) {
          throw new Error(`Item not found!`);
        }
        _getItem = _getItem.data[0];
        it.qty = it.qty;
        it.qty_stock = it.qty * _getItem.mst_item_variant_qty;
        it.pos_trx_ref_id = body.pos_trx_destroy_id;
        it.pos_trx_destroy_id = body.pos_trx_destroy_id;
        delete _getItem.created_at;
        delete _getItem.updated_at;
        items.push({ ..._getItem, ...it });
      }
      if (!it.qty) {
        throw new Error(`Item Qty is required!`);
      }
    }
    let _calculate = await calculateSale({
      header: body,
      detail: items,
      type: "destroy",
    });
    let _header = await models.insert_query({
      data: _calculate,
      table: "pos_trx_destroy",
      onlyQuery: true,
    });
    let _detail = "";
    for (const it of _calculate.item) {
      delete it.updated_by;
      delete it.updated_at;
      _detail += await models.generate_query_insert({
        values: it,
        table: "pos_trx_detail",
      });
    }
    let exec = await models.exec_query(`${_header}${_detail}`);
    exec.data = [_calculate];
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
    var require_data = [
      "pos_trx_destroy_id",
      "is_approve",
      "pos_trx_destroy_note",
    ];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _body = {
      pos_trx_destroy_id: body.pos_trx_destroy_id,
      is_approve: body.is_approve,
      pos_trx_destroy_note: body.pos_trx_destroy_note,
    };

    // Reject;
    if (_body.is_approve == "false") {
      if (!_body.pos_trx_destroy_note) {
        throw new Error(`Destroy Note is required!`);
      }
      _body.status = "-1";
      _body.is_destroyed = false;
      var update_data = await models.update_query({
        data: _body,
        table: "pos_trx_destroy",
        key: "pos_trx_destroy_id",
      });
      return response.response(update_data, res);
    }
    // Approve;
    // delete body.pos_trx_destroy_note;
    let _check = await getDestroy(_body);
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Destroy is not found!`);
    } else if (_check.data[0].status != 0) {
      throw new Error(`Destroy has already processed!`);
    }
    _body.status = "1";
    _body.is_destroyed = true;
    _body.pos_branch_code = body.pos_branch_code;

    var update_data = await models.update_query({
      data: _body,
      table: "pos_trx_destroy",
      key: "pos_trx_destroy_id",
      onlyQuery: true,
    });
    let _stock = await proccessToStock(_body);
    if (_stock.hasOwnProperty("error")) {
      throw new Error(_stock.message);
    }
    let _res = await models.exec_query(`${update_data}${_stock}`);
    if (_res.error) {
      throw new Error(_res.message);
    }
    return response.response(_res, res, false);
  } catch (error) {
    // ROLLBACK
    req.body.status = "0";
    req.body.is_destroyed = null;
    var update_data = await models.update_query({
      data: req.body,
      table: "pos_trx_destroy",
      key: "pos_trx_destroy_id",
    });
    data.error = true;
    data.message = `${error}`;
    // data.message = `ROLLBACK`;
    return response.response(data, res, false);
  }
};
