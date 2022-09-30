const { DataTypes } = require("sequelize");
const { Sequel } = require("../../connection");

const WhMstBranch = Sequel.define(
  "wh_mst_branch",
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
      allowNull: false,
      unique: { msg: "This branch code is already taken." },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notNull: { msg: "Please enter branch name" } },
    },
    desc: { type: DataTypes.STRING },
    address: { type: DataTypes.STRING },
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
