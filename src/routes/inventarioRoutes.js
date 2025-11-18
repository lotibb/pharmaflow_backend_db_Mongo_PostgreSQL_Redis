const express = require("express");
const router = express.Router();
const { vender } = require("../controllers/inventarioController");
const { authenticateToken: autenticarToken } = require("../middleware/authMiddleware");

router.post("/ventas", autenticarToken, vender);

module.exports = router;
