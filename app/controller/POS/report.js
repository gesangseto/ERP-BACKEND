"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getReportSale, getReportCashierSale } = require("./get_data");

exports.reportSale = async function (req, res) {
  var data = { data: req.query };
  try {
    let check = await getReportSale(req.query);
    return response.response(check, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.reportCashierSale = async function (req, res) {
  var data = { data: req.query };
  try {
    let check = await getReportCashierSale(req.query);

    if (req.query.hasOwnProperty("pos_cashier_id")) {
      let newData = [];
      for (const it of check.data) {
        let sql = `SELECT * 
        FROM pos_trx_sale AS a 
        LEFT JOIN pos_cashier AS b 
          ON a.created_by = b.created_by 
          AND a.created_at >=b.created_at AND (CASE WHEN b.updated_at is not null THEN a.created_at <= b.updated_at ELSE TRUE END)
        WHERE b.pos_cashier_id = '${req.query.pos_cashier_id}'  ;`;
        sql = await models.exec_query(sql);
        it.detail = sql.data;
        newData.push(it);
      }
      check.data = newData;
    }
    return response.response(check, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
