const { DataTypes } = require('sequelize');
const sequelize = require('../../config/sql');

const Usuario = sequelize.define('Usuario', {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    username: { type: DataTypes.STRING, unique: true, allowNull: false },
    password_hash: { type: DataTypes.STRING, allowNull: false },
    role: { 
        type: DataTypes.STRING, 
        allowNull: false, 
        defaultValue: 'investigador',
        validate: {
            isIn: [['gerente', 'farmaceutico', 'investigador']]
        }
    }
}, {
    tableName: 'usuarios',
    timestamps: true
});

module.exports = Usuario;
