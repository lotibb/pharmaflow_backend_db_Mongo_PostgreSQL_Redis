require('dotenv').config();
const { createClient } = require('redis');

let client;

if (process.env.REDIS_URL) {
    // Use Redis URL connection string
    client = createClient({
        url: process.env.REDIS_URL
    });
} else {
    // Use individual connection parameters
    client = createClient({
        username: process.env.REDIS_USERNAME || 'default',
        password: process.env.REDIS_PASSWORD,
        socket: {
            host: process.env.REDIS_HOST || 'localhost',
            port: process.env.REDIS_PORT || 6379
        }
    });
}

client.on('error', (err) => {
    console.error('Redis Error:', err.message);
});

module.exports = client;

