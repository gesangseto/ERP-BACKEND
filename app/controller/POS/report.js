"use strict";
const response = require("../../response");
const models = require("../../models");
const moment = require("moment-timezone");
const utils = require("../../utils");
const {
  getReportCashierSale,
  getPosUserBranchCode,
  getSale,
} = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    let check = await getReportCashierSale({
      ...req.query,
    });
    if (req.query.pos_cashier_id) {
      let newData = [];
      for (const it of check.data) {
        it.created_at = moment(it.created_at).format("YYYY-MM-DD hh:mm:ss");
        it.updated_at = moment(it.updated_at).format("YYYY-MM-DD hh:mm:ss");
        it.updated_at =
          it.updated_at === "Invalid date"
            ? moment(new Date()).format("YYYY-MM-DD hh:mm:ss")
            : it.updated_at;
        let sale = await getSale({
          between: [it.created_at, it.updated_at],
          created_by: it.user_id,
        });
        it.detail = sale.data;
        newData.push(it);
      }
      check.data = newData;
    }
    // console.log(check);
    return response.response(check, res, false);
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
    let check = await getReportCashierSale({
      ...req.query,
      pos_branch_code: branch,
    });

    if (req.query.pos_cashier_id) {
      console.log(req.query);
      let newData = [];
      for (const it of check.data) {
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
