const { DataTypes } = require("sequelize");
const { Sequel } = require("../../connection");
const { AdmDepartment } = require("./department");

const AdmSection = Sequel.define(
  "adm_section",
  {
    created_at: { type: DataTypes.DATE },
    updated_at: { type: DataTypes.DATE },
    deleted_at: { type: DataTypes.DATE },
    created_by: { type: DataTypes.INTEGER },
    updated_by: { type: DataTypes.INTEGER },
    status: { type: DataTypes.INTEGER },

    adm_department_id: {
      allowNull: false,
      type: DataTypes.BIGINT,
      validate: { notNull: { msg: "Please enter department" } },
    },

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
  {
    // paranoid: true,
    freezeTableName: true,
    updatedAt: "created_at",
    createdAt: "updated_at",
    deletedAt: "deleted_at",
  }
);
// AdmSection.sync({ force: true });

AdmSection.belongsTo(AdmDepartment, {
  foreignKey: "adm_department_id",
  targetKey: "id",
  as: "_adm_department",
});

module.exports = { AdmSection };
