-- ============================================
-- SCRIPT: Listar Roles y Usuarios
-- ============================================
-- Ejecutar con un usuario con muchos permisos (superusuario o admin)
-- ============================================

-- 1. Todos los roles y usuarios
SELECT 
    rolname AS nombre,
    CASE 
        WHEN rolcanlogin THEN 'Usuario'
        ELSE 'Rol'
    END AS tipo,
    CASE 
        WHEN rolsuper THEN '✅ Superusuario'
        WHEN rolcanlogin THEN '✅ Puede conectarse'
        ELSE '❌ No puede conectarse'
    END AS estado
FROM pg_roles
WHERE rolname NOT IN ('pg_signal_backend')
ORDER BY rolcanlogin DESC, rolname;

-- 2. Usuarios y sus roles asignados
SELECT 
    r.rolname AS usuario,
    COALESCE(string_agg(m.rolname, ', ' ORDER BY m.rolname), 'Sin roles') AS roles_asignados
FROM pg_roles r
LEFT JOIN pg_auth_members am ON r.oid = am.member
LEFT JOIN pg_roles m ON am.roleid = m.oid
WHERE r.rolcanlogin = true
    AND r.rolname NOT IN ('pg_signal_backend')
GROUP BY r.rolname
ORDER BY r.rolname;

-- 3. Permisos por rol en tablas
SELECT 
    grantee AS rol,
    table_name AS tabla,
    string_agg(privilege_type, ', ' ORDER BY privilege_type) AS permisos
FROM information_schema.role_table_grants
WHERE grantee IN ('gerente', 'farmaceutico', 'investigador')
    AND table_schema = 'public'
GROUP BY grantee, table_name
ORDER BY grantee, table_name;

