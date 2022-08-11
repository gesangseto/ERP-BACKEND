const { log } = require("console");
const moment = require("moment");
async function nestedData({ data = [], unique = null }) {
  var reformat_obj = {};
  for (const element of data) {
    if (!reformat_obj[element[unique]]) {
      reformat_obj[element[unique]] = [element];
    } else {
      reformat_obj[element[unique]] =
        reformat_obj[element[unique]].concat(element);
    }
  }
  return reformat_obj;
}

function hasDuplicatesArray(array) {
  array = array.filter((n) => n);
  return new Set(array).size !== array.length;
}

function getFirstWord(string = String) {
  string = string.replace(/['"]+/g, "");
  string = string.split(" ");
  let str = string;
  str = str.filter((n) => n);
  return str[0];
}
function getOnlyParent(array = Array, parentAttr) {
  let _res = [];
  for (const it of array) {
    if (!it[parentAttr]) {
      _res.push(it);
    }
  }
  return _res;
}

function treeify(list, idAttr, parentAttr, childrenAttr) {
  if (!idAttr) idAttr = "id";
  if (!parentAttr) parentAttr = "parent";
  if (!childrenAttr) childrenAttr = "children";

  var treeList = [];
  var lookup = {};
  list.forEach(function (obj) {
    lookup[obj[idAttr]] = obj;
    obj[childrenAttr] = [];
  });
  list.forEach(function (obj) {
    if (obj[parentAttr] != null) {
      if (lookup[obj[parentAttr]] !== undefined) {
        lookup[obj[parentAttr]][childrenAttr].push(obj);
      } else {
        //console.log('Missing Parent Data: ' + obj[parentAttr]);
        treeList.push(obj);
      }
    } else {
      treeList.push(obj);
    }
  });
  return treeList;
}
async function encrypt({ string = null }) {
  try {
    const crypto = require("crypto");
    const secret = "Initial-G";
    const encryptedData = crypto
      .createHash("sha256", secret)
      .update(string)
      .digest("hex");
    return encryptedData;
  } catch (error) {
    console.log(error);
    return false;
  }
}

async function super_menu() {
  let super_menu = [
    // {
    //   _tag: "CSidebarNavTitle",
    //   _children: ["SYSTEM AREA"],
    // },
    {
      // _tag: "CSidebarNavDropdown",
      name: "System",
      route: "/system",
      icon: "",
      _children: [
        {
          // _tag: "CSidebarNavItem",
          name: "Configuration",
          to: "/system/configuration",
          flag_create: 1,
          flag_read: 1,
          flag_update: 1,
          flag_print: 1,
          flag_download: 1,
        },
        {
          // _tag: "CSidebarNavItem",
          name: "Audit Log",
          to: "/system/audit_log",
          flag_create: 1,
          flag_read: 1,
          flag_update: 1,
          flag_print: 1,
          flag_download: 1,
        },
        {
          // _tag: "CSidebarNavItem",
          name: "Menu Parent",
          to: "/system/menu_parent",
          flag_create: 1,
          flag_read: 1,
          flag_update: 1,
          flag_print: 1,
          flag_download: 1,
        },
        {
          // _tag: "CSidebarNavItem",
          name: "Menu Child",
          to: "/system/menu_child",
          flag_create: 1,
          flag_read: 1,
          flag_update: 1,
          flag_print: 1,
          flag_download: 1,
        },
      ],
    },
  ];
  return super_menu;
}

function isInt(value) {
  return (
    !isNaN(value) &&
    parseInt(Number(value)) == value &&
    !isNaN(parseInt(value, 20))
  );
}

function generateId() {
  return moment().format("x");
}
function percentToFloat(percent) {
  percent = isInt(percent) ? percent : 100;
  return parseInt(percent) / 100;
}

function sumByKey({ key, sum, sum2, array }) {
  let result = Object.values(
    array.reduce((map, r) => {
      if (!map[r[key]])
        map[r[key]] = { ...r, _id: r[key], qty: 0, qty_stock: 0 };
      map[r[key]][sum] += parseInt(r[sum]);
      map[r[key]][sum2] += parseInt(r[sum2]);
      return map;
    }, {})
  );
  return result;
}

function isDate(date, format = "YYYY-MM-DD hh:mm:ss") {
  let dt = moment(date).format(format);
  if (dt == "Invalid date") {
    return false;
  } else {
    return dt;
  }
}

function diffDate(date, date2) {
  let diff = moment(date2)
    .startOf("day")
    .diff(moment(date).startOf("day"), "days");
  return diff;
}
function numberPercent(num, percent) {
  num = parseFloat(isInt(num) ? num : 0);
  percent = parseFloat(isInt(percent) ? percent : 0);
  let result = num + num * (percent / 100);
  return result;
}
function isJsonString(item) {
  item = typeof item !== "string" ? JSON.stringify(item) : item;
  try {
    item = JSON.parse(item);
  } catch (e) {
    return false;
  }
  if (typeof item === "object" && item !== null) {
    return true;
  }
  return false;
}

function haveRole(item) {
  if (
    item.flag_create == 0 &&
    item.flag_delete == 0 &&
    item.flag_download == 0 &&
    item.flag_print == 0 &&
    item.flag_read == 0 &&
    item.flag_update == 0
  ) {
    return false;
  }
  return true;
}

module.exports = {
  isJsonString,
  numberPercent,
  diffDate,
  isDate,
  nestedData,
  encrypt,
  super_menu,
  isInt,
  treeify,
  hasDuplicatesArray,
  getFirstWord,
  generateId,
  percentToFloat,
  sumByKey,
  getOnlyParent,
  haveRole,
};
