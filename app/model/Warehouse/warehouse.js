const { DataTypes } = require("sequelize");
const { Sequel } = require("../../connection");

const WhMstWh = Sequel.define(
  "wh_mst_wh",
  {
    created_at: { type: DataTypes.DATE },
    updated_at: { type: DataTypes.DATE },
    deleted_at: { type: DataTypes.DATE },
    created_by: { type: DataTypes.INTEGER },
    updated_by: { type: DataTypes.INTEGER },
    status: { type: DataTypes.INTEGER },

    wh_mst_branch_id: {
      type: DataTypes.BIGINT,
      primaryKey: true,
      autoIncrement: true,
    },
    wh_mst_branch_code: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: { msg: "This branch code is already taken." },
    },
    wh_mst_branch_name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notNull: {
          msg: "Please enter branch name",
        },
      },
    },
    wh_mst_branch_desc: { type: DataTypes.STRING },
    wh_mst_branch_address: { type: DataTypes.STRING },
  },
  {
    paranoid: true,
    freezeTableName: true,
    updatedAt: "created_at",
    createdAt: "updated_at",
    deletedAt: "deleted_at",
  }
);
WhMstBranch.sync({ force: true });

module.exports = { WhMstBranch };
