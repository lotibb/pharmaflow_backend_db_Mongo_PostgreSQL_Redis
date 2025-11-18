-- ============================================
-- Crear Rol "farmaceutico" en PostgreSQL
-- ============================================
-- 
-- Este rol tiene permisos para:
-- - Registrar ventas (INSERT en tabla "ventas")
-- - Modificar lotes (UPDATE en tabla "lotes")
-- - Leer información necesaria (SELECT en tablas relacionadas)
--
-- INSTRUCCIONES:
-- 1. Conéctate a tu base de datos de Render como usuario principal
-- 2. Reemplaza 'NOMBRE_BASE_DATOS' con el nombre real de tu base de datos
-- 3. Ejecuta este script completo
--
-- ============================================

-- ⚠️ CONFIGURACIÓN: Cambiar el nombre de tu base de datos
\set nombre_db 'pharmaflow'  -- ⚠️ CAMBIAR por el nombre real de tu base de datos

-- ============================================
-- PASO 1: Crear el rol "farmaceutico"
-- ============================================

CREATE ROLE farmaceutico WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOINHERIT
    NOREPLICATION
    CONNECTION LIMIT -1;

-- ============================================
-- PASO 2: Otorgar permisos de conexión y esquema
-- ============================================

GRANT CONNECT ON DATABASE :nombre_db TO farmaceutico;
GRANT USAGE ON SCHEMA public TO farmaceutico;

-- ============================================
-- PASO 3: Permisos en tabla "ventas"
-- ============================================

-- INSERT: Para registrar nuevas ventas
GRANT INSERT ON TABLE public.ventas TO farmaceutico;

-- SELECT: Para poder ver las ventas existentes (útil para consultas)
GRANT SELECT ON TABLE public.ventas TO farmaceutico;

-- ============================================
-- PASO 4: Permisos en tabla "lotes"
-- ============================================

-- UPDATE: Para modificar lotes (cantidad, fecha de caducidad, etc.)
GRANT UPDATE ON TABLE public.lotes TO farmaceutico;

-- SELECT: Para poder ver los lotes antes de modificarlos
GRANT SELECT ON TABLE public.lotes TO farmaceutico;

-- ============================================
-- PASO 5: Permisos adicionales necesarios
-- ============================================

-- SELECT en medicamentos: Necesario para relacionar ventas con medicamentos
GRANT SELECT ON TABLE public.medicamentos TO farmaceutico;

-- USAGE en secuencias: Necesario para usar SERIAL (auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO farmaceutico;

-- ============================================
-- PASO 6: Asegurar permisos en objetos futuros
-- ============================================

-- Permisos en tablas futuras (si se crean nuevas tablas)
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT SELECT, INSERT ON TABLES TO farmaceutico;

-- Permisos en secuencias futuras
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT USAGE, SELECT ON SEQUENCES TO farmaceutico;

-- ============================================
-- PASO 7: Crear usuario con el rol "farmaceutico"
-- ============================================

-- ⚠️ IMPORTANTE: Cambiar la contraseña por una segura
CREATE USER usuario_farmaceutico WITH
    PASSWORD 'CambiarEstaContraseña123!'  -- ⚠️ CAMBIAR ESTA CONTRASEÑA
    IN ROLE farmaceutico;

-- ============================================
-- VERIFICACIÓN
-- ============================================

-- Verificar que el rol se creó correctamente
SELECT 
    rolname AS nombre_rol,
    rolcanlogin AS puede_conectarse,
    rolsuper AS es_superusuario
FROM pg_roles 
WHERE rolname = 'farmaceutico';

-- Verificar permisos del rol en las tablas
SELECT 
    grantee AS rol,
    table_schema AS esquema,
    table_name AS tabla,
    privilege_type AS permiso
FROM information_schema.role_table_grants
WHERE grantee = 'farmaceutico'
    AND table_name IN ('ventas', 'lotes', 'medicamentos')
ORDER BY table_name, privilege_type;

-- Verificar usuarios con este rol
SELECT 
    r.rolname AS usuario,
    m.rolname AS rol_asignado
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.member
JOIN pg_roles m ON am.roleid = m.oid
WHERE m.rolname = 'farmaceutico';

-- ============================================
-- VERSIÓN SIMPLE (sin variables, editar directamente)
-- ============================================

/*
-- Si prefieres ejecutar comandos individuales, usa esta versión:

-- 1. Crear rol
CREATE ROLE farmaceutico WITH LOGIN;

-- 2. Permisos de conexión
GRANT CONNECT ON DATABASE pharmaflow TO farmaceutico;
GRANT USAGE ON SCHEMA public TO farmaceutico;

-- 3. Permisos en ventas (INSERT y SELECT)
GRANT INSERT, SELECT ON TABLE public.ventas TO farmaceutico;

-- 4. Permisos en lotes (UPDATE y SELECT)
GRANT UPDATE, SELECT ON TABLE public.lotes TO farmaceutico;

-- 5. Permisos adicionales
GRANT SELECT ON TABLE public.medicamentos TO farmaceutico;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO farmaceutico;

-- 6. Crear usuario
CREATE USER usuario_farmaceutico WITH PASSWORD 'TuContraseñaSegura123!' IN ROLE farmaceutico;
*/

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================

-- ⚠️ Si la tabla se llama "Venta" (con mayúscula) en lugar de "ventas", 
--    cambia "ventas" por "Venta" en todos los comandos GRANT

-- ⚠️ Si necesitas que el usuario pueda eliminar ventas también, agrega:
--    GRANT DELETE ON TABLE public.ventas TO farmaceutico;

-- ⚠️ Si necesitas que el usuario pueda insertar lotes también, agrega:
--    GRANT INSERT ON TABLE public.lotes TO farmaceutico;

-- ============================================
-- ELIMINAR ROL Y USUARIO (si es necesario)
-- ============================================

/*
-- Primero eliminar el usuario
DROP USER IF EXISTS usuario_farmaceutico;

-- Luego eliminar el rol (esto revoca todos los permisos)
DROP ROLE IF EXISTS farmaceutico;
*/



