-- ============================================
-- VERIFICAR Permisos del Rol "gerente"
-- ============================================

-- 1. Verificar que el rol existe
SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'gerente';

-- 2. Ver permisos en tablas
SELECT table_name, privilege_type 
FROM information_schema.role_table_grants 
WHERE grantee = 'gerente' 
ORDER BY table_name, privilege_type;

-- 3. Verificar acceso completo en lotes
SELECT 
    CASE 
        WHEN COUNT(*) >= 4 THEN '✅ Acceso completo en lotes'
        ELSE '❌ Faltan permisos en lotes'
    END AS verificacion_lotes
FROM information_schema.role_table_grants
WHERE grantee = 'gerente' 
    AND table_name = 'lotes' 
    AND privilege_type IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE');

-- 4. Verificar acceso completo en usuarios
SELECT 
    CASE 
        WHEN COUNT(*) >= 4 THEN '✅ Acceso completo en usuarios'
        ELSE '❌ Faltan permisos en usuarios'
    END AS verificacion_usuarios
FROM information_schema.role_table_grants
WHERE grantee = 'gerente' 
    AND table_name = 'usuarios' 
    AND privilege_type IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE');

