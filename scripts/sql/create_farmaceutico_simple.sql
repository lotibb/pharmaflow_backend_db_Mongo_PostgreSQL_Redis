-- ============================================
-- SCRIPT SIMPLE: Crear Rol "farmaceutico" y Usuario
-- ============================================
-- 
-- ⚠️ ANTES DE EJECUTAR:
-- 1. Reemplaza 'pharmaflow' con el nombre real de tu base de datos
-- 2. Reemplaza 'TuContraseñaSegura123!' con una contraseña segura
-- 3. Ejecuta este script completo
--
-- ============================================

-- Crear el rol "farmaceutico"
CREATE ROLE farmaceutico WITH LOGIN;

-- Permisos de conexión
GRANT CONNECT ON DATABASE pharmaflow TO farmaceutico;  -- ⚠️ Cambiar 'pharmaflow' por tu base de datos
GRANT USAGE ON SCHEMA public TO farmaceutico;

-- Permisos en tabla "ventas": INSERT (registrar) y SELECT (consultar)
GRANT INSERT, SELECT ON TABLE public.ventas TO farmaceutico;

-- Permisos en tabla "lotes": UPDATE (modificar) y SELECT (consultar)
GRANT UPDATE, SELECT ON TABLE public.lotes TO farmaceutico;

-- Permisos adicionales: SELECT en medicamentos (necesario para relaciones)
GRANT SELECT ON TABLE public.medicamentos TO farmaceutico;

-- Permisos en secuencias (necesario para auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO farmaceutico;

-- Crear usuario con contraseña
CREATE USER usuario_farmaceutico WITH 
    PASSWORD 'TuContraseñaSegura123!'  -- ⚠️ CAMBIAR ESTA CONTRASEÑA
    IN ROLE farmaceutico;

-- Verificar que se creó correctamente
SELECT rolname FROM pg_roles WHERE rolname = 'farmaceutico';
SELECT rolname FROM pg_roles WHERE rolname = 'usuario_farmaceutico';



