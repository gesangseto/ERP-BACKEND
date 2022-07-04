const {
  exec_query,
  generate_query_insert,
  generate_query_update,
  generateId,
} = require("../../models");
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
    _data.mst_customer_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "return";
  } else if (data.hasOwnProperty("mst_warehouse_id")) {
    _data.mst_warehouse_id = data.mst_warehouse_id;
    _data.pos_trx_inbound_type = "warehouse";
  }

  if (data.hasOwnProperty("pos_batch_id")) {
    _data.pos_ref_id = data.pos_batch_id;
    _data.pos_ref_table = "pos_batch";
  }

  let _insert = await generate_query_insert({
    table: "pos_trx_inbound",
    values: _data,
  });
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
    _sql += ` AND a.pos_trx_ref_id = '${data.mst_item_id}'`;
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
};
