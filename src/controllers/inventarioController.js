const { venderLote } = require("../services/inventarioService");

async function vender(req, res) {
    const { loteId, cantidad } = req.body;

    try {
        const result = await venderLote(loteId, cantidad);
        res.json(result);
    } catch (e) {
        res.status(400).json({ error: e.message });
    }
}

module.exports = { vender };
