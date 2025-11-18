const { crearMedicamento, obtenerMedicamentos } = require("../services/medicamentoService");

async function crear(req, res) {
    try {
        const data = await crearMedicamento(req.body);
        res.json(data);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
}

async function listar(req, res) {
    try {
        const lista = await obtenerMedicamentos();
        res.json(lista);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
}

module.exports = { crear, listar };
