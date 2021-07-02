const mysql = require("mysql");

class DB {
    constructor() {
        this.conn = mysql.createConnection({
            host: process.env.DB_HOST,
            user: process.env.DB_PORT,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_DATABASE
        });
    }
    open() {
        this.conn.connect(function (err) {
            if (err) {
                console.error("error connecting: " + err.stack);
                return;
            }
            // console.log("open - connection client");
        });
    }
    async query(sql) {
        var data_set = { error: false, data: [], total: 0, message: "Success" };
        return await new Promise((resolve) =>
            this.conn.query(sql, function (error, rows) {
                if (error) {
                    data_set.error = true;
                    data_set.message = JSON.stringify(error);
                    return resolve(data_set)
                }
                data_set.data = rows;
                data_set.total = rows.length;
                return resolve(data_set);
            })
        );
    }
    close() {
        this.conn.end(function (err) {
            {
                if (err) {
                    console.error("error close connection: " + err.stack);
                    return;
                }
                // console.log("close - connection client");
            }
        });
    }
}

module.exports = {
    DB
};