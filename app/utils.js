const mysql = require("mysql");
const dotenv = require("dotenv");

dotenv.config(); //- MYSQL Module

var db_config = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
};

var pool = mysql.createPool(db_config);

async function exec_query(query_sql) {
  var data_set = { error: false, data: [], total: 0, message: "Success" };
  return await new Promise((resolve) =>
    pool.getConnection(function (err, connection) {
      connection.query(query_sql, function (err, rows) {
        connection.release();
        if (err) {
          data_set.error = true;
          data_set.message = err.sqlMessage || "Oops, something wrong";
          return resolve(data_set);
        }
        data_set.data = rows;
        data_set.total = rows.length;
        return resolve(data_set);
      });
    })
  );
}

module.exports = {
  exec_query,
};
