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
  var crypto = require("crypto");
  var algorithm = "aes-192-cbc"; //algorithm to use
  var password = "Initial-G";
  const key = crypto.scryptSync(password, 'salt', 24); //create key

  const iv = crypto.randomBytes(16); // generate different ciphertext everytime
  const cipher = crypto.createCipheriv(algorithm, key, iv);
  var encrypted = cipher.update(string, 'utf8', 'hex') + cipher.final('hex'); // encrypted text
  return encrypted;
}


async function decrypt({ string = null }) {
  var crypto = require("crypto");
  var algorithm = "aes-192-cbc"; //algorithm to use
  var password = "Initial-G";
  const key = crypto.scryptSync(password, 'salt', 24); //create key

  const decipher = crypto.createDecipheriv(algorithm, key, iv);
  var decrypted = decipher.update(string, 'hex', 'utf8') + decipher.final('utf8'); //deciphered text
  return decrypted;
}


module.exports = {
  nestedData,
  encrypt,
  decrypt
};
