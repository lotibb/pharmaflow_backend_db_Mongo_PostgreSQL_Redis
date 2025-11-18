const { DataTypes } = require("sequelize");
const sequelize = require("../../config/sql");

const Venta = sequelize.define("Venta", {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },

    medicamentoId: {
        type: DataTypes.INTEGER,
        allowNull: false
    },

    loteId: {
        type: DataTypes.INTEGER,
        allowNull: false
    },

    cantidadVendida: {
        type: DataTypes.INTEGER,
        allowNull: false
    },

    fechaVenta: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    }
});

module.exports = Venta;
