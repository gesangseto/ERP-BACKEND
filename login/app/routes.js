'use strict';

module.exports = function (app) {

    var login = require('./controller/login');
    app.route('/auth/login/user').post(login.user_login);
};