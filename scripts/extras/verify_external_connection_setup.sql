-- ============================================
-- SCRIPT: Verificar Configuración para Conexiones Externas
-- ============================================
-- 
-- Este script verifica si un usuario puede conectarse externamente
-- y qué configuraciones adicionales pueden ser necesarias
--
-- ============================================

-- ============================================
-- SECCIÓN 1: Verificar Usuario y Permisos de Conexión
-- ============================================

SELECT '═══════════════════════════════════════════════════════════════' AS separador;
SELECT 'VERIFICACIÓN DE USUARIO: usuario_farmaceutico45 / farmaceutico' AS titulo;
SELECT '═══════════════════════════════════════════════════════════════' AS separador;

-- Verificar si el usuario existe y puede conectarse
SELECT 
    rolname AS nombre_usuario,
    rolcanlogin AS puede_conectarse,
    CASE 
        WHEN rolcanlogin THEN '✅ SÍ - Puede iniciar sesión'
        ELSE '❌ NO - No puede iniciar sesión'
    END AS estado_login,
    rolsuper AS es_superusuario,
    rolpassword IS NOT NULL AND rolpassword != '' AS tiene_contraseña,
    CASE 
        WHEN rolpassword IS NOT NULL AND rolpassword != '' THEN '✅ SÍ'
        ELSE '❌ NO - Sin contraseña'
    END AS estado_contraseña
FROM pg_authid
WHERE rolname IN ('usuario_farmaceutico45', 'farmaceutico')
ORDER BY rolname;

-- ============================================
-- SECCIÓN 2: Verificar Permisos de Conexión a la Base de Datos
-- ============================================

SELECT '═══════════════════════════════════════════════════════════════' AS separador;
SELECT 'PERMISOS DE CONEXIÓN A LA BASE DE DATOS' AS titulo;
SELECT '═══════════════════════════════════════════════════════════════' AS separador;

SELECT 
    d.datname AS base_datos,
    r.rolname AS usuario,
    has_database_privilege(r.rolname, d.datname, 'CONNECT') AS puede_conectar,
    CASE 
        WHEN has_database_privilege(r.rolname, d.datname, 'CONNECT') THEN '✅ SÍ'
        ELSE '❌ NO'
    END AS estado_conexion
FROM pg_database d
CROSS JOIN pg_roles r
WHERE d.datname = current_database()
    AND r.rolname IN ('usuario_farmaceutico45', 'farmaceutico')
ORDER BY r.rolname;

-- ============================================
-- SECCIÓN 3: Verificar Configuración de PostgreSQL
-- ============================================

SELECT '═══════════════════════════════════════════════════════════════' AS separador;
SELECT 'CONFIGURACIÓN DE POSTGRESQL (Solo Superusuarios)' AS titulo;
SELECT '═══════════════════════════════════════════════════════════════' AS separador;

-- Verificar listen_addresses (solo superusuarios pueden ver esto)
SELECT 
    CASE 
        WHEN current_setting('is_superuser') = 'on' THEN 
            current_setting('listen_addresses')
        ELSE 
            '❌ Se requiere superusuario para ver esta configuración'
    END AS listen_addresses,
    CASE 
        WHEN current_setting('listen_addresses') = '*' THEN '✅ Escucha en todas las interfaces (permite conexiones externas)'
        WHEN current_setting('listen_addresses') LIKE '%0.0.0.0%' THEN '✅ Escucha en todas las interfaces'
        WHEN current_setting('listen_addresses') = 'localhost' THEN '⚠️ Solo localhost - NO permite conexiones externas'
        ELSE '⚠️ Verificar configuración'
    END AS interpretacion;

-- Verificar puerto
SELECT 
    current_setting('port') AS puerto_postgresql,
    CASE 
        WHEN current_setting('is_superuser') = 'on' THEN '✅ Configuración visible'
        ELSE '❌ Se requiere superusuario'
    END AS estado;

-- ============================================
-- SECCIÓN 4: Verificar pg_hba.conf (Información)
-- ============================================

SELECT '═══════════════════════════════════════════════════════════════' AS separador;
SELECT 'INFORMACIÓN SOBRE pg_hba.conf' AS titulo;
SELECT '═══════════════════════════════════════════════════════════════' AS separador;

