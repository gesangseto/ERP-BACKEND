'use strict';
const response = require('../response');
const utils = require('../utils');
const perf = require('execution-time')();
const dotenv = require('dotenv');

dotenv.config();//- MYSQL Module

exports.user_login = async function (req, res) {
    // LINE WAJIB DIBAWA
    perf.start();
    console.log(`req : ${JSON.stringify(req.body)}`);
    var data = { data: req.body }
    const require_data = ["user_name", "user_password"];
    for (const row of require_data) {
        if (!req.body[`${row}`]) {
            data.error = true;
            data.message = `${row} is required!`;
            return response.response(data, res)
        }
    }
    // LINE WAJIB DIBAWA
    // query
    const client_conn = new utils.DB();
    client_conn.open();
    const check = await client_conn.query(`SELECT * FROM user WHERE user_name='${req.body.user_name}' AND user_password='${req.body.user_password}' LIMIT 1`);
    client_conn.close();
    // query
    if (check.error || check.total == 0) {
        check.message = "Wrong Username Or Password !";
        return response.response(check, res)
    }
    return response.response(check, res)

};
