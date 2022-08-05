"use strict";
const response = require("../../response");
const models = require("../../models");
const { generateId, numberPercent, sumByKey, isInt } = require("../../utils");
const { calculateSale } = require("./utils");
const {
  getStockItem,
  getTrxDetailItem,
  getCashier,
  getSale,
  getSaleByCashier,
  getItem,
  getCustomer,
} = require("./get_data");
const e = require("cors");
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
      let _detail = await getTrxDetailItem(it);
      check.data[0].detail = _detail.data;
    }
    return response.response(check, res, false);
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
    return response.response(check, res, false);
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
    let _cust = await getCustomer({ mst_customer_id: mst_customer_id });
    if (_cust.error || _cust.data.length == 0) {
      throw new Error(`Customer not found`);
    }
    _cust = _cust.data[0];
    body.mst_customer_id = mst_customer_id;
    body.price_percentage = _cust.price_percentage;
    body.ppn = _cust.mst_customer_ppn;
    body.mst_customer_ppn = _cust.mst_customer_ppn;
    body.is_paid = false;
    body.total_price = 0;
    body.grand_total = 0;
    let _calculate = await calculateSale({
      header: body,
      detail: body.sale_item,
    });

    let _sale = await models.generate_query_insert({
      table: "pos_trx_sale",
      values: _calculate,
    });
    let _saleDetail = "";

    for (const it of _calculate.sale_item) {
      _saleDetail += await models.generate_query_insert({
        table: "pos_trx_detail",
        values: it,
      });
    }
    let _res = await models.exec_query(`${_sale}${_saleDetail}`);
    _res.data = [_calculate];
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.updateSale = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let body = req.body;

    let _check = await getCashier({
      created_by: body.updated_by,
      is_cashier_open: true,
    });
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Please open cashier first!`);
    }
    var require_data = ["qty", "mst_item_variant_id", "pos_trx_sale_id"];
    for (const row of require_data) {
      if (!body[`${row}`] && !isInt(body[`${row}`])) {
        throw new Error(`${row} is required!`);
      }
    }
    let _sale = await getSale(body);
    let _saleDetail = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_sale_id,
    });
    let isExist = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_sale_id,
      mst_item_variant_id: body.mst_item_variant_id,
    });
    _sale = _sale.data[0];
    _saleDetail = _saleDetail.data ?? [];
    isExist = isExist.data[0];

    if (!isExist) {
      _saleDetail.push(body);
    } else {
      let newData = _saleDetail;
      _saleDetail = [];
      for (const it of newData) {
        if (it.mst_item_variant_id == body.mst_item_variant_id) {
          it.qty = body.qty;
          it.flag_delete = it.qty == 0 ? 1 : 0;
        }
        _saleDetail.push(it);
      }
    }
    let _calculate = await calculateSale({
      header: _sale,
      detail: _saleDetail,
    });
    let _updateHeader = await models.generate_query_update({
      values: _calculate,
      table: "pos_trx_sale",
      key: "pos_trx_sale_id",
    });
    let _updateDetail = "";
    for (const it of _calculate.sale_item) {
      if (it.hasOwnProperty("pos_trx_detail_id")) {
        _updateDetail += await models.generate_query_update({
          values: it,
          table: "pos_trx_detail",
          key: "pos_trx_detail_id",
        });
      } else {
        _updateDetail += await models.generate_query_insert({
          values: it,
          table: "pos_trx_detail",
        });
      }
    }
    let _res = await models.exec_query(`${_updateHeader}${_updateDetail}`);
    _res.data = [_calculate];
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.deleteSale = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let body = req.body;

    const require_data = ["pos_trx_sale_id"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _detail = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_sale_id,
    });
    let _header = await getSale({
      pos_trx_sale_id: body.pos_trx_sale_id,
    });
    if (_header.error || _header.data.length == 0) {
      throw new Error(`Sale not found!`);
    }

    _detail = _detail.data;
    _header = _header.data[0];
    if (_header.is_paid) {
      throw new Error(`Cannot delete, Sale is already paid!`);
    }

    let param = {
      status: 0,
      flag_delete: 1,
      pos_trx_sale_id: body.pos_trx_sale_id,
      pos_trx_ref_id: body.pos_trx_sale_id,
    };
    var _delHeader = await models.generate_query_update({
      values: param,
      table: "pos_trx_sale",
      key: "pos_trx_sale_id",
    });
    var _delDetail = await models.generate_query_update({
      values: param,
      table: "pos_trx_detail",
      key: "pos_trx_ref_id",
    });
    let _res = models.exec_query(`${_delHeader}${_delDetail}`);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.payment = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let body = req.body;
    var require_data = ["pos_trx_sale_id", "payment_type"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let sale = await getSale(body);
    console.log(sale);
    if (sale.error || sale.data.length == 0) {
      throw new Error(`Sale not found!`);
    }
    sale = sale.data[0];
    if (sale.is_paid) {
      throw new Error(`Sale is already paid!`);
    }
    let sale_detail = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_sale_id,
    });
    let _update_sale = "";
    let _update_stock = "";

    let _newSaleDetail = [];
    for (const it of sale_detail.data) {
      it.qty_stock = it.qty * it.mst_item_variant_qty;
      _newSaleDetail.push(it);
    }

    let _details = sumByKey({
      array: _newSaleDetail,
      key: "mst_item_id",
      sum: "qty",
      sum: "qty_stock",
    });
    for (const it of _details) {
      let _stock = await getStockItem(it);
      _stock = _stock.data[0];
      _stock.qty = _stock.qty - (it.qty_stock ?? it.qty);
      _update_stock += await models.generate_query_update({
        values: _stock,
        table: "pos_item_stock",
        key: "pos_item_stock_id",
      });
    }
    body.is_paid = true;
    _update_sale = await models.generate_query_update({
      values: body,
      table: "pos_trx_sale",
      key: "pos_trx_sale_id",
    });
    let _res = await models.exec_query(`${_update_sale}${_update_stock}`);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res, false);
  }
};
