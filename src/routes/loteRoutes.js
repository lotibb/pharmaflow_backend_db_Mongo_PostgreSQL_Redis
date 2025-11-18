const express = require("express");
const router = express.Router();
const controller = require("../controllers/loteController");
const { authenticateToken: autenticarToken } = require("../middleware/authMiddleware");

router.post("/lotes", autenticarToken, controller.crear);
router.get("/lotes", autenticarToken, controller.listar);

module.exports = router;
