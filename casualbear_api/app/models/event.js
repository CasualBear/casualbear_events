module.exports = (sequelize, DataTypes) => {
  const Event = sequelize.define("Event", {
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    selectedColor: DataTypes.INTEGER,
    rawUrl: DataTypes.STRING,
  });

  return Event;
};
