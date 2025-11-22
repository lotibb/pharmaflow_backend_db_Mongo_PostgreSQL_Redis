-- ============================================
-- VERIFICAR Permisos del Rol "farmaceutico"
-- ============================================

-- 1. Verificar que el rol existe
SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'farmaceutico';

-- 2. Ver permisos en tablas
SELECT table_name, privilege_type 
FROM information_schema.role_table_grants 
WHERE grantee = 'farmaceutico' 
ORDER BY table_name, privilege_type;

-- 3. Verificar permisos específicos
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Tiene INSERT en ventas'
        ELSE '❌ NO tiene INSERT en ventas'
    END AS insert_ventas
FROM information_schema.role_table_grants
WHERE grantee = 'farmaceutico' 
    AND table_name IN ('ventas', 'Venta') 
    AND privilege_type = 'INSERT';

SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Tiene UPDATE en lotes'
        ELSE '❌ NO tiene UPDATE en lotes'
    END AS update_lotes
FROM information_schema.role_table_grants
WHERE grantee = 'farmaceutico' 
    AND table_name = 'lotes' 
    AND privilege_type = 'UPDATE';




