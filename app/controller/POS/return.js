"use strict";
const response = require("../../response");
const models = require("../../models");
const {
  generateId,
  numberPercent,
  sumByKey,
  isInt,
  diffDate,
} = require("../../utils");
const { calculateSale } = require("./utils");
const {
  getStockItem,
  getTrxDetailItem,
  getCashier,
  getSale,
  getSaleByCashier,
  getItem,
  getCustomer,
  getPosConfig,
} = require("./generate_item");
const moment = require("moment");
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
    let check = await getSale(req.query);
    if (check.data.length == 1 && req.query.pos_trx_return_id) {
      let it = check.data[0];
      it.pos_trx_ref_id = req.query.pos_trx_return_id;
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

exports.newReturn = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let today = moment().format("YYYY-MM-DD");
    let pos_trx_return_id = generateId();
    let body = req.body;
    let _check = await getCashier({
      created_by: body.created_by,
      is_cashier_open: true,
    });
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Please open cashier first!`);
    }
    var require_data = ["pos_trx_sale_id", "return_item"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    body.pos_trx_return_id = pos_trx_return_id;
    if (!Array.isArray(body.return_item) || !body.return_item.length) {
      throw new Error(`Return Item must be in Array`);
    }
    for (const it of body.return_item) {
      if (!it.qty || (!it.mst_item_variant_id && !it.barcode)) {
        throw new Error(`Quantity or Item Variant is not valid`);
      }
    }
    let _getSale = await getSale({ pos_trx_sale_id: body.pos_trx_sale_id });
    if (_getSale.error || _getSale.data.length == 0) {
      throw new Error(`Sale not found!`);
    }
    _getSale = _getSale.data[0];
    _getSale.created_date = moment(_getSale.created_date).format("YYYY-MM-DD");
    let config = await getPosConfig();

    let allow_return_day = moment(today)
      .add(config.allow_return_day, "day")
      .format("YYYY-MM-DD");
    let diff = diffDate(_getSale.created_date, allow_return_day);
    if (diff < 0) {
      throw new Error(
        `Cannot return this sale: date(${_getSale.created_date})!`
      );
    }
    if (!_getSale.is_paid) {
      throw new Error(`Please complete the payment!`);
    }
    if (_getSale.status == "0" || _getSale.flag_delete == "1") {
      throw new Error(`Sale not found!`);
    }

    let header = { ..._getSale, ...body };
    let detail = [];
    for (const it of body.return_item) {
      let _getDetail = await getTrxDetailItem({
        pos_trx_ref_id: body.pos_trx_sale_id,
        mst_item_variant_id: it.mst_item_variant_id,
        barcode: it.barcode,
      });
      if (_getDetail.error || _getDetail.data.length == 0) {
        throw new Error(`Sale Item not found!`);
      }
      _getDetail = _getDetail.data[0];
      if (_getSale.status == "0" || _getSale.flag_delete == "1") {
        throw new Error(`Sale item is not active!`);
      }
      if (it.qty > _getDetail.qty) {
        throw new Error(`Qty is not valid!`);
      }
      let param = { ..._getDetail, ...it };
      param.pos_trx_ref_id = pos_trx_return_id;
      detail.push(param);
    }

    let _calculate = await calculateSale({
      header: header,
      detail: detail,
      type: "return",
    });

    let _insertHeader = await models.insert_query({
      data: _calculate,
      table: "pos_trx_return",
      onlyQuery: true,
    });
    let _insertDetail = "";
    for (const it of _calculate.return_item) {
      _insertDetail += await models.generate_query_insert({
        values: it,
        table: "pos_trx_detail",
        onlyQuery: true,
      });
    }
    console.log(_insertHeader);
    console.log(_insertDetail);
    return;

    let _cust = await getCustomer({ mst_customer_id: mst_customer_id });
    if (_cust.error || _cust.data.length == 0) {
      throw new Error(`Customer not found`);
    }
    _cust = _cust.data[0];
    let up_price = _cust.price_percentage;

    body.mst_customer_id = mst_customer_id;
    body.price_percentage = up_price;
    body.ppn = _cust.mst_customer_ppn;
    body.is_paid = false;
    body.total_price = 0;
    body.total_discount = 0;
    body.grand_total = 0;
    // let _calculate = await calculateSale({
    //   header: body,
    //   detail: body.return_item,
    // });

    let _sale = await models.generate_query_insert({
      table: "pos_trx_return",
      values: _calculate,
    });
    let _saleDetail = "";

    for (const it of _calculate.return_item) {
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

exports.updateReturn = async function (req, res) {
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
    var require_data = ["qty", "mst_item_variant_id", "pos_trx_return_id"];
    for (const row of require_data) {
      if (!body[`${row}`] && !isInt(body[`${row}`])) {
        throw new Error(`${row} is required!`);
      }
    }
    let _sale = await getSale(body);
    let _saleDetail = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_return_id,
    });
    let isExist = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_return_id,
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
      table: "pos_trx_return",
      key: "pos_trx_return_id",
    });
    let _updateDetail = "";
    for (const it of _calculate.return_item) {
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

exports.deleteReturn = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let body = req.body;

    const require_data = ["pos_trx_return_id"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _detail = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_return_id,
    });
    let _header = await getSale({
      pos_trx_return_id: body.pos_trx_return_id,
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
      pos_trx_return_id: body.pos_trx_return_id,
      pos_trx_ref_id: body.pos_trx_return_id,
    };
    var _delHeader = await models.generate_query_update({
      values: param,
      table: "pos_trx_return",
      key: "pos_trx_return_id",
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
