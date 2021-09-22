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

async function encrypt({ string = null }) {
  try {
    const crypto = require('crypto');
    const secret = 'Initial-G';
    const encryptedData = crypto.createHash('sha256', secret).update(string).digest('hex');
    return encryptedData
  } catch (error) {
    console.log(error);
    return false
  }

}


module.exports = {
  nestedData,
  encrypt,

};
