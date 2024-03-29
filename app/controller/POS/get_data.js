const {
  exec_query,
  generate_query_insert,
  generate_query_update,
  get_query,
  getLimitOffset,
} = require("../../models");
const moment = require("moment");
const {
  sumByKey,
  generateId,
  isJsonString,
  isArray,
  isString,
} = require("../../utils");

async function getReceive(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_receive_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(e.user_name) LIKE LOWER('%${search}%')
  OR  LOWER(c.mst_item_name) LIKE LOWER('%${search}%')
  OR  LOWER(d.mst_supplier_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.batch_no) LIKE LOWER('%${search}%')
  OR  CAST(b.qty AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(b.qty_stock AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
  MAX(a.pos_receive_id) as pos_receive_id,
  MAX(a.pos_receive_note) as pos_receive_note,
  MAX(a.created_at) as created_at,
  MAX(a.created_by) as created_by,
  MAX(e.user_name) as user_name,
  MAX(c.mst_item_id) as mst_item_id,
  STRING_AGG(c.mst_item_name,',') AS mst_item_name,
  STRING_AGG(coalesce(b.mst_item_variant_qty::character varying,''), ';') AS mst_item_variant_qty,
  MAX(d.mst_supplier_id) as mst_supplier_id,
  MAX(d.mst_supplier_name) as mst_supplier_name,
  SUM(b.qty) as qty,
  SUM(b.qty_stock) as qty_stock,
  MAX(a.status) as status,
  STRING_AGG(b.batch_no,',') AS batch,
  BOOL_OR(a.is_received) AS is_received,
  MAX(a.pos_branch_code) as pos_branch_code
  FROM pos_receive AS a
  LEFT JOIN pos_receive_detail as b on a.pos_receive_id = b.pos_receive_id
  LEFT JOIN mst_item AS c ON b.mst_item_id = c.mst_item_id
  LEFT JOIN mst_supplier AS d ON a.mst_supplier_id = d.mst_supplier_id
  LEFT JOIN "user" AS e ON a.created_by = e.user_id
  WHERE 1+1=2 `;

  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }

  if (data.hasOwnProperty("pos_receive_id")) {
    _sql += ` AND a.pos_receive_id = '${data.pos_receive_id}'`;
  }
  if (data.hasOwnProperty("batch_no")) {
    _sql += ` AND b.batch_no = '${data.batch_no}'`;
  }
  if (data.hasOwnProperty("mst_item_id") && data.mst_item_id) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("barcode") && data.barcode) {
    _sql += ` AND c.barcode = '${data.barcode}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += ` GROUP BY a.pos_receive_id `;
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}
async function getReceiveByUser(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_receive_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(e.user_name) LIKE LOWER('%${search}%')
  OR  LOWER(c.mst_item_name) LIKE LOWER('%${search}%')
  OR  LOWER(d.mst_supplier_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.batch_no) LIKE LOWER('%${search}%')
  OR  CAST(b.qty AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(b.qty_stock AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(pub.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
  MAX(a.pos_receive_id) as pos_receive_id,
  MAX(a.pos_receive_note) as pos_receive_note,
  MAX(a.created_at) as created_at,
  MAX(a.created_by) as created_by,
  MAX(e.user_name) as user_name,
  MAX(c.mst_item_id) as mst_item_id,
  STRING_AGG(c.mst_item_name,',') AS mst_item_name,
  STRING_AGG(coalesce(b.mst_item_variant_qty::character varying,''), ';') AS mst_item_variant_qty,
  MAX(d.mst_supplier_id) as mst_supplier_id,
  MAX(d.mst_supplier_name) as mst_supplier_name,
  SUM(b.qty) as qty,
  SUM(b.qty_stock) as qty_stock,
  MAX(a.status) as status,
  STRING_AGG(b.batch_no,',') AS batch,
  BOOL_OR(a.is_received) AS is_received,
  MAX(pub.pos_branch_code) as pos_branch_code
  FROM pos_receive AS a
  LEFT JOIN pos_receive_detail as b on a.pos_receive_id = b.pos_receive_id
  LEFT JOIN mst_item AS c ON b.mst_item_id = c.mst_item_id
  LEFT JOIN mst_supplier AS d ON a.mst_supplier_id = d.mst_supplier_id
  LEFT JOIN "user" AS e ON a.created_by = e.user_id
  LEFT JOIN pos_user_branch AS pub ON pub.pos_branch_code = a.pos_branch_code
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_receive_id")) {
    _sql += ` AND a.pos_receive_id = '${data.pos_receive_id}'`;
  }
  if (data.hasOwnProperty("batch_no")) {
    _sql += ` AND b.batch_no = '${data.batch_no}'`;
  }
  if (data.hasOwnProperty("mst_item_id") && data.mst_item_id) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("barcode") && data.barcode) {
    _sql += ` AND c.barcode = '${data.barcode}'`;
  }
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += ` AND pub.pos_branch_code = '${data.pos_branch_code}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND pub.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += ` GROUP BY a.pos_receive_id `;
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}
async function getDestroy(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_trx_destroy_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(d.user_name) LIKE LOWER('%${search}%')
  OR  LOWER(c.mst_item_name) LIKE LOWER('%${search}%')
  OR  CAST(b.qty AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(b.qty_stock AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') )
   `;
  };
  let _sql = `
  SELECT 
  MAX(a.pos_trx_destroy_id) as pos_trx_destroy_id,
  MAX(a.pos_branch_code) as pos_branch_code,
  MAX(a.created_at) as created_at,
  MAX(a.created_by) as created_by,
  MAX(d.user_name) as user_name,
  MAX(c.mst_item_id) as mst_item_id,
  STRING_AGG(c.mst_item_name,',') AS mst_item_name,
  STRING_AGG(coalesce(b.mst_item_variant_qty::character varying,''), ';') AS mst_item_variant_qty,
  SUM(b.qty) as qty,
  SUM(b.qty_stock) as qty_stock,
  MAX(a.status) as status,
  BOOL_OR(a.is_destroyed) AS is_destroyed
  FROM pos_trx_destroy AS a
  LEFT JOIN pos_trx_detail as b on a.pos_trx_destroy_id = b.pos_trx_ref_id 
  LEFT JOIN mst_item AS c ON b.mst_item_id = c.mst_item_id
  LEFT JOIN "user" AS d ON a.created_by = d.user_id
  WHERE 1+1=2 `;
  // GET BRANCH CODE
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }
  if (data.hasOwnProperty("pos_trx_destroy_id")) {
    _sql += ` AND a.pos_trx_destroy_id = '${data.pos_trx_destroy_id}'`;
  }
  if (data.hasOwnProperty("mst_item_id") && data.mst_item_id) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += ` GROUP BY a.pos_trx_destroy_id `;
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getDetailReceive(data = Object) {
  let _sql = `SELECT * 
  FROM pos_receive_detail AS a 
  LEFT JOIN mst_item_variant AS b ON a.mst_item_variant_id = b.mst_item_variant_id
  LEFT JOIN mst_packaging AS c ON c.mst_packaging_id = b.mst_packaging_id
  LEFT JOIN mst_item AS d ON d.mst_item_id = b.mst_item_id
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
  if (data.hasOwnProperty("barcode")) {
    _sql += ` AND b.barcode = '${data.barcode}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id")) {
    _sql += ` AND b.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  _sql += ` ORDER BY a.mst_item_id ASC`;
  let _data = await exec_query(_sql);
  return _data;
}

async function getInbound(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_trx_inbound_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(c.mst_customer_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_supplier_name) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = ` 
  SELECT 
    *, a.created_at AS created_at
  FROM pos_trx_inbound AS a 
  LEFT JOIN mst_supplier AS b ON b.mst_supplier_id = a.mst_supplier_id
  LEFT JOIN mst_customer AS c ON c.mst_customer_id = a.mst_customer_id
  WHERE 1+1=2 `;

  // GET BRANCH CODE
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }

  if (data.hasOwnProperty("pos_trx_inbound_id")) {
    _sql += ` AND a.pos_trx_inbound_id = '${data.pos_trx_inbound_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}
async function getInboundByUser(data = Object, onlyQuery = false) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_trx_inbound_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(c.mst_customer_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_supplier_name) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = ` 
  SELECT 
    *, a.created_at AS created_at
  FROM pos_trx_inbound AS a 
  LEFT JOIN mst_supplier AS b ON b.mst_supplier_id = a.mst_supplier_id
  LEFT JOIN mst_customer AS c ON c.mst_customer_id = a.mst_customer_id
  LEFT JOIN pos_user_branch AS pub ON pub.pos_branch_code = a.pos_branch_code
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_trx_inbound_id")) {
    _sql += ` AND a.pos_trx_inbound_id = '${data.pos_trx_inbound_id}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND pub.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  if (onlyQuery) {
    return _sql;
  }
  let _data = await get_query(_sql);
  return _data;
}

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
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_trx_sale_id AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_customer_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_customer_phone) LIKE LOWER('%${search}%') 
  OR  LOWER(b.mst_customer_email) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
  *,
  a.status AS status,
  a.flag_delete AS flag_delete,
  a.created_at AS created_at,
  a.created_by AS created_by
      FROM pos_trx_sale AS a
      LEFT JOIN mst_customer AS b ON a.mst_customer_id = b.mst_customer_id
      WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("pos_trx_sale_id")) {
    _sql += ` AND a.pos_trx_sale_id = '${data.pos_trx_sale_id}'`;
  }
  if (data.hasOwnProperty("created_by")) {
    _sql += ` AND a.created_by = '${data.created_by}'`;
  }
  if (data.hasOwnProperty("mst_customer_id")) {
    _sql += ` AND b.mst_customer_id = '${data.mst_customer_id}'`;
  }
  if (data.hasOwnProperty("is_paid")) {
    _sql += ` AND a.is_paid = '${data.is_paid}'`;
  }
  if (data.hasOwnProperty("between")) {
    if (isArray(data.between) && data.between.length === 2) {
      _sql += ` AND a.created_at BETWEEN '${data.between[0]}'::timestamp AND  '${data.between[1]}'::timestamp`;
    }
  }
  // GET BRANCH CODE
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }

  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getReportSale(data = Object) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_trx_sale_id AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_customer_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_customer_phone) LIKE LOWER('%${search}%') 
  OR  LOWER(b.mst_customer_email) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
  *,
  a.status AS status,
  a.flag_delete AS flag_delete,
  a.created_at AS created_at,
  a.created_by AS created_by
      FROM pos_trx_sale AS a
      LEFT JOIN mst_customer AS b ON a.mst_customer_id = b.mst_customer_id
      left join pos_cashier as c on a.created_by = c.created_by and a.created_at >= c.created_at  and a.created_at <= c.updated_at 
      left join "user" as d on a.created_by = d.user_id 
      WHERE a.flag_delete='0'  `;
  if (data.hasOwnProperty("pos_trx_sale_id")) {
    _sql += ` AND a.pos_trx_sale_id = '${data.pos_trx_sale_id}'`;
  }
  if (data.hasOwnProperty("mst_customer_id")) {
    _sql += ` AND b.mst_customer_id = '${data.mst_customer_id}'`;
  }
  if (data.hasOwnProperty("pos_cashier_id")) {
    _sql += ` AND c.pos_cashier_id = '${data.pos_cashier_id}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND d.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("is_paid")) {
    _sql += ` AND a.is_paid = '${data.is_paid}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  let _data = await get_query(_sql);
  return _data;
}
async function getReportCashierSale(data = Object) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_cashier_id AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(b.user_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.user_email) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
  MAX(a.pos_cashier_id) AS pos_cashier_id,
  MAX(a.pos_branch_code) AS pos_branch_code,
  MAX(a.pos_cashier_shift) AS pos_cashier_shift,
  MAX(a.pos_cashier_capital_cash) AS pos_cashier_capital_cash,
  BOOL_OR(a.is_cashier_open) AS is_cashier_open,
  MAX(a.pos_cashier_number) AS pos_cashier_number,
  MAX(a.created_at) AS created_at,
  MAX(a.updated_at) AS updated_at,
  MAX(b.user_id) AS user_id,
  MAX(b.user_name) AS user_name,
  MAX(b.user_email) AS user_email,
  SUM(c.total_price) AS total_price,
  SUM(c.grand_total) AS grand_total,
  SUM(d.qty) AS total_qty
FROM pos_cashier AS a
LEFT JOIN "user" AS b ON a.created_by = b.user_id
LEFT JOIN pos_trx_sale as c on a.created_by = c.created_by 
  AND c.created_at >=a.created_at AND (CASE WHEN a.updated_at is not null THEN c.created_at <= a.updated_at ELSE 1+1=2 END)
LEFT JOIN pos_trx_detail AS d ON c.pos_trx_sale_id = d.pos_trx_ref_id 
WHERE a.flag_delete='0'  `;

  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }
  if (data.hasOwnProperty("pos_cashier_id")) {
    _sql += ` AND a.pos_cashier_id = '${data.pos_cashier_id}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND b.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += ` GROUP BY a.pos_cashier_id `;
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  let _data = await get_query(_sql);
  return _data;
}
async function getReturn(data = Object) {
  let _sql = `SELECT 
  *,
  a.status AS status,
  a.flag_delete AS flag_delete,
  a.created_at AS created_at,
  a.created_by AS created_by
      FROM pos_trx_return AS a
      LEFT JOIN mst_customer AS b ON a.mst_customer_id = b.mst_customer_id
      LEFT JOIN "user" AS usr ON usr.user_id = a.created_by
      WHERE a.flag_delete='0' `;
  if (data.hasOwnProperty("pos_trx_return_id")) {
    _sql += ` AND a.pos_trx_return_id = '${data.pos_trx_return_id}'`;
  }
  if (data.hasOwnProperty("pos_trx_sale_id")) {
    _sql += ` AND a.pos_trx_sale_id = '${data.pos_trx_sale_id}'`;
  }
  if (data.hasOwnProperty("mst_customer_id")) {
    _sql += ` AND b.mst_customer_id = '${data.mst_customer_id}'`;
  }
  if (data.hasOwnProperty("is_returned")) {
    _sql += ` AND a.is_returned = '${data.is_returned}'`;
  }
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function getCustomer(data = Object) {
  let _sql = `SELECT * FROM mst_customer AS a WHERE a.flag_delete = '0' `;
  if (data.hasOwnProperty("mst_customer_id")) {
    _sql += ` AND a.mst_customer_id = '${data.mst_customer_id}'`;
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function getDiscount(data = Object) {
  const genSearch = (search) => {
    return ` 
  AND (LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(b.mst_item_variant_name) LIKE LOWER('%${search}%')
  OR  LOWER(c.mst_item_name) LIKE LOWER('%${search}%')
  OR  LOWER(b.barcode) LIKE LOWER('%${search}%')  
  OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT 
    MAX(a.pos_discount_id) as pos_discount_id ,
    MAX(a.mst_item_variant_id) as mst_item_variant_id ,
    MAX(a.discount) as discount ,
    MAX(a.pos_discount_starttime) as pos_discount_starttime ,
    MAX(a.pos_discount_endtime) as pos_discount_endtime ,
    MAX(a.discount_min_qty) as discount_min_qty ,
    MAX(a.discount_max_qty) as discount_max_qty ,
    MAX(a.discount_free_qty) as discount_free_qty ,
    MAX(a.status) as status ,
    MAX(a.flag_delete) as flag_delete,
    MAX(b.mst_item_variant_name) as mst_item_variant_name,
    MAX(b.barcode) as barcode,
    MAX(c.mst_item_name) as mst_item_name,
    MAX(a.pos_branch_code) as pos_branch_code
  FROM pos_discount AS a 
  LEFT JOIN mst_item_variant AS b ON a.mst_item_variant_id = b.mst_item_variant_id
  LEFT JOIN mst_item AS c ON b.mst_item_id = c.mst_item_id
  WHERE a.flag_delete='0' `;
  // GET BRANCH CODE
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }

  if (data.hasOwnProperty("pos_discount_id")) {
    _sql += ` AND a.pos_discount_id = '${data.pos_discount_id}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id")) {
    _sql += ` AND b.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  if (data.hasOwnProperty("barcode")) {
    _sql += ` AND b.barcode = '${data.barcode}'`;
  }
  if (data.hasOwnProperty("mst_item_id")) {
    _sql += ` AND a.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += `GROUP BY a.pos_discount_id`;
  if (data.hasOwnProperty("page") && data.hasOwnProperty("limit")) {
    _sql += getLimitOffset(data.page, data.limit);
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getSaleByCashier(data = Object) {
  let _data = await getCashier(data);
  if (_data.error || _data.data.length == 0) {
    return _data;
  }
  let created_by = _data.data[0].created_by ?? 0;
  let newData = [];
  for (const it of _data.data) {
    let _fr = "YYYY-MM-DD hh:mm:ss";
    let dt_start = moment(it.created_at).format(_fr);
    let dt_end = moment(it.updated_at).format(_fr);
    let _get_sale = `SELECT *,a.status AS status
    FROM pos_trx_sale AS a
    LEFT JOIN mst_customer AS b ON a.mst_customer_id = b.mst_customer_id
    WHERE a.created_by='${created_by}' AND a.created_at >= '${dt_start}'`;
    if (dt_end != "Invalid date") {
      _get_sale += ` AND a.created_at <= '${dt_end}'`;
    }
    if (data.hasOwnProperty("is_paid")) {
      _get_sale += ` AND a.is_paid IS ${data.is_paid}`;
    }
    _get_sale = await exec_query(_get_sale);
    let _sale = [];
    for (const ch of _get_sale.data) {
      let child = await getTrxDetailItem({
        pos_trx_ref_id: ch.pos_trx_sale_id,
      });
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
  const genSearch = (search) => {
    return ` 
          AND (CAST(a.pos_item_stock_id AS TEXT) LIKE LOWER('%${search}%')
          OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
          OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
          OR  LOWER(b.mst_item_name) LIKE LOWER('%${search}%')
          OR  LOWER(b.mst_item_desc) LIKE LOWER('%${search}%')
          OR  LOWER(b.mst_item_no) LIKE LOWER('%${search}%')
          OR  LOWER(c.barcode) LIKE LOWER('%${search}%')
          OR  LOWER(c.mst_item_variant_name) LIKE LOWER('%${search}%')
          OR  CAST(a.qty AS TEXT) LIKE LOWER('%${search}%')
          OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT
        MAX(a.pos_item_stock_id) AS pos_item_stock_id,
        MAX(a.pos_branch_code) AS pos_branch_code,
        MAX(a.mst_item_id) AS mst_item_id,
        MAX(b.mst_item_name) AS mst_item_name,
        MAX(b.mst_item_desc) AS mst_item_desc,
        MAX(b.mst_item_no) AS mst_item_no,
        MAX(a.qty) AS qty,
        STRING_AGG(coalesce(c.mst_item_variant_id::character varying,''), ';') as mst_item_variant_id,
        STRING_AGG(coalesce(c.barcode::character varying,''), ';') as barcode,
        STRING_AGG(coalesce(c.mst_item_variant_name,''),';') AS mst_item_variant_name,
        STRING_AGG(coalesce(c.mst_item_variant_qty::character varying,''), ';') as mst_item_variant_qty,
        STRING_AGG(coalesce(pack.mst_packaging_name,''),';') AS mst_packaging_name,
        STRING_AGG(coalesce(pack.mst_packaging_code,''),';') AS mst_packaging_code,
        STRING_AGG(coalesce(d.pos_discount_id ::character varying,''), ';') as pos_discount_id,
        STRING_AGG(coalesce(d.discount::character varying,''), ';') as discount,
        STRING_AGG(coalesce(d.pos_discount_starttime ::character varying,''), ';') as pos_discount_starttime,
        STRING_AGG(coalesce(d.pos_discount_endtime  ::character varying,''), ';') as pos_discount_endtime,
        STRING_AGG(coalesce(d.discount_min_qty  ::character varying,''), ';') as discount_min_qty,
        STRING_AGG(coalesce(d.discount_max_qty  ::character varying,''), ';') as discount_max_qty,
        STRING_AGG(coalesce(d.discount_free_qty  ::character varying,''), ';') as discount_free_qty,
        STRING_AGG(coalesce(c.mst_item_variant_price  ::character varying,''), ';') as mst_item_variant_price,
        STRING_AGG(coalesce(c.mst_item_variant_price::float * (d.discount::float/100),0)::character varying, ';') as discount_price,
        STRING_AGG(coalesce(c.mst_item_variant_price::float-c.mst_item_variant_price::float * (d.discount::float/100),c.mst_item_variant_price)::character varying, ';') as after_discount_price
    FROM pos_item_stock AS a  
    LEFT JOIN mst_item AS b ON a.mst_item_id= b.mst_item_id 
    LEFT JOIN mst_item_variant AS c ON b.mst_item_id = c.mst_item_id
    LEFT JOIN mst_packaging AS pack ON c.mst_packaging_id = pack.mst_packaging_id 
    LEFT JOIN pos_discount AS d 
      ON c.mst_item_variant_id = d.mst_item_variant_id
      AND d.status = '1'
      AND (d.pos_discount_starttime <= now() AND pos_discount_endtime >= now())
      AND d.flag_delete = '0'
    WHERE 1+1=2  `;
  // GET BRANCH CODE
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += genFilterBranch(data.pos_branch_code);
  }

  if (data.hasOwnProperty("pos_item_stock_id") && data.pos_item_stock_id) {
    _sql += ` AND a.pos_item_stock_id = '${data.pos_item_stock_id}'`;
  }
  if (data.hasOwnProperty("mst_item_id") && data.mst_item_id) {
    _sql += ` AND b.mst_item_id = '${data.mst_item_id}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id") && data.mst_item_variant_id) {
    _sql += ` AND c.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  if (data.hasOwnProperty("barcode") && data.barcode) {
    _sql += ` AND c.barcode = '${data.barcode}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += ` GROUP BY a.pos_item_stock_id ; `;
  let _data = await get_query(_sql);
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
  } else if (data.hasOwnProperty("pos_trx_return_id")) {
    _data.mst_customer_id = data.mst_customer_id;
    _data.pos_trx_inbound_type = "return";
    _data.pos_ref_table = "pos_trx_return";
    _data.pos_ref_id = _data.pos_trx_return_id;
  }
  // else if (data.hasOwnProperty("mst_warehouse_id")) {
  //   _data.mst_warehouse_id = data.mst_warehouse_id;
  //   _data.pos_trx_inbound_type = "warehouse";
  // }

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
  } else if (data.hasOwnProperty("pos_trx_return_id")) {
    _datas = await getTrxDetailItem({ pos_trx_ref_id: data.pos_trx_return_id });
  } else if (data.hasOwnProperty("pos_trx_destroy_id")) {
    _datas = await getTrxDetailItem({
      pos_trx_ref_id: data.pos_trx_destroy_id,
    });
  }

  let newData = [];
  for (const it of _datas.data) {
    it.qty_stock = it.qty * it.mst_item_variant_qty;
    it.pos_branch_code = data.pos_branch_code;
    newData.push(it);
  }
  let reduce = sumByKey({
    key: "mst_item_id",
    array: newData,
    sum: "qty",
    sum2: "qty_stock",
  });
  let _sql = "";
  for (const it of reduce) {
    let _item = await getStockItem(it);
    it.qty = it.qty_stock ?? it.qty;
    if (_item.data.length == 0) {
      if (data.hasOwnProperty("pos_trx_destroy_id")) {
        return { error: true, message: "Stock not found for this branch" };
      }
      _sql += await generate_query_insert({
        values: it,
        table: "pos_item_stock",
      });
    } else {
      let body = { ..._item.data[0], ...it };
      body.qty += _item.data[0].qty ?? 0;
      if (data.hasOwnProperty("pos_trx_destroy_id")) {
        body.qty = _item.data[0].qty - body.qty_stock;
      }
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
  let _sql = `SELECT *,  (a.qty * a.mst_item_variant_qty) as qty_stock 
  FROM pos_trx_detail AS a
  LEFT JOIN mst_item_variant AS b ON a.mst_item_variant_id  = b.mst_item_variant_id 
  LEFT JOIN mst_item AS c ON c.mst_item_id  = b.mst_item_id 
  LEFT JOIN mst_packaging AS d ON d.mst_packaging_id  = b.mst_packaging_id 
    WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_trx_ref_id")) {
    _sql += ` AND a.pos_trx_ref_id = '${data.pos_trx_ref_id}'`;
  }
  if (data.hasOwnProperty("mst_item_variant_id") && data.mst_item_variant_id) {
    _sql += ` AND a.mst_item_variant_id = '${data.mst_item_variant_id}'`;
  }
  if (data.hasOwnProperty("barcode") && data.barcode) {
    _sql += ` AND b.barcode = '${data.barcode}'`;
  }
  let _data = await exec_query(_sql);
  return _data;
}

async function getPosBranch(data = Object) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_branch_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_name) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_desc) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_address) LIKE LOWER('%${search}%')
  OR  CAST(a.pos_branch_phone AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(CASE WHEN a.status=1 THEN 'Active' ELSE 'Inactive' end) LIKE LOWER('%${search}%') ) `;
  };
  let _sql = `SELECT * FROM pos_branch AS a WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_branch_id")) {
    _sql += ` AND a.pos_branch_id = '${data.pos_branch_id}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  let _data = await get_query(_sql);
  return _data;
}

async function getPosUserBranch(data = Object) {
  const genSearch = (search) => {
    return ` 
  AND (CAST(a.pos_branch_id AS TEXT) LIKE LOWER('%${search}%')
  OR  CAST(a.created_at AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_name) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_code) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_desc) LIKE LOWER('%${search}%')
  OR  LOWER(a.pos_branch_address) LIKE LOWER('%${search}%')
  OR  CAST(a.pos_branch_phone AS TEXT) LIKE LOWER('%${search}%')
  OR  LOWER(c.user_name) LIKE LOWER('%${search}%')
  OR  LOWER(c.user_email) LIKE LOWER('%${search}%')) `;
  };
  let _sql = `SELECT 
  MAX(a.pos_branch_id) AS pos_branch_id,
  MAX(a.created_at) AS created_at, 
  MAX(a.updated_at) AS updated_at,
  MAX(a.flag_delete) AS flag_delete, 
  MAX(a.status) AS status,
  STRING_AGG(coalesce(b.pos_user_branch_id::character varying,''), ';') as pos_user_branch_id,
  MAX(a.pos_branch_name) AS pos_branch_name, 
  MAX(a.pos_branch_desc) AS pos_branch_desc,
  MAX(a.pos_branch_code) AS pos_branch_code,
  MAX(a.pos_branch_phone) AS pos_branch_phone,
  MAX(a.pos_branch_address) AS pos_branch_address,
  COUNT(*) FILTER (WHERE b.is_cashier IS TRUE) AS total_cashier,
  COUNT(b.user_id) AS total_user,
  STRING_AGG(c.user_name,',') AS user_name,
  STRING_AGG(c.user_email,',') AS user_email
  FROM pos_branch AS a 
  LEFT JOIN pos_user_branch AS b 
    ON b.pos_branch_code = a.pos_branch_code 
    AND b.flag_delete = 0
    -- AND b.status = 1
  LEFT JOIN "user" AS c ON b.user_id =c.user_id 
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_branch_id")) {
    _sql += ` AND a.pos_branch_id = '${data.pos_branch_id}'`;
  }
  if (data.hasOwnProperty("pos_user_branch_id")) {
    _sql += ` AND a.pos_user_branch_id = '${data.pos_user_branch_id}'`;
  }
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += ` AND a.pos_branch_code = '${data.pos_branch_code}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND b.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }
  if (data.hasOwnProperty("search")) {
    if (isJsonString(data.search)) {
      for (const it of JSON.parse(data.search)) {
        _sql += genSearch(it);
      }
    } else {
      _sql += genSearch(data.search);
    }
  }
  _sql += ` GROUP BY a.pos_branch_id ; `;
  let _data = await get_query(_sql);
  return _data;
}

async function getPosUserBranchCode(data = Object) {
  let _sql = `SELECT array_agg(a.pos_branch_code) AS pos_branch_code
  FROM pos_user_branch AS a 
  WHERE 1+1=2 `;
  if (data.hasOwnProperty("pos_branch_id")) {
    _sql += ` AND a.pos_branch_id = '${data.pos_branch_id}'`;
  }
  if (data.hasOwnProperty("pos_user_branch_id")) {
    _sql += ` AND a.pos_user_branch_id = '${data.pos_user_branch_id}'`;
  }
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += ` AND a.pos_branch_code = '${data.pos_branch_code}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND a.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }
  if (data.hasOwnProperty("is_cashier")) {
    _sql += ` AND a.is_cashier IS ${data.is_cashier}`;
  }
  _sql += ` GROUP BY a.pos_branch_code ; `;
  let _data = await get_query(_sql);
  if (_data.total == 1) {
    _data = _data.data[0].pos_branch_code;
  } else {
    _data = [];
  }
  return _data;
}

