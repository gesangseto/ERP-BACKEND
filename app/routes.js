"use strict";

module.exports = function (app) {
  app.group("/api/administrator", (router) => {
    var authentication = require("./controller/Administrator/authentication");
    router.post("/login/user", authentication.user_login);

    var genBarcode = require("./controller/Administrator/generate_barcode");
    router.post("/generate-barcode", genBarcode.generateBarcode);
    router.get("/generate-barcode", genBarcode.generateBarcode);

    var audit_log = require("./controller/Administrator/audit_log");
    router.get("/audit/log", audit_log.get);

    var sys_configuration = require("./controller/Administrator/sys_configuration");
    router.get("/configuration", sys_configuration.get);
    router.post("/configuration", sys_configuration.update);

    var sys_relation = require("./controller/Administrator/sys_relation");
    router.get("/config-relation", sys_relation.get);
    router.get("/config-relation-list", sys_relation.getRelationList);
    router.post("/config-relation", sys_relation.update);

    var sys_role_section = require("./controller/Administrator/sys_role_section");
    router.get("/role/section", sys_role_section.getRoleMenu);
    router.post("/role/section", sys_role_section.insertUpdateRoleMenu);

    var user_department = require("./controller/Administrator/user_department");
    router.get("/master/user_department", user_department.get);
    router.put("/master/user_department", user_department.insert);
    router.post("/master/user_department", user_department.update);
    router.delete("/master/user_department", user_department.delete);

    var user_section = require("./controller/Administrator/user_section");
    router.get("/master/user_section", user_section.get);
    router.put("/master/user_section", user_section.insert);
    router.post("/master/user_section", user_section.update);
    router.delete("/master/user_section", user_section.delete);

    var user = require("./controller/Administrator/user");
    router.get("/master/user", user.get);
    router.put("/master/user", user.insert);
    router.post("/master/user", user.update);
    router.delete("/master/user", user.delete);

    var approval = require("./controller/Administrator/approval");
    router.get("/approval/main-approval", approval.get);
    router.put("/approval/main-approval", approval.insert);
    router.post("/approval/main-approval", approval.update);
    router.delete("/approval/main-approval", approval.delete);

    var approval_flow = require("./controller/Administrator/approval_flow");
    router.get("/approval/flow-approval", approval_flow.get);
    router.post("/approval/flow-approval", approval_flow.update);

    var mst_item = require("./controller/Administrator/mst_item");
    router.get("/master/item", mst_item.get);
    router.get("/master/item-variant", mst_item.getVariant);
    router.put("/master/item", mst_item.insert);
    router.post("/master/item", mst_item.update);
    router.delete("/master/item", mst_item.delete);

    var mst_packaging = require("./controller/Administrator/mst_packaging");
    router.get("/master/packaging", mst_packaging.get);
    router.put("/master/packaging", mst_packaging.insert);
    router.post("/master/packaging", mst_packaging.update);
    router.delete("/master/packaging", mst_packaging.delete);

    var mst_supplier = require("./controller/Administrator/mst_supplier");
    router.get("/master/supplier", mst_supplier.get);
    router.put("/master/supplier", mst_supplier.insert);
    router.post("/master/supplier", mst_supplier.update);
    router.delete("/master/supplier", mst_supplier.delete);

    var mst_customer = require("./controller/Administrator/mst_customer");
    router.get("/master/customer", mst_customer.get);
    router.put("/master/customer", mst_customer.insert);
    router.post("/master/customer", mst_customer.update);
    router.delete("/master/customer", mst_customer.delete);
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
