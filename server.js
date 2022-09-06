const moment = require("moment");
const dotenv = require("dotenv");
const cors = require("cors");
const fileUpload = require("express-fileupload");
const { sqlInjectionPrevention } = require("./app/utils");
require("express-group-routes");

dotenv.config();
var express = require("express"),
  app = express(),
  port = process.env.APP_PORT,
  bodyParser = require("body-parser");

app.use(
  fileUpload({
    createParentPath: true,
  })
);
app.use(cors());
// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));

// LOAD MIDDLEWARE OAUTH
var middleware = require("./app/middleware/middleware");
app.use(async function (req, res, next) {
  // Create log for request
  let request = {
    currentTime:
      moment().format("Y-MM-D") + " " + moment().format("HH:mm:ss:SSS"),
    client_ip: req.headers["x-forwarded-for"] || req.ip,
    method: req.method,
    path: req.originalUrl,
    body: req.body,
  };
  console.log("======================================================");
  console.log(`req : ${JSON.stringify(request)}`);
  // PREVENT FROM SQL INJECTION
  if (req.method === "GET") {
    req.query = sqlInjectionPrevention(req.query);
  } else {
    req.body = sqlInjectionPrevention(req.body);
  }
  if (
    req.originalUrl == "/api/administrator/login/user" ||
    req.originalUrl.includes("/api/administrator/generate-barcode") ||
    (req.originalUrl == "/api/administrator/configuration" &&
      req.method == "GET")
  ) {
    next();
    return;
  }
  let check_token = await middleware.check_token(req, res);
  let create_log = true;
  if (check_token && req.method != "GET") {
    create_log = await middleware.create_log(req, res);
  }
  if (check_token && create_log) {
    next();
    return;
  }
});
// END MIDDLEWARE OAUTH

var routes = require("./app/routes");
routes(app);

app.listen(port);
console.log(`${process.env.APP_NAME} started on port: ${port}`);
