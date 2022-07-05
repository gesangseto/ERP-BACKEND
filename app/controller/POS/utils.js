"use strict";
const response = require("../../response");
const models = require("../../models");
const { percentToFloat } = require("../../utils");
const { getStockItem } = require("./generate_item");
const perf = require("execution-time")();

exports.cleanup = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let _query = `
    TRUNCATE pos_item_stock;
    TRUNCATE pos_trx_inbound;
    TRUNCATE pos_trx_detail;
    TRUNCATE pos_receive;
    TRUNCATE pos_receive_detail;
    TRUNCATE pos_trx_sale;
    TRUNCATE pos_cashier;
    `;
    let _res = await models.exec_query(_query);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
