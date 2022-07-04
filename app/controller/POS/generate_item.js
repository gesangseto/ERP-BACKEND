const {
  exec_query,
  generate_query_insert,
  generate_query_update,
  generateId,
} = require("../../models");
const moment = require("moment");
const utils = require("../../utils");

async function getItem(data = Object) {
  let _sql = `SELECT * 
      FROM mst_item AS a
      LEFT JOIN mst_item_variant AS b ON a.mst_item_id = b.mst_item_id
      WHERE 1+1=2 `;
  if (data.hasOwnProperty("mst_item_id")) {
    _sql += ` AND a.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id")) {
    _sql += ` AND b.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  if (data.hasOwnProperty("barcode")) {
    _sql += ` AND b.barcode = '${data.barcode}'`;
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function getCashier(data = Object) {
  let _sql = `SELECT 
      *,
      a.status AS status,
      a.created_at AS created_at,
      a.created_by AS created_by,
      a.updated_at AS updated_at,
      a.updated_by AS updated_by
      FROM pos_cashier AS a
      LEFT JOIN "user" AS b ON a.created_by = b.user_id
      WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("pos_cashier_id")) {
    _sql += ` AND a.pos_cashier_id = '${data.pos_cashier_id}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND b.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("created_by")) {
    _sql += ` AND a.created_by = '${data.created_by}'`;
  }
  if (data.hasOwnProperty("is_cashier_open")) {
    _sql += ` AND a.is_cashier_open IS ${data.is_cashier_open}`;
  }
  console.log(_sql);
  let _data = await exec_query(_sql);
  return _data;
}

async function getSale(data = Object) {
  let _sql = `SELECT *,a.status AS status
      FROM pos_trx_sale AS a
      LEFT JOIN mst_customer AS b ON a.mst_customer_id = b.mst_customer_id
      WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("pos_trx_sale_id")) {
    _sql += ` AND a.pos_trx_sale_id = '${data.pos_trx_sale_id}'`;
  }
  if (data.hasOwnProperty("mst_customer_id")) {
    _sql += ` AND b.mst_customer_id = '${data.mst_customer_id}'`;
  }
  if (data.hasOwnProperty("is_paid")) {
    _sql += ` AND a.is_paid = '${data.is_paid}'`;
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function getSaleByCashier(data = Object) {
  let _data = await getCashier(data);
  let newData = [];
  for (const it of _data.data) {
    let _fr = "YYYY-MM-DD hh:mm:ss";
    let dt_start = moment(it.created_at).format(_fr);
    let dt_end = moment(it.updated_at).format(_fr);
    let _get_sale = `SELECT *,a.status AS status
    FROM pos_trx_sale AS a
    LEFT JOIN mst_customer AS b ON a.mst_customer_id = b.mst_customer_id
    WHERE a.created_at >= '${dt_start}'`;
    if (dt_end != "Invalid date") {
      _get_sale += ` AND a.created_at <= '${dt_end}'`;
    }
    if (data.hasOwnProperty("is_paid")) {
      _get_sale += ` AND a.is_paid IS ${data.is_paid}`;
    }
    _get_sale = await exec_query(_get_sale);
    let _sale = [];
    for (const ch of _get_sale.data) {
      let child = await getTrxDetailItem(ch);
      ch.detail = child.data;
      _sale.push(ch);
    }
    it.sale = _sale;
    newData.push(it);
  }
  _data.data = newData;
  return _data;
}

async function getStockItem(data = Object) {
  let _sql = `SELECT * 
    FROM pos_item_stock AS a  
    LEFT JOIN mst_item AS b ON a.mst_item_id= b.mst_item_id
    LEFT JOIN mst_item_variant AS c ON b.mst_item_id = c.mst_item_id
    WHERE 1+1=2 `;
  if (data.hasOwnProperty("mst_item_id")) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id")) {
    _sql += ` AND c.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  if (data.hasOwnProperty("barcode")) {
    _sql += ` AND c.barcode = '${data.barcode}'`;
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function proccessToInbound(data) {
  let _data = { ...data };
  _data.pos_trx_inbound_id = utils.generateId();
  _data.pos_trx_id = _data.pos_trx_inbound_id;
  if (data.hasOwnProperty("mst_supplier_id")) {
    _data.mst_supplier_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "direct";
  } else if (data.hasOwnProperty("mst_customer_id")) {
    _data.mst_customer_id = data.mst_customer_id;
    _data.pos_trx_inbound_type = "return";
  } else if (data.hasOwnProperty("mst_warehouse_id")) {
    _data.mst_warehouse_id = data.mst_warehouse_id;
    _data.pos_trx_inbound_type = "warehouse";
  }

  if (data.hasOwnProperty("pos_batch_id")) {
    _data.pos_ref_id = data.pos_batch_id;
    _data.pos_ref_table = "pos_batch";
  } else if (data.hasOwnProperty("pos_trx_return_id")) {
    _data.pos_ref_id = data.pos_trx_return_id;
    _data.pos_ref_table = "pos_trx_return";
  }

  let _insert = await generate_query_insert({
    table: "pos_trx_inbound",
    values: _data,
  });
  console.log(_data, "===========");
  return _insert;
}

async function proccessToStock(data) {
  let _data = { ...data };
  _data.pos_trx_inbound_id = utils.generateId();
  _data.pos_trx_id = _data.pos_trx_inbound_id;
  if (data.hasOwnProperty("mst_supplier_id")) {
    _data.mst_supplier_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "direct";
  } else if (data.hasOwnProperty("mst_customer_id")) {
    _data.mst_customer_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "return";
  } else if (data.hasOwnProperty("mst_warehouse_id")) {
    _data.mst_warehouse_id = data.mst_warehouse_id;
    _data.pos_trx_inbound_type = "warehouse";
  }
  let _current_stock = `SELECT * FROM pos_item_stock WHERE mst_item_id='${_data.mst_item_id}' LIMIT 1;`;
  _current_stock = await exec_query(_current_stock);
  let _update_stock = "";
  if (_current_stock.data.length == 0) {
    _update_stock = await generate_query_insert({
      table: "pos_item_stock",
      values: _data,
    });
  } else {
    _current_stock = _current_stock.data[0];
    _current_stock.qty = parseInt(_data.qty) + parseInt(_current_stock.qty);
    _update_stock = await generate_query_update({
      table: "pos_item_stock",
      values: _current_stock,
      key: "pos_item_stock_id",
    });
  }
  return _update_stock;
}

async function getTrxDetailItem(data = Object) {
  let _sql = `SELECT * FROM pos_trx_detail AS a
    WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_trx_ref_id")) {
    _sql += ` AND a.pos_trx_ref_id = '${data.pos_trx_ref_id}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id")) {
    _sql += ` AND a.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  let _data = await exec_query(_sql);
  return _data;
}

module.exports = {
  getItem,
  getStockItem,
  proccessToInbound,
  proccessToStock,
  getTrxDetailItem,
  getCashier,
  getSale,
  getSaleByCashier,
};
