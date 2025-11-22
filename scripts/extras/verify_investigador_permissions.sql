-- ============================================
-- VERIFICAR Permisos del Rol "investigador"
-- ============================================

-- 1. Verificar que el rol existe
SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'investigador';

-- 2. Ver permisos en tablas (solo debe tener SELECT, NO usuarios)
SELECT table_name, privilege_type 
FROM information_schema.role_table_grants 
WHERE grantee = 'investigador' 
ORDER BY table_name;

-- 3. Verificar que NO tiene acceso a usuarios
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✅ Correcto: No tiene acceso a usuarios'
        ELSE '❌ ERROR: Tiene acceso a usuarios'
    END AS verificacion
FROM information_schema.role_table_grants
WHERE grantee = 'investigador' AND table_name = 'usuarios';

-- 4. Verificar que NO puede modificar
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✅ Correcto: Solo lectura (SELECT)'
        ELSE '❌ ERROR: Puede modificar - ' || string_agg(DISTINCT privilege_type, ', ')
    END AS verificacion
FROM information_schema.role_table_grants
WHERE grantee = 'investigador' 
    AND privilege_type IN ('INSERT', 'UPDATE', 'DELETE');
