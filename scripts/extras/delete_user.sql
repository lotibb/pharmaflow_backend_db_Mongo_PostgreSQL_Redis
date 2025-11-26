-- ============================================
-- SCRIPT: Eliminar Usuario/Rol de PostgreSQL
-- ============================================
-- Ejecutar con un usuario con permisos de superusuario o CREATEROLE
-- ============================================
-- INSTRUCCIONES:
-- Reemplazar 'nombre_usuario' con el nombre del usuario/rol a eliminar
-- ============================================

-- 0. Primero, listar todos los usuarios/roles para verificar el nombre exacto
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

-- 1. Eliminar usuario/rol de PostgreSQL (búsqueda case-insensitive)
DO $$
DECLARE
    usuario_nombre VARCHAR(255) := 'usuario123_farmaceutico'; -- CAMBIAR AQUÍ
    usuario_existe BOOLEAN;
    usuario_real VARCHAR(255);
    tiene_objetos BOOLEAN;
BEGIN
    -- Buscar el usuario/rol (case-insensitive)
    SELECT rolname INTO usuario_real 
    FROM pg_roles 
    WHERE LOWER(rolname) = LOWER(usuario_nombre)
    LIMIT 1;
    
    -- Verificar si el usuario/rol existe
    usuario_existe := (usuario_real IS NOT NULL);
    
    IF NOT usuario_existe THEN
        RAISE NOTICE 'El usuario/rol "%" no existe en PostgreSQL.', usuario_nombre;
        RAISE NOTICE 'Usuarios/roles disponibles (ver lista arriba)';
        RETURN;
    END IF;
    
    -- Verificar si el rol tiene objetos asociados
    SELECT EXISTS(
        SELECT 1 FROM pg_database WHERE datdba = (SELECT oid FROM pg_roles WHERE rolname = usuario_real)
        UNION
        SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tableowner = usuario_real
    ) INTO tiene_objetos;
    
    -- Mostrar información del usuario antes de eliminar
    RAISE NOTICE 'Usuario/rol encontrado: "%"', usuario_real;
    IF tiene_objetos THEN
        RAISE WARNING 'El usuario/rol "%" puede tener objetos asociados. Se eliminará con CASCADE si es necesario.', usuario_real;
    END IF;
    RAISE NOTICE 'Eliminando usuario/rol: %', usuario_real;
    
    -- Eliminar el usuario/rol usando el nombre real (case-sensitive)
    -- DROP ROLE elimina tanto usuarios como roles
    EXECUTE format('DROP ROLE IF EXISTS %I', usuario_real);
    
    RAISE NOTICE 'Usuario/rol "%" eliminado exitosamente.', usuario_real;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al eliminar el usuario/rol "%": %', usuario_real, SQLERRM;
        RAISE NOTICE 'Intenta eliminar manualmente con: DROP ROLE %I CASCADE;', usuario_real;
END $$;

-- 2. Verificación: Listar usuarios/roles restantes
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

