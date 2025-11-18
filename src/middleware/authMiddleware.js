const { verifyToken: verificarToken } = require("../services/authService");

async function autenticarToken(req, res, next) {
    try {
        const cabeceraAutorizacion = req.headers['authorization'];
        const token = cabeceraAutorizacion && cabeceraAutorizacion.split(' ')[1]; // Bearer TOKEN

        if (!token) {
            return res.status(401).json({ error: 'Token de acceso requerido' });
        }

        const decodificado = await verificarToken(token);
        req.user = decodificado; // Adjuntar información del usuario a la petición
        next();
    } catch (error) {
        return res.status(403).json({ error: error.message });
    }
}

module.exports = { authenticateToken: autenticarToken };

