const { Sequelize } = require("sequelize");
const Op = Sequelize.Op;

var conf = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  port: process.env.DB_PORT,
};

// Option 3: Passing parameters separately (other dialects)
const Sequel = new Sequelize(conf.database, conf.user, conf.password, {
  host: conf.host,
  dialect: "postgres" /* one of 'mysql' | 'mariadb' | 'postgres' | 'mssql' */,
  // logging: false,
});

module.exports = { Sequel, Op };
