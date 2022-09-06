"use strict";
const response = require("../../response");
const bwipjs = require("bwip-js");
const { get_configuration } = require("../../models");
const { isJsonString } = require("../../utils");

exports.generateBarcode = async function (req, res) {
  var data = { data: req.query };
  try {
    let body = req.query || req.body;
    const { text, bcid, scale, height, includetext, textxalign } = body;
    let configuration = await get_configuration({});
    let conf = configuration.barcode_config;
    if (isJsonString(conf)) {
      conf = JSON.parse(conf);
    }

    let file = await new Promise((resolve) =>
      bwipjs
        .toBuffer({
          bcid: bcid || conf.bcid || "code128", // Barcode type
          text: text || conf.text || "NO DATA", // Text to encode
          scale: scale || conf.scale || 3, // 3x scaling factor
          height: height || conf.height || 10, // Bar height, in millimeters
          includetext: includetext || conf.includetext || false, // Show human-readable text
          textxalign: textxalign || conf.textxalign || "center", // Always good to set this
        })
        .then((png) => {
          var base_64 = Buffer.from(png, "base64");
          return resolve(base_64);
        })
        .catch((err) => {
          return resolve({ error: true, message: err.message });
        })
    );
    if (file.error) return response.response(file, res);
    res.writeHead(200, {
      "Content-Type": "image/png",
      "Content-Length": file.length,
    });
    return res.end(file);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
