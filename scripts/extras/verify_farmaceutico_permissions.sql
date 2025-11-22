-- ============================================
-- SCRIPT: Verificar Permisos del Rol "farmaceutico"
-- ============================================
-- 
-- INSTRUCCIONES:
-- 1. Conéctate a la base de datos con el usuario "usuario_farmaceutico"
-- 2. Ejecuta este script para verificar los permisos
-- 3. Los comandos permitidos deberían funcionar
-- 4. Los comandos denegados deberían dar error de permisos
--
-- ============================================

-- ============================================
-- PASO 1: Verificar información del usuario actual
-- ============================================

SELECT 
    current_user AS usuario_actual,
    session_user AS usuario_sesion,
    current_database() AS base_datos_actual;

-- Ver rol asignado
SELECT 
    r.rolname AS usuario,
    m.rolname AS rol_asignado
FROM pg_roles r
JOIN pg_auth_members am ON r.oid = am.member
JOIN pg_roles m ON am.roleid = m.oid
WHERE r.rolname = current_user;

-- ============================================
-- PASO 2: Verificar permisos otorgados al rol
-- ============================================

-- Ver todos los permisos del rol "farmaceutico"
SELECT 
    grantee AS rol,
    table_schema AS esquema,
    table_name AS tabla,
    privilege_type AS permiso,
    is_grantable AS puede_otorgar
FROM information_schema.role_table_grants
WHERE grantee = 'farmaceutico'
ORDER BY table_name, privilege_type;

-- Ver permisos en secuencias
SELECT 
    grantee AS rol,
    sequence_schema AS esquema,
    sequence_name AS secuencia,
    privilege_type AS permiso
FROM information_schema.usage_privileges
WHERE grantee = 'farmaceutico'
    AND object_type = 'SEQUENCE';

-- ============================================
-- PASO 3: PRUEBAS - OPERACIONES PERMITIDAS
-- ============================================

-- ✅ DEBE FUNCIONAR: SELECT en tabla "ventas"
SELECT '✅ PRUEBA 1: SELECT en ventas' AS prueba;
SELECT COUNT(*) AS total_ventas FROM ventas;
SELECT '✅ ÉXITO: Puedes leer ventas' AS resultado;

-- ✅ DEBE FUNCIONAR: SELECT en tabla "lotes"
SELECT '✅ PRUEBA 2: SELECT en lotes' AS prueba;
SELECT COUNT(*) AS total_lotes FROM lotes;
SELECT '✅ ÉXITO: Puedes leer lotes' AS resultado;

-- ✅ DEBE FUNCIONAR: SELECT en tabla "medicamentos"
SELECT '✅ PRUEBA 3: SELECT en medicamentos' AS prueba;
SELECT COUNT(*) AS total_medicamentos FROM medicamentos;
SELECT '✅ ÉXITO: Puedes leer medicamentos' AS resultado;

-- ✅ DEBE FUNCIONAR: INSERT en tabla "ventas"
SELECT '✅ PRUEBA 4: INSERT en ventas' AS prueba;
-- Nota: Esto requiere datos válidos. Ajusta según tus datos.
-- INSERT INTO ventas ("medicamentoId", "loteId", "cantidadVendida")
-- VALUES (1, 1, 10);
-- SELECT '✅ ÉXITO: Puedes insertar ventas' AS resultado;
SELECT '⚠️ NOTA: Descomenta el INSERT anterior para probar con datos reales' AS nota;

-- ✅ DEBE FUNCIONAR: UPDATE en tabla "lotes"
SELECT '✅ PRUEBA 5: UPDATE en lotes' AS prueba;
-- Nota: Esto requiere datos válidos. Ajusta según tus datos.
-- UPDATE lotes SET cantidad = cantidad WHERE id = 1;
-- SELECT '✅ ÉXITO: Puedes actualizar lotes' AS resultado;
SELECT '⚠️ NOTA: Descomenta el UPDATE anterior para probar con datos reales' AS nota;

-- ============================================
-- PASO 4: PRUEBAS - OPERACIONES DENEGADAS
-- ============================================

