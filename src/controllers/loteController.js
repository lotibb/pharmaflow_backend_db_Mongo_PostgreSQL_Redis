const { crearLote, obtenerLotes } = require("../services/loteService");

async function crear(req, res) {
    try {
        const data = await crearLote(req.body);
        res.json(data);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
}

async function listar(req, res) {
    try {
        const lista = await obtenerLotes();
        res.json(lista);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
}

module.exports = { crear, listar };
