const { DataTypes } = require('sequelize');
const sequelize = require('../../config/sql');
const Medicamento = require('./Medicamento');

const Lote = sequelize.define('Lote', {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    medicamentoId: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'medicamentos', key: 'id' } },
    cantidad: { type: DataTypes.INTEGER, allowNull: false },
    fecha_caducidad: { type: DataTypes.DATE, allowNull: false },
    version: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0 }
}, {
    tableName: 'lotes',
    timestamps: true
});

Lote.belongsTo(Medicamento, { foreignKey: 'medicamentoId' });

module.exports = Lote;
