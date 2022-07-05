const {
  exec_query,
  generate_query_insert,
  generate_query_update,
} = require("../../models");
const moment = require("moment");
const { sumByKey, generateId } = require("../../utils");

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
  _data.pos_trx_inbound_id = generateId();
  _data.pos_trx_id = _data.pos_trx_inbound_id;
  if (data.hasOwnProperty("mst_supplier_id")) {
    _data.mst_supplier_id = data.mst_supplier_id;
    _data.pos_trx_inbound_type = "receive";
    _data.pos_ref_table = "pos_receive";
    _data.pos_ref_id = _data.pos_receive_id;
  } else if (data.hasOwnProperty("mst_customer_id")) {
    _data.mst_customer_id = data.mst_customer_id;
    _data.pos_trx_inbound_type = "return";
  } else if (data.hasOwnProperty("mst_warehouse_id")) {
    _data.mst_warehouse_id = data.mst_warehouse_id;
    _data.pos_trx_inbound_type = "warehouse";
  }

  let _insert = await generate_query_insert({
    table: "pos_trx_inbound",
    values: _data,
  });
  return _insert;
}

async function proccessToStock(data) {
  let _datas = {};
  if (data.hasOwnProperty("pos_receive_id")) {
    _datas = await getDetailReceive({ pos_receive_id: data.pos_receive_id });
  }

  let reduce = sumByKey({
    key: "mst_item_id",
    array: _datas.data,
    sum: "qty",
  });

  let _sql = "";
  for (const it of reduce) {
    let _item = await getStockItem(it);
    if (_item.data.length == 0) {
      _sql += await generate_query_insert({
        values: it,
        table: "pos_item_stock",
      });
    } else {
      let body = { ..._item.data[0], ...it };
      body.qty += _item.data[0].qty ?? 0;
      body.status = 1;
      _sql += await generate_query_update({
        values: body,
        table: "pos_item_stock",
        key: "pos_item_stock_id",
      });
    }
  }
  return _sql;
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

async function getReceive(data = Object, onlyQuery = false) {
  let _sql = `SELECT 
  MAX(a.pos_receive_id) as pos_receive_id,
  MAX(a.created_at) as created_at,
  MAX(a.created_by) as created_by,
  MAX(c.mst_item_id) as mst_item_id,
  MAX(c.mst_item_name) as mst_item_name,
  MAX(d.mst_supplier_id) as mst_supplier_id,
  MAX(d.mst_supplier_name) as mst_supplier_name,
  SUM(b.qty) as qty,
  MAX(a.status) as status,
  STRING_AGG(b.batch_no,',') AS batch
  FROM pos_receive AS a
  LEFT JOIN pos_receive_detail as b on a.pos_receive_id = b.pos_receive_id
  LEFT JOIN mst_item AS c ON b.mst_item_id = c.mst_item_id
  LEFT JOIN mst_supplier AS d ON a.mst_supplier_id = d.mst_supplier_id
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_receive_id")) {
    _sql += ` AND a.pos_receive_id = '${data.pos_receive_id}'`;
  }
  if (data.hasOwnProperty("batch_no")) {
    _sql += ` AND b.batch_no = '${data.batch_no}'`;
  }
  if (data.hasOwnProperty("mst_item_id")) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("barcode")) {
    _sql += ` AND c.barcode = '${data.barcode}'`;
  }
  _sql += ` GROUP BY a.pos_receive_id ;`;
  if (onlyQuery) {
    return _sql;
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function getDetailReceive(data = Object) {
  let _sql = `SELECT * 
  FROM pos_receive_detail AS a 
  LEFT JOIN mst_item AS b ON a.mst_item_id = b.mst_item_id
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_receive_id")) {
    _sql += ` AND a.pos_receive_id = '${data.pos_receive_id}'`;
  }
  if (data.hasOwnProperty("batch_no")) {
    _sql += ` AND a.batch_no = '${data.batch_no}'`;
  }
  if (data.hasOwnProperty("mst_item_id")) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  _sql += ` ORDER BY a.mst_item_id ASC`;
  let _data = await exec_query(_sql);
  return _data;
}

module.exports = {
  getReceive,
  getDetailReceive,
  getItem,
  getStockItem,
  proccessToInbound,
  proccessToStock,
  getTrxDetailItem,
  getCashier,
  getSale,
  getSaleByCashier,
};
