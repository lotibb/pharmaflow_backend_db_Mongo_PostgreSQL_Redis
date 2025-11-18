const { registerUser: registrarUsuario, loginUser: iniciarSesion, logoutUser: cerrarSesion, verifyToken: verificarToken } = require("../services/authService");

async function registrar(req, res) {
    try {
        const { username: nombreUsuario, password: contrasena, role: rol } = req.body;

        if (!nombreUsuario || !contrasena) {
            return res.status(400).json({ error: 'El nombre de usuario y la contraseña son requeridos' });
        }

        const resultado = await registrarUsuario(nombreUsuario, contrasena, rol);
        res.status(201).json(resultado);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
}

async function iniciarSesionControlador(req, res) {
    try {
        const { username: nombreUsuario, password: contrasena } = req.body;

        if (!nombreUsuario || !contrasena) {
            return res.status(400).json({ error: 'El nombre de usuario y la contraseña son requeridos' });
        }

        const resultado = await iniciarSesion(nombreUsuario, contrasena);
        res.json(resultado);
    } catch (error) {
        res.status(401).json({ error: error.message });
    }
}

async function cerrarSesionControlador(req, res) {
    try {
        // idUsuario es extraído por el middleware autenticarToken
        const idUsuario = req.user.userId;

        await cerrarSesion(idUsuario);
        res.json({ message: 'Sesión cerrada exitosamente' });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
}

module.exports = { 
    register: registrar, 
    login: iniciarSesionControlador, 
    logout: cerrarSesionControlador 
};

