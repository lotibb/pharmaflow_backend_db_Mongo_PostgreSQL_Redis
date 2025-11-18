const express = require("express");
const router = express.Router();
const controlador = require("../controllers/authController");
const { authenticateToken: autenticarToken } = require("../middleware/authMiddleware");

router.post("/register", controlador.register);
router.post("/login", controlador.login);
router.post("/logout", autenticarToken, controlador.logout);

module.exports = router;

