const Venta = require("../models/sql/Venta");

async function obtenerVentas() {
    return await Venta.findAll({
        order: [["fechaVenta", "DESC"]]
    });
}

module.exports = { obtenerVentas };
