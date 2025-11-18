const Lote = require("../models/sql/Lote");

async function crearLote(data) {
    return await Lote.create(data);
}

async function obtenerLotes() {
    return await Lote.findAll();
}

module.exports = { crearLote, obtenerLotes };
