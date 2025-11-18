require('dotenv').config();
const { Sequelize } = require('sequelize');

// Try to connect using PG_URI first (Render database), fallback to individual parameters
let sequelize;

if (process.env.PG_URI) {
    // Primary: Use PostgreSQL URI from Render
    // Render databases typically require SSL, so enable it by default
    sequelize = new Sequelize(process.env.PG_URI, {
        dialect: 'postgres',
        logging: false,
        dialectOptions: {
            ssl: {
                require: true,
                rejectUnauthorized: false
            }
        }
    });
} else {
    // Fallback: Use individual connection parameters
    sequelize = new Sequelize(process.env.PG_DB, process.env.PG_USER, process.env.PG_PASS, {
        host: process.env.PG_HOST,
        port: process.env.PG_PORT || 5432,
        dialect: 'postgres',
        logging: false
    });
}

module.exports = sequelize;
