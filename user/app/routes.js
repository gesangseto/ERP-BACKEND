'use strict';

module.exports = function (app) {

    var user = require('./controller/user');
    app.route('/user/user').get(user.get);
};