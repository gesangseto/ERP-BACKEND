const Pool = require("pg").Pool;
const moment = require("moment");
const { isInt } = require("./utils");

var db_config = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  port: process.env.DB_PORT,
};

const pool = new Pool(db_config);

var data_set = {
  error: false,
  data: [],
  total: 0,
  grand_total: 0,
  message: "Success",
};

async function get_configuration({ property = null }) {
  let _data = JSON.parse(JSON.stringify(data_set));
  return await new Promise((resolve) =>
    pool.query("SELECT * FROM sys_configuration LIMIT 1", function (err, rows) {
      if (err) {
        _data.error = true;
        _data.message = err.sqlMessage || "Oops, something wrong";
        return resolve(_data);
      }
      return resolve(rows[0]);
    })
  );
}

async function generate_query_insert({ table, values }) {
  let get_structure = `DESCRIBE ${table};`;
  get_structure = await exec_query(get_structure);
  let column = "";
  let datas = "";
  let query = `INSERT INTO ${table} `;
  if (typeof values === "object" && values !== null) {
    for (const key_v in values) {
      for (const it of get_structure.data) {
        let key = it.Field;
        if (key_v === key) {
          if (values[key_v]) {
            column += ` ${key_v},`;
            datas += ` '${values[key_v]}',`;
          }
        }
      }
    }
    column = ` (${column.substring(0, column.length - 1)}) `;
    datas = ` (${datas.substring(0, datas.length - 1)}) `;
    query += ` ${column} VALUES ${datas} ;`;
  }
  return query;
}

async function generate_query_update({ table, values, key }) {
  let get_structure = `DESCRIBE ${table};`;
  get_structure = await exec_query(get_structure);
  let column = "";
  let query = `UPDATE ${table} SET`;
  if (typeof values === "object" && values !== null) {
    for (const key_v in values) {
      for (const itm of get_structure.data) {
        if (key_v === itm.Field) {
          if (values[key_v]) {
            column += ` ${key_v}= '${values[key_v]}',`;
          }
        }
      }
    }
    column = ` ${column.substring(0, column.length - 1)}`;
    query += ` ${column} WHERE ${key} = '${values[key]}'; `;
  }
  return query;
}

async function exec_query(query_sql) {
  let _data = JSON.parse(JSON.stringify(data_set));
  return await new Promise((resolve) =>
    pool.query(query_sql, function (err, rows) {
      if (err) {
        if (err.code == 42703) {
          _data.data = [];
          _data.total = 0;
          _data.grand_total = 0;
          return resolve(_data);
        }
        _data.error = true;
        _data.message = err.message || "Oops, something wrong";
        return resolve(_data);
      }
      _data.data = rows.rows;
      _data.total = rows.rowCount;
      _data.grand_total = rows.rowCount;
      return resolve(_data);
    })
  );
}

async function get_query(query_sql) {
  let _data = JSON.parse(JSON.stringify(data_set));
  var _where = query_sql.split("FROM") || query_sql.split("from");
  _where = _where[1].split("LIMIT") || _where[1].split("limit");
  var count = `SELECT COUNT(*) AS total FROM ${_where[0]}`;
  count = await exec_query(count);
  if (count.error) {
    _data.error = true;
    _data.message = count.message;
    return _data;
  }
  _data.grand_total = count.grand_total;
  return await new Promise((resolve) =>
    pool.query(query_sql, function (err, rows) {
      if (err) {
        if (err.code == 42703) {
          _data.data = [];
          _data.total = 0;
          _data.grand_total = 0;
          return resolve(_data);
        }
        _data.error = true;
        _data.message = err.message || "Oops, something wrong";
        return resolve(_data);
      }
      _data.data = rows.rows;
      _data.total = rows.rowCount;
      return resolve(_data);
    })
  );
}

async function insert_query({ data, key, table }) {
  let _data = JSON.parse(JSON.stringify(data_set));
  var column = `SELECT column_name,data_type  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '${table}'`;
  column = await exec_query(column);
  if (column.error) {
    _data.error = true;
    _data.message = column.message || "Oops, something wrong";
    return _data;
  }
  column = column.data;
  var dataArr = [];
  var key = [];
  var val = [];
  for (const k in data) {
    var it = data[k];
    var isColumAvalaible = false;
    var is_text = false;
    var is_time = false;
    var is_int = false;
    for (const col_name of column) {
      if (k == col_name.column_name) {
        isColumAvalaible = true;
        if (col_name.data_type.includes("time")) {
          is_time = true;
        } else if (
          col_name.data_type.includes("int") ||
          col_name.data_type.includes("numeric")
        ) {
          is_int = true;
        } else {
          is_text = true;
        }
      }
    }
    if (isColumAvalaible) {
      if (is_text) {
        if (it) {
          key.push(k);
          val.push(it);
        }
      } else if (is_int && isInt(it)) {
        key.push(k);
        val.push(it);
      } else if (
        is_time &&
        it != "created_at" &&
        moment(it, moment.ISO_8601, true).isValid()
      ) {
        key.push(k);
        val.push(it);
      }
    }
  }

  key = key.toString();
  val = "'" + val.join("','") + "'";
  dataArr = dataArr.join(",");
  var query_sql = `INSERT INTO "${table}" (${key}) VALUES (${val})`;
  return await new Promise((resolve) =>
    pool.query(query_sql, function (err, rows) {
      if (err) {
        _data.error = true;
        _data.message = err.message || "Oops, something wrong";
        return resolve(_data);
      }
      console.log(rows);
      _data.data = rows;
      _data.grand_total = rows.length;
      return resolve(_data);
    })
  );
}

