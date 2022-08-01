"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getInbound, getDetailReceive, getReceive } = require("./get_data");

exports.getInbound = async function (req, res) {
  var data = { data: req.query };
  try {
    const check = await getInbound(req.query);
    const newData = [];
    for (const it of check.data) {
      let child = {};
      let _data = {};
      if (it.pos_ref_table === "pos_receive") {
        child = await getReceive({ pos_receive_id: it.pos_ref_id });
        _data = { ...child.data[0], ...it };
        if (req.query.hasOwnProperty("pos_trx_inbound_id")) {
          child = await getDetailReceive({ pos_receive_id: it.pos_ref_id });
          _data = { ..._data, detail: child.data };
        }
      }
      newData.push(_data);
    }
    check.data = newData;
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
