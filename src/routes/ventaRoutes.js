const express = require("express");
const router = express.Router();

const { listar } = require("../controllers/ventaController");
const { vender } = require("../controllers/inventarioController");
const { authenticateToken: autenticarToken } = require("../middleware/authMiddleware");

router.post("/ventas", autenticarToken, vender);
router.get("/ventas", autenticarToken, listar);

module.exports = router;