async function update_query({ data, key, table }) {
  let _data = JSON.parse(JSON.stringify(data_set));
  var column = `SELECT column_name,data_type  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '${table}'`;
  column = await exec_query(column);
  if (column.error) {
    _data.error = true;
    _data.message = column.message || "Oops, something wrong";
    return _data;
  }
  column = column.data;
  var dataArr = [];
  for (const k in data) {
    var it = data[k];
    var isColumAvalaible = false;
    var is_text = false;
    var is_time = false;
    var is_int = false;
    for (const col_name of column) {
      if (k == col_name.column_name) {
        isColumAvalaible = true;
        if (col_name.data_type.includes("time")) {
          is_time = true;
        } else if (col_name.data_type.includes("int")) {
          is_int = true;
        } else {
          is_text = true;
        }
      }
    }
    if (isColumAvalaible) {
      if (is_text) {
        dataArr.push(` ${k} = '${it}'`);
      } else if (is_int && isInt(it)) {
        dataArr.push(` ${k} = '${it}'`);
      } else if (
        is_time &&
        it != "created_at" &&
        moment(it, moment.ISO_8601, true).isValid()
      ) {
        it = moment(it).format("YYYY-MM-DD HH:mm:ss");
        dataArr.push(` ${k} = '${it}'`);
      }
    }
  }
  dataArr = dataArr.join(",");
  var query_sql = `UPDATE "${table}" SET ${dataArr} WHERE ${key}='${data[key]}'`;
  return await new Promise((resolve) =>
    pool.query(query_sql, function (err, rows) {
      if (err) {
        _data.error = true;
        _data.message = err.message || "Oops, something wrong";
        return resolve(_data);
      }
      _data.data = rows;
      _data.grand_total = rows.length;
      return resolve(_data);
    })
  );
}

async function delete_query({
  data,
  key,
  table,
  deleted = true,
  force_delete = false,
}) {
  let _data = JSON.parse(JSON.stringify(data_set));

  if (!force_delete) {
    var current_data = `SELECT * FROM "${table}" WHERE ${key}='${data[key]}' LIMIT 1`;
    current_data = await exec_query(current_data);
    if (current_data.error || current_data.total == 0) {
      _data.error = true;
      _data.message = current_data.message || "Oops, something wrong";
      return _data;
    }
    if (current_data.data[0].status == 1) {
      _data.error = true;
      _data.message = "Cannot delete data, must set data to Inactive";
      return _data;
    }
  }
  let query_sql = ``;
  if (deleted) {
    query_sql = `DELETE FROM ${table} WHERE ${key}='${data[key]}'`;
  } else {
    query_sql = `UPDATE ${table} SET flag_delete='1' WHERE ${key}='${data[key]}'`;
  }
  console.log(query_sql);
  return await new Promise((resolve) =>
    pool.query(query_sql, function (err, rows) {
      if (err) {
        _data.error = true;
        _data.message = err.message || "Oops, something wrong";
        if (err.code == 23503) {
          _data.message = err.detail;
        }
        return resolve(_data);
      }
      _data.data = rows;
      _data.grand_total = rows.length;
      return resolve(_data);
    })
  );
}

async function filter_query(query, request = Object, exclude = Array) {
  let $query = query;
  try {
    for (const k in request) {
      if (k != "page" && k != "limit") {
        $query += ` AND a.${k}='${request[k]}'`;
      }
    }
    if (request.page || request.limit) {
      var start = 0;
      if (request.page > 1) {
        start = parseInt((request.page - 1) * request.limit);
      }
      var end = parseInt(start) + parseInt(request.limit);
      $query += ` LIMIT ${end}  OFFSET ${start} ;`;
    }
    return $query;
  } catch (error) {
    return $query;
  }
}

module.exports = {
  get_configuration,
  exec_query,
  get_query,
  insert_query,
  update_query,
  delete_query,
  generate_query_update,
  generate_query_insert,
  filter_query,
};
