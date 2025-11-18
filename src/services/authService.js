const bcrypt = require('bcrypt');
const Usuario = require('../models/sql/Usuario');
const TokenSession = require('../models/redis/TokenSession');

async function registrarUsuario(nombreUsuario, contrasena, rol = 'investigador') {
    // Verificar si el usuario ya existe
    const usuarioExistente = await Usuario.findOne({ where: { username: nombreUsuario } });
    if (usuarioExistente) {
        throw new Error('El nombre de usuario ya existe');
    }

    // Hashear la contraseña
    const hashContrasena = await bcrypt.hash(contrasena, 10);

    // Crear usuario
    const usuario = await Usuario.create({
        username: nombreUsuario,
        password_hash: hashContrasena,
        role: rol
    });

    // Generar y almacenar token JWT en Redis usando el modelo
    const token = await TokenSession.crear({
        id: usuario.id,
        username: usuario.username,
        role: usuario.role
    });

    // Retornar datos del usuario sin la contraseña
    const datosUsuario = usuario.toJSON();
    delete datosUsuario.password_hash;

    return {
        user: datosUsuario,
        token
    };
}

async function iniciarSesion(nombreUsuario, contrasena) {
    // Buscar usuario
    const usuario = await Usuario.findOne({ where: { username: nombreUsuario } });
    if (!usuario) {
        throw new Error('Usuario o contraseña incorrectos');
    }

    // Verificar contraseña
    const esContrasenaValida = await bcrypt.compare(contrasena, usuario.password_hash);
    if (!esContrasenaValida) {
        throw new Error('Usuario o contraseña incorrectos');
    }

    // Generar y almacenar token JWT en Redis usando el modelo
    const token = await TokenSession.crear({
        id: usuario.id,
        username: usuario.username,
        role: usuario.role
    });

    // Retornar datos del usuario sin la contraseña
    const datosUsuario = usuario.toJSON();
    delete datosUsuario.password_hash;

    return {
        user: datosUsuario,
        token
    };
}

async function verificarToken(token) {
    // Verificar y decodificar token usando el modelo
    return await TokenSession.verificarYDecodificar(token);
}

async function cerrarSesion(idUsuario) {
    // Eliminar token de Redis usando el modelo
    await TokenSession.eliminar(idUsuario);
}

module.exports = {
    registerUser: registrarUsuario,
    loginUser: iniciarSesion,
    verifyToken: verificarToken,
    logoutUser: cerrarSesion
};

