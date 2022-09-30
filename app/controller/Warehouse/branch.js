"use strict";
const response = require("../../responseV2");
const models = require("../../models");
const { humanizeText } = require("../../utils");
const { limitOffset, search, exactSearch } = require("../../model/helper");
const { WhMstBranch } = require("../../model/Warehouse/branch");

exports.get = async function (req, res) {
  var data = { rows: [req.query] };
  try {
    let body = req.query;
    let filter = {
      where: {
        ...search(body, ["name", "code", "desc"]),
        ...exactSearch(body, ["id"]),
      },
      ...limitOffset(body),
    };
    const getData = await WhMstBranch.findAndCountAll({
      ...filter,
    });
    return response.response(getData, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.insert = async function (req, res) {
  var data = { rows: [req.body] };
  try {
    let body = req.body;
    let _res = await WhMstBranch.create(body);
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.update = async function (req, res) {
  var data = { data: req.body };
  try {
    let body = req.body;
    var require_data = ["id", "code", "name"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${humanizeText(row)} is required!`);
      }
    }
    let _res = await WhMstBranch.update(body, {
      where: { id: body.id },
    });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};

exports.delete = async function (req, res) {
  var data = { data: req.body };
  try {
    let body = req.body;
    const require_data = ["id"];
    for (const row of require_data) {
      if (!body[`${row}`]) {
        throw new Error(`${humanizeText(row)} is required!`);
      }
    }
    let _res = await WhMstBranch.destroy({ where: { id: body.id } });
    return response.response(_res, res);
  } catch (error) {
    data.error = true;
    data.message = `${error}`;
    return response.response(data, res);
  }
};
