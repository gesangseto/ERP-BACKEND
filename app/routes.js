"use strict";

module.exports = function (app) {
  app.group("/api/administrator", (router) => {
    var user = require("./controller/Administrator/user");
    router.get("/master/user", user.get);
    router.put("/master/user", user.insert);
    router.post("/master/user", user.update);
    router.delete("/master/user", user.delete);
    var department = require("./controller/Administrator/department");
    router.get("/master/department", department.get);
    router.put("/master/department", department.insert);
    router.post("/master/department", department.update);
    router.delete("/master/department", department.delete);
    var section = require("./controller/Administrator/section");
    router.get("/master/section", section.get);
    router.put("/master/section", section.insert);
    router.post("/master/section", section.update);
    router.delete("/master/section", section.delete);
  });
};
