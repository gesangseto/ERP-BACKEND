"use strict";
const response = require("../../response");
const models = require("../../models");
const { generateId, diffDate } = require("../../utils");
const {
  getTrxDetailItem,
  getCashier,
  getSale,
  getPosConfig,
  getReturn,
  proccessToInbound,
  proccessToStock,
} = require("./get_data");
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
        throw new Error(`Please open cashier first!`);
      }
    }
    // LINE WAJIB DIBAWA
    let check = await getReturn(req.query);
    if (check.data.length == 1 && req.query.pos_trx_return_id) {
      let it = check.data[0];
      it.pos_trx_ref_id = req.query.pos_trx_return_id;
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
    let today = moment().format("YYYY-MM-DD");
    let body = req.body;
    body.pos_trx_return_id = generateId();
    body.status = 0;
    let _check = await getCashier({
      created_by: body.created_by,
      is_cashier_open: true,
    });
    if (_check.error || _check.data.length == 0) {
      throw new Error(`Please open cashier first!`);
    }
    var require_data = ["pos_trx_sale_id"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }

    let config = await getPosConfig();
    let return_day = moment(today)
      .add(config.allow_return_day, "day")
      .format("YYYY-MM-DD");
    let filter = {
      pos_trx_sale_id: body.pos_trx_sale_id,
    };
    let _getSale = await getSale({ ...filter });
    if (!_getSale.total) {
      throw new Error(`Sale not found!`);
    }
    _getSale = _getSale.data[0];
    _getSale.created_at = moment(_getSale.created_at).format("YYYY-MM-DD");
    let diff = diffDate(_getSale.created_at, return_day);
    if (diff < 0) {
      throw new Error(`Cannot return this sale: date(${_getSale.created_at})!`);
    } else if (!_getSale.is_paid) {
      throw new Error(`Please complete the payment!`);
    } else if (_getSale.status == "0" || _getSale.flag_delete == "1") {
      throw new Error(`Sale not found!`);
    }

    let _getRet = await getReturn({ ...filter, status: 0 });
    let _getRetAct = await getReturn({ ...filter, status: 1 });

    if (_getRet.total > 0 || _getRetAct > 0) {
      throw new Error(`Data is already returned!`);
    }

    let _getSaleDetail = await getTrxDetailItem({
      pos_trx_ref_id: body.pos_trx_sale_id,
    });
    if (!_getSaleDetail.total) {
      throw new Error(`Sale Detail not found!`);
    }
    _getSale = { ..._getSale, ...body };
    delete _getSale.updated_by;
    delete _getSale.updated_at;

    let _insertHeader = await models.insert_query({
      data: _getSale,
      table: "pos_trx_return",
      onlyQuery: true,
    });
    let _insertDetail = "";
    for (const it of _getSaleDetail.data) {
      delete it.updated_by;
      delete it.updated_at;
      delete it.pos_trx_detail_id;
      it.pos_trx_ref_id = body.pos_trx_return_id;
      _insertDetail += await models.generate_query_insert({
        values: it,
        table: "pos_trx_detail",
      });
    }
    _getSale.detail = _getSaleDetail.data;
    let _res = await models.exec_query(`${_insertHeader}${_insertDetail}`);
    _res.data = [_getSale];
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.approveReturn = async function (req, res) {
  var data = { data: req.body };
  try {
    perf.start();
    let body = req.body;
    var require_data = ["pos_trx_return_id", "is_approve"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${row} is required!`);
      }
    }
    let _returnHeader = await getReturn({
      pos_trx_return_id: body.pos_trx_return_id,
    });
    if (_returnHeader.error || _returnHeader.data.length == 0) {
      throw new Error(`Return data is not found!`);
    }
    _returnHeader = _returnHeader.data[0];
    if (_returnHeader.is_returned != null) {
      throw new Error(`Return data is already proccess!`);
    }

    body.status = body.is_approve == "true" ? 1 : 0;
    body.is_returned = req.body.is_approve;
    _returnHeader = { ..._returnHeader, ...body };
    let _updatetHeader = await models.update_query({
      data: _returnHeader,
      table: "pos_trx_return",
      key: "pos_trx_return_id",
      onlyQuery: true,
    });
    let _allQuery = _updatetHeader;
    if (body.is_approve == "true") {
      _allQuery += await proccessToInbound(_returnHeader);
      _allQuery += await proccessToStock(body);
      // let param = {
      //   pos_trx_sale_id: _returnHeader.pos_trx_sale_id,
      //   status: 0,
      //   flag_delete: 1,
      // };
      // _allQuery += await models.generate_query_update({
      //   values: param,
      //   table: "pos_trx_sale",
      //   key: "pos_trx_sale_id",
      // });
    }
    let _res = await models.exec_query(`${_allQuery}`);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