async function getPosUser(data = Object) {
  let _sql = `SELECT  * , a.status AS status, a.flag_delete AS flag_delete
  FROM pos_user_branch AS a
  LEFT JOIN "user" AS b ON b.user_id = a.user_id 
  WHERE a.flag_delete = 0  `;
  if (data.hasOwnProperty("pos_branch_code")) {
    _sql += ` AND a.pos_branch_code = '${data.pos_branch_code}'`;
  }
  if (data.hasOwnProperty("pos_user_branch_id")) {
    _sql += ` AND a.pos_user_branch_id = '${data.pos_user_branch_id}'`;
  }
  if (data.hasOwnProperty("user_id")) {
    _sql += ` AND a.user_id = '${data.user_id}'`;
  }
  if (data.hasOwnProperty("is_cashier")) {
    _sql += ` AND a.is_cashier IS ${data.is_cashier}`;
  }
  if (data.hasOwnProperty("status")) {
    _sql += ` AND a.status = '${data.status}'`;
  }
  let _data = await get_query(_sql);
  return _data;
}
const genFilterBranch = (branch_code) => {
  let _sql = "";
  if (isArray(branch_code)) {
    let str = JSON.stringify(branch_code).replace(/"/g, "'");
    _sql += ` AND a.pos_branch_code = ANY(ARRAY${str})`;
  } else if (isString(branch_code)) {
    _sql += ` AND a.pos_branch_code = '${branch_code}'`;
  }
  return _sql;
};

module.exports = {
  getReceive,
  getPosUserBranchCode,
  getReceiveByUser,
  getDetailReceive,
  getInbound,
  getInboundByUser,
  getItem,
  getStockItem,
  proccessToInbound,
  proccessToStock,
  getTrxDetailItem,
  getCashier,
  getSale,
  getReturn,
  getSaleByCashier,
  getDiscount,
  getCustomer,
  getPosBranch,
  getDestroy,
  getReportSale,
  getReportCashierSale,
  getPosUserBranch,
  getPosUser,
};
