-- ============================================
-- SCRIPT: Verificar Usuario Actual de Conexión
-- ============================================
-- 
-- Ejecuta cualquiera de estas consultas para verificar
-- con qué usuario estás conectado a la base de datos
--
-- ============================================

-- ============================================
-- OPCIÓN 1: Información básica del usuario
-- ============================================

SELECT current_user AS usuario_actual;
SELECT session_user AS usuario_sesion;
SELECT user AS usuario;

-- ============================================
-- OPCIÓN 2: Información completa del usuario
-- ============================================

SELECT 
    current_user AS usuario_actual,
    session_user AS usuario_sesion,
    current_database() AS base_datos_actual,
    current_schema() AS esquema_actual,
    inet_server_addr() AS servidor_ip,
    inet_server_port() AS puerto_servidor;

-- ============================================
-- OPCIÓN 3: Información detallada con roles
-- ============================================

SELECT 
    current_user AS usuario_actual,
    session_user AS usuario_sesion,
    current_database() AS base_datos_actual,
    current_role AS rol_actual;

-- ============================================
-- OPCIÓN 4: Ver todos los roles asignados al usuario actual
-- ============================================

SELECT 
    r.rolname AS usuario,
    m.rolname AS rol_asignado,
    r.rolcanlogin AS puede_conectarse,
    r.rolsuper AS es_superusuario
FROM pg_roles r
LEFT JOIN pg_auth_members am ON r.oid = am.member
LEFT JOIN pg_roles m ON am.roleid = m.oid
WHERE r.rolname = current_user
ORDER BY m.rolname;

-- ============================================
-- OPCIÓN 5: Ver permisos del usuario actual
-- ============================================

SELECT 
    grantee AS usuario,
    table_schema AS esquema,
    table_name AS tabla,
    privilege_type AS permiso
FROM information_schema.role_table_grants
WHERE grantee = current_user
ORDER BY table_name, privilege_type;

-- ============================================
-- OPCIÓN 6: Ver información de conexión
-- ============================================

SELECT 
    current_user AS usuario,
    current_database() AS base_datos,
    version() AS version_postgresql;

-- ============================================
-- COMANDO RÁPIDO (una línea)
-- ============================================

-- Solo ejecuta esto:
SELECT current_user;

-- O esto para más información:
SELECT current_user, current_database();





