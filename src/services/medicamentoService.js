const Medicamento = require("../models/sql/Medicamento");

async function crearMedicamento(data) {
    return await Medicamento.create(data);
}

async function obtenerMedicamentos() {
    return await Medicamento.findAll();
}

module.exports = { crearMedicamento, obtenerMedicamentos };
