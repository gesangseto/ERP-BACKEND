"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const {
  getInbound,
  getDetailReceive,
  getTrxDetailItem,
  getPosUserBranchCode,
} = require("./get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    const check = await getInbound(req.query);
    const newData = [];
    for (const it of check.data) {
      let child = {};
      let _data = { ...it };
      if (
        it.pos_ref_table === "pos_receive" &&
        req.query.hasOwnProperty("pos_trx_inbound_id")
      ) {
        child = await getDetailReceive({ pos_receive_id: it.pos_ref_id });
        _data.detail = child.data;
      } else if (
        it.pos_ref_table === "pos_trx_return" &&
        req.query.hasOwnProperty("pos_trx_inbound_id")
      ) {
        child = await getTrxDetailItem({
          pos_trx_ref_id: it.pos_ref_id,
        });
        _data.detail = child.data;
      }
      newData.push(_data);
    }
    check.data = newData;
    return response.response(check, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.getByUser = async function (req, res) {
  var data = { data: req.query };
  try {
    let user_id = req.headers.user_id;
    let branch = await getPosUserBranchCode({ user_id: user_id });
    let check = await getInbound({ ...req.query, pos_branch_code: branch });
    const newData = [];
    for (const it of check.data) {
      let child = {};
      let _data = { ...it };
      if (
        it.pos_ref_table === "pos_receive" &&
        req.query.hasOwnProperty("pos_trx_inbound_id")
      ) {
        child = await getDetailReceive({ pos_receive_id: it.pos_ref_id });
        _data.detail = child.data;
      } else if (
        it.pos_ref_table === "pos_trx_return" &&
        req.query.hasOwnProperty("pos_trx_inbound_id")
      ) {
        child = await getTrxDetailItem({
          pos_trx_ref_id: it.pos_ref_id,
        });
        _data.detail = child.data;
      }
      newData.push(_data);
    }
    check.data = newData;
    return response.response(check, res, false);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
