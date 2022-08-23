"use strict";

module.exports = function (app) {
  var authentication = require("./controller/authentication");
  app.route("/api/login/user").post(authentication.user_login);

  var genBarcode = require("./controller/generate_barcode");
  app.route("/api/generate-barcode").post(genBarcode.generateBarcode);
  app.route("/api/generate-barcode").get(genBarcode.generateBarcode);

  var audit_log = require("./controller/audit_log");
  app.route("/api/audit/log").get(audit_log.get);

  var sys_configuration = require("./controller/sys_configuration");
  app.route("/api/configuration").get(sys_configuration.get);
  app.route("/api/configuration").post(sys_configuration.update);

  var sys_relation = require("./controller/sys_relation");
  app.route("/api/config-relation").get(sys_relation.get);
  app.route("/api/config-relation-list").get(sys_relation.getRelationList);
  app.route("/api/config-relation").post(sys_relation.update);

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

  var mst_item = require("./controller/mst_item");
  app.route("/api/master/item").get(mst_item.get);
  app.route("/api/master/item-variant").get(mst_item.getVariant);
  app.route("/api/master/item").put(mst_item.insert);
  app.route("/api/master/item").post(mst_item.update);
  app.route("/api/master/item").delete(mst_item.delete);

  var mst_packaging = require("./controller/mst_packaging");
  app.route("/api/master/packaging").get(mst_packaging.get);
  app.route("/api/master/packaging").put(mst_packaging.insert);
  app.route("/api/master/packaging").post(mst_packaging.update);
  app.route("/api/master/packaging").delete(mst_packaging.delete);

  var mst_supplier = require("./controller/mst_supplier");
  app.route("/api/master/supplier").get(mst_supplier.get);
  app.route("/api/master/supplier").put(mst_supplier.insert);
  app.route("/api/master/supplier").post(mst_supplier.update);
  app.route("/api/master/supplier").delete(mst_supplier.delete);

  var mst_customer = require("./controller/mst_customer");
  app.route("/api/master/customer").get(mst_customer.get);
  app.route("/api/master/customer").put(mst_customer.insert);
  app.route("/api/master/customer").post(mst_customer.update);
  app.route("/api/master/customer").delete(mst_customer.delete);

  /*
  This all route for POS Module
  ==========================================================================
  */
  var _pos_utils = require("./controller/POS/utils");
  app.route("/api/transaction/pos/cleanup").post(_pos_utils.cleanup);
  var _pos_in = require("./controller/POS/inbound");
  app.route("/api/transaction/pos/inbound").get(_pos_in.getInbound);
  var _pos_stock = require("./controller/POS/stock");
  app.route("/api/transaction/pos/stock").get(_pos_stock.get);

  /*
  MASTER
  */
  // BRANCH *CABANG
  var _pos_brc = require("./controller/POS/branch");
  app.route("/api/master/pos/branch").get(_pos_brc.get);
  app.route("/api/master/pos/branch/by-user").get(_pos_brc.getByUser);
  app.route("/api/master/pos/branch").put(_pos_brc.insert);
  app.route("/api/master/pos/branch").post(_pos_brc.update);
  app.route("/api/master/pos/branch").delete(_pos_brc.delete);
  // USER BRANCH
  var _pos_ub = require("./controller/POS/user_branch");
  app.route("/api/master/pos/user-branch").get(_pos_ub.get);
  app.route("/api/master/pos/user-branch").put(_pos_ub.insert);
  app.route("/api/master/pos/user-branch").post(_pos_ub.update);
  app.route("/api/master/pos/user-branch").delete(_pos_ub.delete);
  // DISCOUNT
  var _pos_dis = require("./controller/POS/discount");
  app.route("/api/master/pos/discount").get(_pos_dis.get);
  app.route("/api/master/pos/discount/by-user").get(_pos_dis.getByUser);
  app.route("/api/master/pos/discount").put(_pos_dis.insert);
  app.route("/api/master/pos/discount").post(_pos_dis.update);
  app.route("/api/master/pos/discount").delete(_pos_dis.delete);

  /*
  TRANSACTION
  */
  // RECEIVE
  var _pos_report = require("./controller/POS/report");
  app.route("/api/report/pos/sale").get(_pos_report.reportSale);
  app.route("/api/report/pos/sale-cashier").get(_pos_report.reportCashierSale);
  // RECEIVE
  var _pos_rec = require("./controller/POS/receive");
  app.route("/api/transaction/pos/receive").get(_pos_rec.get);
  app.route("/api/transaction/pos/receive").put(_pos_rec.insert);
  app.route("/api/transaction/pos/receive").post(_pos_rec.approve);
  // SALE
  var _pos_sale = require("./controller/POS/sale");
  app.route("/api/transaction/pos/sale").get(_pos_sale.get);
  app.route("/api/transaction/pos/sale").put(_pos_sale.newSale);
  app.route("/api/transaction/pos/sale").post(_pos_sale.updateSale);
  app.route("/api/transaction/pos/sale").delete(_pos_sale.deleteSale);
  app.route("/api/transaction/pos/sale/payment").post(_pos_sale.payment);
  // RETURN
  var _pos_ret = require("./controller/POS/return");
  app.route("/api/transaction/pos/return").get(_pos_ret.getReturn);
  app.route("/api/transaction/pos/return").put(_pos_ret.newReturn);
  app.route("/api/transaction/pos/return").post(_pos_ret.approveReturn);
  var _pos_des = require("./controller/POS/destroy");
  app.route("/api/transaction/pos/destroy").get(_pos_des.get);
  app.route("/api/transaction/pos/destroy").put(_pos_des.insert);
  app.route("/api/transaction/pos/destroy").post(_pos_des.approve);
  // CASHIER
  var _pos_cashier = require("./controller/POS/cashier");
  app.route("/api/transaction/pos/cashier").get(_pos_cashier.get);
  app.route("/api/transaction/pos/cashier").put(_pos_cashier.openCashier);
  app.route("/api/transaction/pos/cashier").post(_pos_cashier.closeCashier);
  /*
  ==========================================================================
  */
};
