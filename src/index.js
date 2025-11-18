require("dotenv").config();
const express = require("express");
const sequelize = require("./config/sql");
const redisClient = require("./config/redis");
const { mongoose, connect: connectMongoDB } = require("./config/mongodb");

const app = express();
app.use(express.json());


require("./models/sql/Medicamento");
require("./models/sql/Lote");
require("./models/sql/Venta");
require("./models/sql/Usuario");
require("./models/mongo/Reporte");

// Routes
const authRoutes = require("./routes/authRoutes");
const inventarioRoutes = require("./routes/inventarioRoutes");
const medicamentoRoutes = require("./routes/medicamentoRoutes");
const loteRoutes = require("./routes/loteRoutes");
const ventaRoutes = require("./routes/ventaRoutes");
const ensayoClinicoRoutes = require("./routes/ensayoClinicoRoutes");

// Register auth routes first to ensure priority
app.use("/api", authRoutes);
app.use("/api", inventarioRoutes);
app.use("/api", medicamentoRoutes);
app.use("/api", loteRoutes);
app.use("/api", ventaRoutes);
app.use("/api", ensayoClinicoRoutes);

const PORT = process.env.PORT || 3000;

async function start() {
    try {
        // Connect to PostgreSQL
        await sequelize.authenticate();
        console.log("PostgreSQL connected");

        // await sequelize.sync({ alter: true });
        console.log("Tables synchronisées");

        // Connect to Redis
        await redisClient.connect();
        console.log("Redis connected");

        // Connect to MongoDB
        await connectMongoDB();
        console.log("MongoDB connected");

        // Start server
        app.listen(PORT, () =>
            console.log(`API démarrée sur ${PORT}`)
        );
    } catch (err) {
        console.error("Error starting server:", err);
        process.exit(1);
    }
}



start();
