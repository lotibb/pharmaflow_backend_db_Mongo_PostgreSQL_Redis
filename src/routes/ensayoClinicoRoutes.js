const express = require("express");
const router = express.Router();
const controller = require("../controllers/ensayoClinicoController");
const { authenticateToken: autenticarToken } = require("../middleware/authMiddleware");

// POST /api/ensayoclinicos - Registrar un nuevo reporte
router.post("/ensayoclinicos", autenticarToken, controller.registrarReporte);

// GET /api/ensayosclinicos - Obtener todos los reportes
router.get("/ensayosclinicos", autenticarToken, controller.listarReportes);

module.exports = router;

