const { DataTypes } = require("sequelize");
const { Sequel } = require("../../connection");
const { AdmSection } = require("./section");

const AdmUser = Sequel.define(
  "adm_user",
  {
    created_at: { type: DataTypes.DATE },
    updated_at: { type: DataTypes.DATE },
    deleted_at: { type: DataTypes.DATE },
    created_by: { type: DataTypes.INTEGER },
    updated_by: { type: DataTypes.INTEGER },
    status: { type: DataTypes.INTEGER },

    adm_section_id: { type: DataTypes.BIGINT, allowNull: false },

    id: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: { msg: "This email is already taken." },
      validate: {
        notNull: { msg: "Please enter email" },
        isEmail: { msg: "Please enter correct email" },
      },
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notNull: { msg: "Please enter password" } },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notNull: { msg: "Please enter name" } },
    },
    phone: {
      type: DataTypes.STRING,
      validate: { isNumeric: { msg: "Please enter correct phone" } },
    },
    address: { type: DataTypes.STRING },
  },
  {
    // paranoid: true,
    freezeTableName: true,
    updatedAt: "created_at",
    createdAt: "updated_at",
    deletedAt: "deleted_at",
  }
);
// AdmUser.sync({ force: true });

AdmUser.belongsTo(AdmSection, {
  foreignKey: "adm_section_id",
  targetKey: "id",
  as: "_adm_section",
});

module.exports = { AdmUser };