SELECT 
    '⚠️ IMPORTANTE: pg_hba.conf controla quién puede conectarse' AS nota_1,
    'Ubicación típica en Windows: C:\Program Files\PostgreSQL\XX\data\pg_hba.conf' AS ubicacion_windows,
    'Para conexiones externas, necesita una línea como:' AS ejemplo_linea,
    'host    all    usuario_farmaceutico45    0.0.0.0/0    md5' AS ejemplo_config,
    'O para todas las IPs: host    all    all    0.0.0.0/0    md5' AS ejemplo_amplio;

-- ============================================
-- SECCIÓN 5: Resumen de Verificación
-- ============================================

SELECT '═══════════════════════════════════════════════════════════════' AS separador;
SELECT 'RESUMEN DE VERIFICACIÓN' AS titulo;
SELECT '═══════════════════════════════════════════════════════════════' AS separador;

SELECT 
    (SELECT COUNT(*) FROM pg_roles WHERE rolname IN ('usuario_farmaceutico45', 'farmaceutico') AND rolcanlogin = true) AS usuarios_con_login,
    (SELECT COUNT(*) FROM pg_roles WHERE rolname IN ('usuario_farmaceutico45', 'farmaceutico') AND rolpassword IS NOT NULL AND rolpassword != '') AS usuarios_con_contraseña,
    (SELECT COUNT(*) FROM pg_database d 
     CROSS JOIN pg_roles r 
     WHERE d.datname = current_database() 
     AND r.rolname IN ('usuario_farmaceutico45', 'farmaceutico')
     AND has_database_privilege(r.rolname, d.datname, 'CONNECT')) AS usuarios_con_permiso_conexion,
    CASE 
        WHEN current_setting('is_superuser') = 'on' THEN '✅ Puedes ver configuración completa'
        ELSE '⚠️ Conecta como superusuario para ver configuración completa'
    END AS estado_verificacion;

-- ============================================
-- CHECKLIST PARA CONEXIONES EXTERNAS
-- ============================================

SELECT '═══════════════════════════════════════════════════════════════' AS separador;
SELECT 'CHECKLIST: ¿Puede conectarse externamente?' AS titulo;
SELECT '═══════════════════════════════════════════════════════════════' AS separador;

SELECT 
    '1. Usuario existe con LOGIN' AS requisito,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname IN ('usuario_farmaceutico45', 'farmaceutico') AND rolcanlogin = true) 
        THEN '✅ CUMPLIDO'
        ELSE '❌ FALTA - Ejecutar: CREATE ROLE ... WITH LOGIN'
    END AS estado
UNION ALL
SELECT 
    '2. Usuario tiene contraseña',
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_authid WHERE rolname IN ('usuario_farmaceutico45', 'farmaceutico') AND rolpassword IS NOT NULL AND rolpassword != '') 
        THEN '✅ CUMPLIDO'
        ELSE '❌ FALTA - Ejecutar: ALTER USER ... WITH PASSWORD'
    END
UNION ALL
SELECT 
    '3. Permiso CONNECT en la base de datos',
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_database d 
            CROSS JOIN pg_roles r 
            WHERE d.datname = current_database() 
            AND r.rolname IN ('usuario_farmaceutico45', 'farmaceutico')
            AND has_database_privilege(r.rolname, d.datname, 'CONNECT')
        )
        THEN '✅ CUMPLIDO'
        ELSE '❌ FALTA - Ejecutar: GRANT CONNECT ON DATABASE ...'
    END
UNION ALL
SELECT 
    '4. pg_hba.conf permite conexiones externas',
    '⚠️ VERIFICAR MANUALMENTE - Requiere acceso al servidor'
UNION ALL
SELECT 
    '5. listen_addresses permite conexiones externas',
    CASE 
        WHEN current_setting('is_superuser') = 'on' AND (current_setting('listen_addresses') = '*' OR current_setting('listen_addresses') LIKE '%0.0.0.0%')
        THEN '✅ CUMPLIDO'
        WHEN current_setting('is_superuser') = 'on'
        THEN '❌ FALTA - Configurar listen_addresses en postgresql.conf'
        ELSE '⚠️ Verificar como superusuario'
    END
UNION ALL
SELECT 
    '6. Firewall permite puerto PostgreSQL (5432)',
    '⚠️ VERIFICAR MANUALMENTE - Configurar firewall del sistema';


