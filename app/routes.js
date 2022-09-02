"use strict";

module.exports = function (app) {
  app.group("/api/administrator", (router) => {
    var authentication = require("./controller/Administrator/authentication");
    app.route("/api/login/user").post(authentication.user_login);

    var genBarcode = require("./controller/Administrator/generate_barcode");
    app.route("/api/generate-barcode").post(genBarcode.generateBarcode);
    app.route("/api/generate-barcode").get(genBarcode.generateBarcode);

    var audit_log = require("./controller/Administrator/audit_log");
    app.route("/api/audit/log").get(audit_log.get);

    var sys_configuration = require("./controller/Administrator/sys_configuration");
    app.route("/api/configuration").get(sys_configuration.get);
    app.route("/api/configuration").post(sys_configuration.update);

    var sys_relation = require("./controller/Administrator/sys_relation");
    app.route("/api/config-relation").get(sys_relation.get);
    app.route("/api/config-relation-list").get(sys_relation.getRelationList);
    app.route("/api/config-relation").post(sys_relation.update);

    var sys_role_section = require("./controller/Administrator/sys_role_section");
    app.route("/api/role/section").get(sys_role_section.getRoleMenu);
    app.route("/api/role/section").post(sys_role_section.insertUpdateRoleMenu);

    var user_department = require("./controller/Administrator/user_department");
    app.route("/api/master/user_department").get(user_department.get);
    app.route("/api/master/user_department").put(user_department.insert);
    app.route("/api/master/user_department").post(user_department.update);
    app.route("/api/master/user_department").delete(user_department.delete);

    var user_section = require("./controller/Administrator/user_section");
    app.route("/api/master/user_section").get(user_section.get);
    app.route("/api/master/user_section").put(user_section.insert);
    app.route("/api/master/user_section").post(user_section.update);
    app.route("/api/master/user_section").delete(user_section.delete);

    var user = require("./controller/Administrator/user");
    app.route("/api/master/user").get(user.get);
    app.route("/api/master/user").put(user.insert);
    app.route("/api/master/user").post(user.update);
    app.route("/api/master/user").delete(user.delete);

    var approval = require("./controller/Administrator/approval");
    app.route("/api/approval/main-approval").get(approval.get);
    app.route("/api/approval/main-approval").put(approval.insert);
    app.route("/api/approval/main-approval").post(approval.update);
    app.route("/api/approval/main-approval").delete(approval.delete);

    var approval_flow = require("./controller/Administrator/approval_flow");
    app.route("/api/approval/flow-approval").get(approval_flow.get);
    app.route("/api/approval/flow-approval").post(approval_flow.update);

    var mst_item = require("./controller/Administrator/mst_item");
    app.route("/api/master/item").get(mst_item.get);
    app.route("/api/master/item-variant").get(mst_item.getVariant);
    app.route("/api/master/item").put(mst_item.insert);
    app.route("/api/master/item").post(mst_item.update);
    app.route("/api/master/item").delete(mst_item.delete);

    var mst_packaging = require("./controller/Administrator/mst_packaging");
    app.route("/api/master/packaging").get(mst_packaging.get);
    app.route("/api/master/packaging").put(mst_packaging.insert);
    app.route("/api/master/packaging").post(mst_packaging.update);
    app.route("/api/master/packaging").delete(mst_packaging.delete);

    var mst_supplier = require("./controller/Administrator/mst_supplier");
    app.route("/api/master/supplier").get(mst_supplier.get);
    app.route("/api/master/supplier").put(mst_supplier.insert);
    app.route("/api/master/supplier").post(mst_supplier.update);
    app.route("/api/master/supplier").delete(mst_supplier.delete);

    var mst_customer = require("./controller/Administrator/mst_customer");
    app.route("/api/master/customer").get(mst_customer.get);
    app.route("/api/master/customer").put(mst_customer.insert);
    app.route("/api/master/customer").post(mst_customer.update);
    app.route("/api/master/customer").delete(mst_customer.delete);
  });
  /*
  This all route for POS Module
  */
  app.group("/api/pos", (router) => {
    // Utils
    var utils = require("./controller/POS/utils");
    router.post("/transaction/cleanup", utils.cleanup);
    // Inbound
    var inbound = require("./controller/POS/inbound");
    router.get("/transaction/inbound", inbound.get);
    router.get("/transaction/inbound/by-branch", inbound.getByBranch);
    // Stock
    var stock = require("./controller/POS/stock");
    router.get("/transaction/stock", stock.get);
    router.get("/transaction/stock/by-branch", stock.getByBranch);
    // Cabang
    var branch = require("./controller/POS/branch");
    router.get("/master/branch", branch.get);
    router.get("/master/branch/by-branch", branch.getByBranch);
    router.put("/master/branch", branch.insert);
    router.post("/master/branch", branch.update);
    router.delete("/master/branch", branch.delete);
    // User Cabang
    var user_branch = require("./controller/POS/user_branch");
    router.get("/master/user-branch", user_branch.get);
    router.put("/master/user-branch", user_branch.insert);
    router.post("/master/user-branch", user_branch.update);
    router.delete("/master/user-branch", user_branch.delete);
    // Discount
    var discount = require("./controller/POS/discount");
    router.get("/master/discount", discount.get);
    router.get("/master/discount/by-branch", discount.getByBranch);
    router.put("/master/discount", discount.insert);
    router.post("/master/discount", discount.update);
    router.delete("/master/discount", discount.delete);
    // RECEIVE
    var receive = require("./controller/POS/receive");
    router.get("/transaction/receive", receive.get);
    router.get("/transaction/receive/by-branch", receive.getByBranch);
    router.put("/transaction/receive", receive.insert);
    router.post("/transaction/receive", receive.approve);
    // SALE
    var sale = require("./controller/POS/sale");
    router.get("/transaction/sale", sale.get);
    router.get("/transaction/sale/by-branch", sale.getByBranch);
    router.put("/transaction/sale", sale.newSale);
    router.post("/transaction/sale", sale.updateSale);
    router.delete("/transaction/sale", sale.deleteSale);
    router.post("/transaction/sale/payment", sale.payment);
    // RETURN
    var _return = require("./controller/POS/return");
    router.get("/transaction/return", _return.get);
    router.get("/transaction/return/by-branch", _return.getByBranch);
    router.put("/transaction/return", _return.insert);
    router.post("/transaction/return", _return.approve);
    // DESTROY
    var destroy = require("./controller/POS/destroy");
    router.get("/transaction/destroy", destroy.get);
    router.get("/transaction/destroy/by-branch", destroy.getByBranch);
    router.put("/transaction/destroy", destroy.insert);
    router.post("/transaction/destroy", destroy.approve);
    // CASHIER
    var cashier = require("./controller/POS/cashier");
    router.get("/transaction/cashier", cashier.get);
    router.put("/transaction/cashier", cashier.openCashier);
    router.post("/transaction/cashier", cashier.closeCashier);
    // REPORT
    var report = require("./controller/POS/report");
    router.get("/report/sale", report.get);
    router.get("/report/sale/by-branch", report.getByBranch);
    router.get("/report/sale-cashier", report.reportCashierSale);
  });
};
