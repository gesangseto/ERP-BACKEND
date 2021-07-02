const dotenv = require('dotenv');
dotenv.config();
const cors = require('cors');
const fileUpload = require("express-fileupload");
var express = require('express'),
    app = express(),
    port = process.env.APP_PORT,
    bodyParser = require('body-parser');
app.use(fileUpload({
    createParentPath: true
}));
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// LOAD MIDDLEWARE OAUTH
// var oauth = require('./app/middleware/oauth')
// app.use(async function (req, res, next) {
//     if (req.originalUrl == '/bpom/bearer/get') {
//         next();
//     } else {
//         var check = await oauth.check_token(req, res);
//         if (check) {
//             next()
//         }
//     }
// })
// END MIDDLEWARE OAUTH

var routes = require('./app/routes');
routes(app);

app.listen(port);
console.log(`${process.env.APP_NAME} started on port: ${port}`);