const conf_table = () => {
  return {
    paranoid: true,
    freezeTableName: true,
    updatedAt: "created_at",
    createdAt: "updated_at",
    deletedAt: "deleted_at",
  };
};
module.exports = {
  conf_table,
};
