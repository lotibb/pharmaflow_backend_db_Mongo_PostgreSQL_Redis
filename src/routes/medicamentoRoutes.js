const express = require("express");
const router = express.Router();
const controller = require("../controllers/medicamentoController");
const { authenticateToken: autenticarToken } = require("../middleware/authMiddleware");

router.post("/medicamentos", autenticarToken, controller.crear);
router.get("/medicamentos", autenticarToken, controller.listar);

module.exports = router;
