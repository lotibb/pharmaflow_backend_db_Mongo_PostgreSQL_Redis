const { DataTypes } = require('sequelize');
const sequelize = require('../../config/sql');

const Medicamento = sequelize.define('Medicamento', {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    nombre: { type: DataTypes.STRING, allowNull: false },
    descripcion: { type: DataTypes.TEXT },
    precio_base: { type: DataTypes.DECIMAL(10,2), allowNull: false }
}, {
    tableName: 'medicamentos',
    timestamps: true
});

module.exports = Medicamento;
