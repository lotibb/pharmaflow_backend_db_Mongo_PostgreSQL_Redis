const jwt = require('jsonwebtoken');
const redisClient = require('../../config/redis');

// Tiempo de expiración del token JWT (24 horas en segundos)
const EXPIRACION_TOKEN = 24 * 60 * 60;

class TokenSession {
    /**
     * Crea un nuevo token de sesión para un usuario
     * @param {object} datosUsuario - Datos del usuario {id, username, role}
     * @returns {Promise<string>} Token JWT generado y almacenado en Redis
     */
    static async crear(datosUsuario) {
        const token = jwt.sign(
            {
                userId: datosUsuario.id,
                username: datosUsuario.username,
                role: datosUsuario.role
            },
            process.env.JWT_SECRET || 'your-secret-key-change-in-production',
            { expiresIn: '24h' }
        );

        const claveRedis = `token:${datosUsuario.id}`;
        await redisClient.setEx(claveRedis, EXPIRACION_TOKEN, token);
        
        return token;
    }

    /**
     * Verifica y decodifica un token JWT
     * @param {string} token - Token JWT a verificar
     * @returns {Promise<object>} Datos decodificados del token
     * @throws {Error} Si el token es inválido o expirado
     */
    static async verificarYDecodificar(token) {
        try {
            const decodificado = jwt.verify(
                token,
                process.env.JWT_SECRET || 'your-secret-key-change-in-production'
            );

            const claveRedis = `token:${decodificado.userId}`;
            const tokenAlmacenado = await redisClient.get(claveRedis);

            if (!tokenAlmacenado || tokenAlmacenado !== token) {
                throw new Error('Token no encontrado o inválido');
            }

            return decodificado;
        } catch (error) {
            if (error.message.includes('Token no encontrado')) {
                throw error;
            }
            throw new Error('Token inválido o expirado');
        }
    }

    /**
     * Elimina un token de Redis (logout)
     * @param {number} userId - ID del usuario
     * @returns {Promise<void>}
     */
    static async eliminar(userId) {
        const claveRedis = `token:${userId}`;
        await redisClient.del(claveRedis);
    }
}

module.exports = TokenSession;

