"use strict";
const response = require("../../response");
const models = require("../../models");
const { percentToFloat, generateId } = require("../../utils");
const {
  getStockItem,
  getTrxDetailItem,
  getCashier,
  getSaleByCashier,
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
    let check = await getCashier(req.query);
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.openCashier = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let pos_trx_sale_id = generateId();
    req.body.created_by = req.headers.user_id;

    var require_data = ["pos_cashier_capital_cash", "pos_cashier_shift"];
    for (const row of require_data) {
      if (!req.body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    let body = req.body;
    let _check = await models.exec_query(
      `SELECT * FROM pos_cashier WHERE created_by ='${req.body.created_by}' AND is_cashier_open IS TRUE`
    );
    if (_check.data.length > 0) {
      data.error = true;
      data.message = `Cashier is already open at ${_check.data[0].created_at}`;
      return response.response(data, res);
    }
    let _res = await models.insert_query({ data: body, table: "pos_cashier" });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.closeCashier = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    var require_data = ["pos_cashier_id"];
    let body = req.body;
    for (const row of require_data) {
      if (!body[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }

    let _check = await models.exec_query(
      `SELECT * FROM pos_cashier WHERE pos_cashier_id ='${body.pos_cashier_id}' LIMIT 1`
    );

    if (_check.error || _check.data.length == 0) {
      data.error = true;
      data.message = `Cashier not found`;
      return response.response(data, res);
    } else {
      _check = _check.data[0];
      if (_check.created_by != body.updated_by) {
        data.error = true;
        data.message = `Cashier did not match`;
        return response.response(data, res);
      } else if (!_check.is_cashier_open) {
        data.error = true;
        data.message = `Cashier is already closed!`;
        return response.response(data, res);
      }
    }

    let param = {
      pos_cashier_id: _check.pos_cashier_id,
      is_paid: false,
    };
    let saleCashier = await getSaleByCashier(param);
    if (saleCashier.error || saleCashier.data.length > 0) {
      for (const it of saleCashier.data) {
        for (const sale of it.sale) {
          if (!sale.is_paid) {
            data.error = true;
            data.message = `Please finish transaction Sale Id(${sale.pos_trx_sale_id})`;
            return response.response(data, res);
          }
        }
      }
    }

    body.is_cashier_open = false;
    let _res = await models.update_query({
      data: body,
      key: "pos_cashier_id",
      table: "pos_cashier",
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
