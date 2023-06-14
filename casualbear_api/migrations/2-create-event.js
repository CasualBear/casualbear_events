module.exports = {
  up: (queryInterface, DataTypes) => {
    return queryInterface.createTable("Events", {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      description: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      selectedColor: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      iconFile: {
        type: DataTypes.TEXT("long"),
        allowNull: false,
      },
      createdAt: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      updatedAt: {
        allowNull: false,
        type: DataTypes.DATE,
      },
    });
  },

  down: (queryInterface) => {
    return queryInterface.dropTable("Events");
  },
};
