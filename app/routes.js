"use strict";

module.exports = function (app) {
  var login = require("./controller/login");
  app.route("/api/auth/login/user").post(login.user_login);

  var menu_parent = require("./controller/menu_parent");
  app.route("/api/menu/parent").get(menu_parent.get);
  app.route("/api/menu/parent").put(menu_parent.insert);
  app.route("/api/menu/parent").post(menu_parent.update);
  app.route("/api/menu/parent").delete(menu_parent.delete);

  var menu_child = require("./controller/menu_child");
  app.route("/api/menu/child").get(menu_child.get);
  app.route("/api/menu/child").put(menu_child.insert);
  app.route("/api/menu/child").post(menu_child.update);
  app.route("/api/menu/child").delete(menu_child.delete);

  var menu_role = require("./controller/menu_role");
  app.route("/api/menu/role").get(menu_role.get);
  app.route("/api/menu/role").post(menu_role.update);

  var user_department = require("./controller/user_department");
  app.route("/api/master/user_department").get(user_department.get);
  app.route("/api/master/user_department").put(user_department.insert);
  app.route("/api/master/user_department").post(user_department.update);
  app.route("/api/master/user_department").delete(user_department.delete);

  var user_section = require("./controller/user_section");
  app.route("/api/master/user_section").get(user_section.get);
  app.route("/api/master/user_section").put(user_section.insert);
  app.route("/api/master/user_section").post(user_section.update);
  app.route("/api/master/user_section").delete(user_section.delete);

  var user = require("./controller/user");
  app.route("/api/master/user").get(user.get);
  app.route("/api/master/user").put(user.insert);
  app.route("/api/master/user").post(user.update);
  app.route("/api/master/user").delete(user.delete);
};
