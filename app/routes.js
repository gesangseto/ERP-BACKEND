"use strict";

module.exports = function (app) {
  var authentication = require("./controller/authentication");
  app.route("/api/login/user").post(authentication.user_login);

  var audit_log = require("./controller/audit_log");
  app.route("/api/audit/log").get(audit_log.get);

  var sys_configuration = require("./controller/sys_configuration");
  app.route("/api/configuration").get(sys_configuration.get);
  app.route("/api/configuration").post(sys_configuration.update);

  var sys_role_section = require("./controller/sys_role_section");
  app.route("/api/role/section").get(sys_role_section.getRoleMenu);
  app.route("/api/role/section").post(sys_role_section.insertUpdateRoleMenu);

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

  var approval = require("./controller/approval");
  app.route("/api/approval/main-approval").get(approval.get);
  app.route("/api/approval/main-approval").put(approval.insert);
  app.route("/api/approval/main-approval").post(approval.update);
  app.route("/api/approval/main-approval").delete(approval.delete);

  var approval_flow = require("./controller/approval_flow");
  app.route("/api/approval/flow-approval").get(approval_flow.get);
  app.route("/api/approval/flow-approval").post(approval_flow.update);
};
