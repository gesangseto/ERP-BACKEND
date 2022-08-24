"use strict";
const response = require("../../response");
const models = require("../../models");
const utils = require("../../utils");
const { getStockItem, getPosUserBranchCode } = require("./get_data");
const { getVariantItem } = require("../get_data");

exports.get = async function (req, res) {
  var data = { data: req.query };
  try {
    let check = await getStockItem(req.query);

    if (check.data.length == 1 && req.query.pos_item_stock_id) {
      let it = check.data[0];
      let _variant = await getVariantItem({ mst_item_id: it.mst_item_id });
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

exports.getByUser = async function (req, res) {
  var data = { data: req.query };
  try {
    let user_id = req.headers.user_id;
    let branch = await getPosUserBranchCode({ user_id: user_id });
    let check = await getStockItem({ ...req.query, pos_branch_code: branch });

    // let check = await getStockItem(req.query);

    if (check.data.length == 1 && req.query.pos_item_stock_id) {
      let it = check.data[0];
      let _variant = await getVariantItem({ mst_item_id: it.mst_item_id });
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
