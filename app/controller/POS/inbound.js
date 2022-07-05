"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const {
  getItem,
  proccessToInbound,
  proccessToStock,
} = require("./generate_item");
const perf = require("execution-time")();

exports.getInbound = async function (req, res) {
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
    SELECT 
    a.*,
    b.mst_supplier_name,
    c.mst_customer_name
    --b.mst_warehouse_name
    FROM pos_trx_inbound AS a 
    LEFT JOIN mst_supplier AS b ON b.mst_supplier_id = a.mst_supplier_id
    LEFT JOIN mst_customer AS c ON c.mst_customer_id = a.mst_customer_id
    --LEFT JOIN mst_warehouse AS d ON d.mst_warehouse_id = a.mst_warehouse_id
    WHERE a.flag_delete='0' `;
    $query = await models.filter_query($query, req.query);
    console.log($query);
    const check = await models.get_query($query);
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
