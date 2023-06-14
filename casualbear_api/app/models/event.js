module.exports = (sequelize, DataTypes) => {
  const Event = sequelize.define("Event", {
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    selectedColor: DataTypes.INTEGER,
    iconFile: DataTypes.TEXT("long"),
  });

  return Event;
};
