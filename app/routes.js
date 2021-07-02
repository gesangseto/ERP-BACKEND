"use strict";

module.exports = function (app) {
  var login = require("./controller/login");
  app.route("/auth/login/user").post(login.user_login);

  var user = require("./controller/user");
  app.route("/master/user").get(user.get);
  app.route("/master/user").put(user.insert);
  app.route("/master/user").post(user.update);
  app.route("/master/user").delete(user.delete);
};
