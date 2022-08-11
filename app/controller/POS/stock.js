"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getStockItem } = require("./get_data");
const { getVariantItem } = require("../get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    // LINE WAJIB DIBAWA

    const require_data = [];
    for (const row of require_data) {
      if (!req.query[`${row}`]) {
        data.error = true;
        data.message = `${row} is required!`;
        return response.response(data, res);
      }
    }
    // LINE WAJIB DIBAWA

    let check = await getStockItem(req.query);

    if (check.data.length == 1 && req.query.pos_item_stock_id) {
      let it = check.data[0];
      let _variant = await getVariantItem({ mst_item_id: it.mst_item_id });
      console.log(_variant);
      // _variant = await models.exec_query(_variant);
      check.data[0].variant = _variant.data;
    }
    return response.response(check, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
