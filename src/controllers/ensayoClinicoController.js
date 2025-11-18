const {
    crearReporte,
    obtenerTodosLosReportes
} = require("../services/ensayoClinicoService");

async function registrarReporte(req, res) {
    try {
        // Obtener el usuario del token (agregado por el middleware de autenticación)
        const usuario = req.user;

        // Validar que se envíen los campos requeridos
        if (!req.body.tipo || !req.body.titulo || !req.body.datos) {
            return res.status(400).json({
                error: "Los campos tipo, titulo y datos son requeridos"
            });
        }

        const datosReporte = {
            tipo: req.body.tipo,
            titulo: req.body.titulo,
            creadoPor: usuario.nombreUsuario || usuario.id || "Usuario desconocido",
            datos: req.body.datos, // Estructura flexible
            metadata: req.body.metadata || {}
        };

        const reporte = await crearReporte(datosReporte);
        res.status(201).json({
            mensaje: "Reporte registrado exitosamente",
            reporte: reporte
        });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
}

async function listarReportes(req, res) {
    try {
        const reportes = await obtenerTodosLosReportes();
        res.json({
            total: reportes.length,
            reportes: reportes
        });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
}

module.exports = {
    registrarReporte,
    listarReportes
};

