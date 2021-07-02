"use strict";

module.exports = function (app) {
  var login = require("./controller/login");
  app.route("/auth/login/user").post(login.user_login);

  var menu_parent = require("./controller/menu_parent");
  app.route("/menu/parent").get(menu_parent.get);
  app.route("/menu/parent").put(menu_parent.insert);
  app.route("/menu/parent").post(menu_parent.update);
  app.route("/menu/parent").delete(menu_parent.delete);

  var menu_child = require("./controller/menu_child");
  app.route("/menu/child").get(menu_child.get);
  app.route("/menu/child").put(menu_child.insert);
  app.route("/menu/child").post(menu_child.update);
  app.route("/menu/child").delete(menu_child.delete);

  var menu_role = require("./controller/menu_role");
  app.route("/menu/role").get(menu_role.get);
  app.route("/menu/role").put(menu_role.insert);
  app.route("/menu/role").post(menu_role.update);
  app.route("/menu/role").delete(menu_role.delete);

  var user_department = require("./controller/user_department");
  app.route("/master/user_department").get(user_department.get);
  app.route("/master/user_department").put(user_department.insert);
  app.route("/master/user_department").post(user_department.update);
  app.route("/master/user_department").delete(user_department.delete);

  var user_section = require("./controller/user_section");
  app.route("/master/user_section").get(user_section.get);
  app.route("/master/user_section").put(user_section.insert);
  app.route("/master/user_section").post(user_section.update);
  app.route("/master/user_section").delete(user_section.delete);

  var user = require("./controller/user");
  app.route("/master/user").get(user.get);
  app.route("/master/user").put(user.insert);
  app.route("/master/user").post(user.update);
  app.route("/master/user").delete(user.delete);
};
