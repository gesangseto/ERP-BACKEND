"use strict";
const response = require("../../response");
const models = require("../../models");
const { generateId, percentToFloat } = require("../../utils");
const {
  getItem,
  proccessToInbound,
  proccessToStock,
  getTrxDetailItem,
  getSale,
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
    WHERE a.flag_delete='0' `;
    $query = await models.filter_query($query, req.query);
    const check = await models.get_query($query);
    if (req.query.hasOwnProperty("pos_trx_return_id")) {
      let _data = check.data[0];
      let details = await getTrxDetailItem({
        pos_trx_ref_id: _data.pos_trx_return_id,
      });
      check.data[0].detail = details.data;
    }
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
    let pos_trx_return_id = generateId();
    req.body.created_by = req.headers.user_id;
    let body = req.body;
    var require_data = ["pos_trx_sale_id", "return"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    if (!Array.isArray(body.return) || !body.return.length) {
      data.error = true;
      data.message = `Return Item must be in Array`;
      return response.response(data, res);
    }

    for (const it of body.return) {
      if (!it.qty || (!it.mst_item_variant_id && !it.barcode)) {
        data.error = true;
        data.message = `Quantity or Item Variant is not valid`;
        return response.response(data, res);
      }
    }

    let _sale = await getSale({
      pos_trx_sale_id: body.pos_trx_sale_id,
    });
    if (_sale.error || _sale.data.length == 0) {
      data.error = true;
      data.message = `Sale not found!`;
      return response.response(data, res);
    }
    _sale = _sale.data[0];

    body.pos_trx_return_id = pos_trx_return_id;
    body.mst_customer_id = _sale.mst_customer_id;
    body.price_percentage = _sale.price_percentage;
    body.ppn = _sale.ppn;
    body.grand_total_capital_price = 0;
    body.grand_total_price = 0;

    let _returnDetail = "";
    for (const it of body.return) {
      let _item = await getItem(it);
      if (_item.error || _item.data.length == 0) {
        data.error = true;
        data.message = `Item not found!`;
        return response.response(data, res);
      }
      _item = _item.data[0];
      let _detailSale = await getTrxDetailItem({
        pos_trx_ref_id: body.pos_trx_sale_id,
        mst_item_id: _item.mst_item_id,
      });
      if (_detailSale.error || _detailSale.data.length == 0) {
        data.error = true;
        data.message = `Item not found!`;
        return response.response(data, res);
      }
      _detailSale = _detailSale.data[0];
      it.qty = it.qty * _item.mst_item_variant_qty;
      if (it.qty > _detailSale.qty) {
        data.error = true;
        data.message = `Your input qty is over!`;
        return response.response(data, res);
      }

      let _dt = { ...it, ...body };
      _dt.mst_item_variant_id = _item.mst_item_variant_id;
      _dt.mst_item_id = _item.mst_item_id;
      _dt.qty = it.qty;
      _dt.capital_price = _item.mst_item_variant_price;
      _dt.price = _dt.capital_price * percentToFloat(body.price_percentage);
      _dt.total_capital_price = it.qty * _dt.capital_price;
      _dt.total_price = it.qty * _dt.price;
      _dt.pos_trx_ref_id = pos_trx_return_id;

      _returnDetail += await models.generate_query_insert({
        table: "pos_trx_detail",
        values: _dt,
      });

      body.grand_total_capital_price += _dt.total_capital_price;
      body.grand_total_price += _dt.total_price;
    }

    let _return = await models.generate_query_insert({
      table: "pos_trx_return",
      values: body,
    });
    let _res = await models.exec_query(`${_return}${_returnDetail}`);
    _res.data = [{ pos_trx_return_id: pos_trx_return_id }];
    return response.response(_res, res);
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
    var require_data = ["pos_trx_return_id", "is_approve"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    // Reject;
    if (req.body.is_approve == "false") {
      if (!req.body.pos_trx_return_note) {
        data.error = true;
        data.message = `Return Note is required!`;
        return response.response(data, res);
      }
      req.body.status = "-1";
      var update_return = await models.update_query({
        data: req.body,
        table: "pos_trx_return",
        key: "pos_trx_return_id",
      });
      return response.response(update_return, res);
    }
    // Approve;
    delete req.body.pos_trx_return_note;
    let _return = await models.exec_query(
      `SELECT * FROM pos_trx_return WHERE pos_trx_return_id='${req.body.pos_trx_return_id}' AND status = '0' LIMIT 1;`
    );
    if (_return.data.length == 0) {
      data.error = true;
      data.message = `Return Item is not found Or has already processed!`;
      return response.response(data, res);
    }
    req.body.status = "1";
    var update_return = await models.update_query({
      data: req.body,
      table: "pos_trx_return",
      key: "pos_trx_return_id",
    });
    if (update_return.error) {
      return response.response(update_return, res);
    }
    let _data = { ..._return.data[0], ...req.body };
    let _inbound = await proccessToInbound(_data);
    let _stock = await proccessToStock(_data);
    let _res = await models.exec_query(`${_inbound}${_stock}`);
    if (_res.error) {
      // ROLLBACK
      req.body.status = "0";
      var update_return = await models.update_query({
        data: req.body,
        table: "pos_trx_return",
        key: "pos_trx_return_id",
      });
    }
    return response.response(_res, res);
  } catch (error) {
    req.body.status = "0";
    var update_return = await models.update_query({
      data: req.body,
      table: "pos_trx_return",
      key: "pos_trx_return_id",
    });
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
