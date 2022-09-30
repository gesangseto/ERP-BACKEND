"use strict";
const moment = require("moment");
const { removeFirstSpace } = require("./utils");

exports.response = function (data = null, res, useLog = true) {
  let msg = null;
  try {
    msg = removeFirstSpace(data.message.split(":").pop());
  } catch (error) {
    msg = "Success";
  }
  var body_res = {
    error: data.error || false,
    message: msg || "Success",
    total: data.rows ? parseInt(data.rows.length) : 0,
    grand_total: data.count ? parseInt(data.count) : 0,
    data: data.rows || [],
  };
  if (data.status_code) {
    body_res.status_code = data.status_code;
  }
  // Create Log On Response
  let _res = body_res;
  if (useLog) {
    console.log(`res : ${JSON.stringify(body_res)}`);
  } else {
    _res = {
      currentTime: body_res.currentTime,
      error: body_res.error,
      message: body_res.message,
    };
  }
  // End Create Log On Response
  res.json(_res);
  res.end();
};