-- ❌ DEBE FALLAR: INSERT en tabla "lotes"
SELECT '❌ PRUEBA 6: INSERT en lotes (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- INSERT INTO lotes ("medicamentoId", cantidad, fecha_caducidad, version)
-- VALUES (1, 100, '2024-12-31', 0);
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: INSERT en tabla "medicamentos"
SELECT '❌ PRUEBA 7: INSERT en medicamentos (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- INSERT INTO medicamentos (nombre, precio_base) VALUES ('Test', 100.00);
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: INSERT en tabla "usuarios"
SELECT '❌ PRUEBA 8: INSERT en usuarios (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- INSERT INTO usuarios (username, password_hash, role) 
-- VALUES ('test', 'hash', 'investigador');
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: UPDATE en tabla "ventas"
SELECT '❌ PRUEBA 9: UPDATE en ventas (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- UPDATE ventas SET "cantidadVendida" = 20 WHERE id = 1;
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: UPDATE en tabla "medicamentos"
SELECT '❌ PRUEBA 10: UPDATE en medicamentos (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- UPDATE medicamentos SET nombre = 'Test' WHERE id = 1;
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: DELETE en cualquier tabla
SELECT '❌ PRUEBA 11: DELETE en ventas (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- DELETE FROM ventas WHERE id = 1;
-- Si no hay error, los permisos están incorrectos

SELECT '❌ PRUEBA 12: DELETE en lotes (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- DELETE FROM lotes WHERE id = 1;
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: CREATE TABLE
SELECT '❌ PRUEBA 13: CREATE TABLE (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- CREATE TABLE test_table (id SERIAL PRIMARY KEY);
-- Si no hay error, los permisos están incorrectos

-- ❌ DEBE FALLAR: DROP TABLE
SELECT '❌ PRUEBA 14: DROP TABLE (debe fallar)' AS prueba;
-- Descomenta la siguiente línea para ver el error:
-- DROP TABLE IF EXISTS test_table;
-- Si no hay error, los permisos están incorrectos

-- ============================================
-- PASO 5: Resumen de permisos
-- ============================================

SELECT '═══════════════════════════════════════════════════' AS separador;
SELECT 'RESUMEN DE PERMISOS DEL ROL "farmaceutico"' AS titulo;
SELECT '═══════════════════════════════════════════════════' AS separador;

SELECT 
    CASE 
        WHEN privilege_type = 'SELECT' AND table_name IN ('ventas', 'lotes', 'medicamentos') THEN '✅ PERMITIDO'
        WHEN privilege_type = 'INSERT' AND table_name = 'ventas' THEN '✅ PERMITIDO'
        WHEN privilege_type = 'UPDATE' AND table_name = 'lotes' THEN '✅ PERMITIDO'
        ELSE '❌ DENEGADO'
    END AS estado,
    table_name AS tabla,
    privilege_type AS operacion
FROM information_schema.role_table_grants
WHERE grantee = 'farmaceutico'
ORDER BY table_name, privilege_type;

-- ============================================
-- PASO 6: Verificar tablas a las que NO tiene acceso
-- ============================================

SELECT '═══════════════════════════════════════════════════' AS separador;
SELECT 'TABLAS SIN PERMISOS DE ESCRITURA' AS titulo;
SELECT '═══════════════════════════════════════════════════' AS separador;

SELECT 
    table_name AS tabla,
    CASE 
        WHEN table_name NOT IN (
            SELECT DISTINCT table_name 
            FROM information_schema.role_table_grants 
            WHERE grantee = 'farmaceutico' 
            AND privilege_type IN ('INSERT', 'UPDATE', 'DELETE')
        ) THEN '❌ Sin permisos de escritura'
        ELSE '✅ Con permisos de escritura'
    END AS estado_escritura
FROM information_schema.tables
WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
    AND table_name NOT IN ('pg_stat_statements')
ORDER BY table_name;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================

SELECT '═══════════════════════════════════════════════════' AS separador;
SELECT 'VERIFICACIÓN COMPLETA' AS titulo;
SELECT '═══════════════════════════════════════════════════' AS separador;
SELECT 'Si las pruebas permitidas funcionan y las denegadas fallan,' AS nota1;
SELECT 'entonces los permisos están correctamente configurados.' AS nota2;





