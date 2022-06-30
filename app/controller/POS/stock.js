"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
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
    var $query = `
    SELECT *
    FROM pos_item_stock AS a 
    LEFT JOIN mst_item AS b ON a.mst_item_id = b.mst_item_id
    WHERE a.flag_delete='0' `;
    $query = await models.filter_query($query, req.query);
    const check = await models.get_query($query);
    if (check.data.length == 1 && req.query.pos_item_stock_id) {
      let it = check.data[0];
      let _variant = `SELECT * FROM mst_item_variant WHERE mst_item_id='${it.mst_item_id}';`;
      _variant = await models.exec_query(_variant);
      check.data[0].variant = _variant.data;
    }
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
