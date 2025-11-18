const { obtenerVentas } = require("../services/ventaService");

async function listar(req, res) {
    try {
        const ventas = await obtenerVentas();
        res.json(ventas);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
}

module.exports = { listar };
