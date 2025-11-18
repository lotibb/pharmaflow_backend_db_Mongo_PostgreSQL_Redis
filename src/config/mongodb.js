require('dotenv').config();
const mongoose = require('mongoose');

const MONGODB_URI = process.env.MONGODB_URI || process.env.MONDGODB_URI;

mongoose.connection.on('error', (err) => {
    console.error('MongoDB Error:', err.message);
});

async function connect() {
    if (MONGODB_URI) {
        await mongoose.connect(MONGODB_URI);
    }
}

module.exports = { mongoose, connect };

