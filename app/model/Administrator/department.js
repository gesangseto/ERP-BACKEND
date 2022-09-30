const { DataTypes } = require("sequelize");
const { conf_table } = require("../../../config");
const { Sequel } = require("../../connection");

const AdmDepartment = Sequel.define(
  "adm_department",
  {
    created_at: { type: DataTypes.DATE },
    updated_at: { type: DataTypes.DATE },
    deleted_at: { type: DataTypes.DATE },
    created_by: { type: DataTypes.INTEGER },
    updated_by: { type: DataTypes.INTEGER },
    status: { type: DataTypes.INTEGER },

    id: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true },
    code: {
      type: DataTypes.STRING,
      unique: { msg: "This code is already taken." },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notNull: { msg: "Please enter name" } },
    },
    desc: { type: DataTypes.STRING },
  },
  { ...conf_table() }
);
// AdmDepartment.sync({ force: true });

module.exports = { AdmDepartment };
