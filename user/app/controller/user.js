'use strict';
const response = require('../response');
const utils = require('../utils');
const perf = require('execution-time')();
const dotenv = require('dotenv');

dotenv.config();//- MYSQL Module

exports.get = async function (req, res) {
    // LINE WAJIB DIBAWA
    perf.start();
    console.log(`req : ${JSON.stringify(req.query)}`);
    var data = { data: req.query }
    const require_data = [];
    for (const row of require_data) {
        if (!req.query[`${row}`]) {
            data.error = true;
            data.message = `${row} is required!`;
            return response.response(data, res)
        }
    }
    // LINE WAJIB DIBAWA
    var $query = `
    SELECT * 
    FROM user AS a 
    LEFT JOIN user_section AS b ON a.section_id = b.section_id
    Left JOIN user_department AS c ON b.department_id = c.department_id
    WHERE 1+1=2 `;
    for (const k in req.query) {
        if (!k == 'page' || !k == 'limit') {
            $query += ` AND a.${k}='${req.query[k]}'`;
        }
    }
    if (req.query.page || req.query.limit) {
        var start = parseInt(req.query.page) == 1 ? 0 : req.query.page * req.query.limit;
        var end = parseInt(start) + parseInt(req.query.limit);
        $query += ` LIMIT ${start},${end} `;
    }
    // query
    const client_conn = new utils.DB();
    client_conn.open();
    const check = await client_conn.query($query);
    client_conn.close();
    // query
    if (check.error || check.total == 0) {
        return response.response(check, res)
    }
    return response.response(check, res)

};
