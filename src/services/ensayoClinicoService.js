const Reporte = require("../models/mongo/Reporte");

async function crearReporte(datosReporte) {
    try {
        const reporte = new Reporte({
            tipo: datosReporte.tipo,
            titulo: datosReporte.titulo,
            creadoPor: datosReporte.creadoPor,
            datos: datosReporte.datos,
            metadata: datosReporte.metadata || {}
        });

        const reporteGuardado = await reporte.save();
        return reporteGuardado;
    } catch (error) {
        throw new Error(`Error al crear reporte: ${error.message}`);
    }
}

async function obtenerTodosLosReportes() {
    try {
        const reportes = await Reporte.find({})
            .sort({ fechaCreacion: -1 }) // Más recientes primero
            .lean(); // Retorna objetos JavaScript planos en lugar de documentos Mongoose
        
        return reportes;
    } catch (error) {
        throw new Error(`Error al obtener reportes: ${error.message}`);
    }
}

module.exports = {
    crearReporte,
    obtenerTodosLosReportes
};

