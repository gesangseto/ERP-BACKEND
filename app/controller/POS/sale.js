"use strict";
const response = require("../../response");
const models = require("../../models");
const { percentToFloat, generateId } = require("../../utils");
const {
  getStockItem,
  getTrxDetailItem,
  getCashier,
  getSale,
  getSaleByCashier,
  getItem,
} = require("./generate_item");
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
    let check = await getSale(req.query);
    if (check.data.length == 1 && req.query.pos_trx_sale_id) {
      let it = check.data[0];
      it.pos_trx_ref_id = req.query.pos_trx_sale_id;
      console.log(it);
      let _detail = await getTrxDetailItem(it);
      check.data[0].detail = _detail.data;
    }
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.getByCashier = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA
    perf.start();

    const require_data = ["pos_cashier_id"];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA
    let check = await getSaleByCashier(req.query);
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.newSale = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let pos_trx_sale_id = generateId();
    req.body.created_by = req.headers.user_id;
    let body = req.body;
    let _check = await getCashier({
      created_by: body.created_by,
      is_cashier_open: true,
    });
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Please open cashier first!`);
    }
    var require_data = ["sale_item"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    body.pos_trx_sale_id = pos_trx_sale_id;
    let mst_customer_id = body.mst_customer_id;
    if (!body.mst_customer_id) {
      mst_customer_id = await models.getDefaultId("mst_customer_default");
      if (!mst_customer_id) {
        throw new Error(
          `Please setting Default Customer first or please input the Customer`
        );
      }
    }
    if (!Array.isArray(body.sale_item) || !body.sale_item.length) {
      throw new Error(`Sale Item must be in Array`);
    }
    for (const it of body.sale_item) {
      if (!it.qty || (!it.mst_item_variant_id && !it.barcode)) {
        throw new Error(`Quantity or Item Variant is not valid`);
      }
    }

    let _cust = await models.exec_query(
      `SELECT * FROM mst_customer WHERE mst_customer_id ='${mst_customer_id}' LIMIT 1;`
    );
    if (_cust.error || _cust.data.length == 0) {
      throw new Error(`Customer not found`);
    }
    _cust = _cust.data[0];

    body.mst_customer_id = mst_customer_id;
    body.price_percentage = _cust.price_percentage;
    body.ppn = _cust.mst_customer_ppn;
    body.grand_total_capital_price = 0;
    body.grand_total_price = 0;

    let _saleDetail = "";
    let _updateStock = "";
    for (const it of body.sale_item) {
      let _item = await getStockItem(it);
      _item = _item.data[0];
      if (!_item) {
        throw new Error(`Item Variant is not found!`);
      }

      it.qty = it.qty * _item.mst_item_variant_qty;
      if (_item.qty < it.qty) {
        throw new Error(`Request ${it.qty} Item Variant stock is not enough!`);
      }
      let _dt = { ...it, ...body };
      _dt.mst_item_variant_id = _item.mst_item_variant_id;
      _dt.mst_item_id = _item.mst_item_id;
      _dt.qty = it.qty;
      _dt.capital_price = _item.mst_item_variant_price;
      _dt.price = _dt.capital_price * percentToFloat(_cust.price_percentage);
      _dt.pos_trx_ref_id = pos_trx_sale_id;

      _saleDetail += await models.generate_query_insert({
        table: "pos_trx_detail",
        values: _dt,
      });

      _item.qty = parseInt(_item.qty) - it.qty;
      _updateStock += await models.generate_query_update({
        table: "pos_item_stock",
        values: _item,
        key: "pos_item_stock_id",
      });

      body.grand_total_capital_price += _dt.total_capital_price;
      body.grand_total_price += _dt.total_price;
    }
    let _sale = await models.generate_query_insert({
      table: "pos_trx_sale",
      values: body,
    });
    let _res = await models.exec_query(`${_sale}${_saleDetail}${_updateStock}`);
    _res.data = [{ pos_trx_sale_id: pos_trx_sale_id }];
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.paySale = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    req.body.created_by = req.headers.user_id;

    var require_data = ["pos_trx_sale_id", "payment_type"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    let body = req.body;
    let sale = await getSale(body);
    if (sale.error || sale.data.length == 0) {
      data.error = true;
      data.message = `Sale not found!`;
      return response.response(data, res);
    }
    sale = sale.data[0];
    if (sale.is_paid) {
      data.error = true;
      data.message = `Sale is already paid!`;
      return response.response(data, res);
    }
    body.is_paid = true;
    let _res = await models.generate_query_update({
      values: body,
      table: "pos_trx_sale",
      key: "pos_trx_sale_id",
    });
    _res = await models.exec_query(_res);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
