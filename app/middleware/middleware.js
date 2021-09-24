'use strict';
let response = require('../response');
const models = require("../models");
const moment = require("moment");
const dotenv = require("dotenv");
dotenv.config(); //- MYSQL Module


async function check_token(req, res) {
    var body = Object.keys(req.query).length > 0 ? req.query : req.body
    var data = { data: body, error: null, message: null };
    console.log(`req : ${JSON.stringify(req.body)}`);
    try {
        let time_now = moment().format("YMMDHHmmss");
        let token = req.headers['token'];
        if (!token) {
            data.error = true;
            data.status_code = 401
            data.message = `Authentication failed, token header is required`;
            return response.response(data, res);
        }
        if (process.env.DEV_TOKEN == token) {
            return res
        }
        let configuration = await models.get_configuration({});
        req.headers.configuration = configuration;
        let $query = `SELECT * FROM user_authentication WHERE token='${token}'`
        $query = await models.exec_query($query);
        if ($query.error || $query.total == 0) {
            data.status_code = 401
            data.error = true;
            data.message = `Authentication failed, token header is invalid`;
            return response.response(data, res);
        }
        let expired_token = moment($query.data[0].expired_at).format("YMMDHHmmss");
        if (expired_token < time_now) {
            data.status_code = 401
            data.error = true;
            data.message = `Authentication failed, token header is expired`;
            return response.response(data, res);
        }

        let _temp = {
            user_id: $query.data[0].user_id,
            expired_at: moment().add(configuration.expired_token, 'days').format('YYYY-MM-DD HH:mm:ss'),
            token: token,
        }
        await models.update_query({ data: _temp, key: "token", table: "user_authentication" });
        return true
    } catch (error) {
        data.error = true;
        data.message = `${error}`;
        return response.response(data, res);
    }

}


module.exports = {
    check_token
};