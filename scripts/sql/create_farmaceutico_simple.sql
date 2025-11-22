-- ============================================
-- SCRIPT: Crear Rol "farmaceutico"
-- ============================================
-- 
-- Permisos: INSERT, SELECT en ventas; UPDATE, SELECT en lotes; SELECT en medicamentos
--
-- ⚠️ ANTES DE EJECUTAR:
-- 1. Reemplaza 'pharmaflow' con el nombre de tu BD
-- 2. Reemplaza '123456' con una contraseña segura
-- 3. Verifica el nombre de tu tabla de ventas (ventas o Venta)
--
-- ============================================

-- Crear rol farmaceutico
CREATE ROLE farmaceutico WITH LOGIN;

-- Permisos de conexión
GRANT CONNECT ON DATABASE pharmaflow TO farmaceutico;  -- ⚠️ Cambiar 'pharmaflow'
GRANT USAGE ON SCHEMA public TO farmaceutico;

-- Permisos en tablas
GRANT INSERT, SELECT ON TABLE public."Venta" TO farmaceutico;  -- O public.ventas
GRANT UPDATE, SELECT ON TABLE public.lotes TO farmaceutico;
GRANT SELECT ON TABLE public.medicamentos TO farmaceutico;

-- Permisos en secuencias (necesario para auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO farmaceutico;

-- Crear usuario
CREATE USER usuario_farmaceutico45 WITH PASSWORD '123456' IN ROLE farmaceutico;  -- ⚠️ Cambiar contraseña

-- ============================================
-- VERIFICAR que se creó correctamente:
-- ============================================
-- Ejecuta: SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'farmaceutico';
-- Ejecuta: SELECT table_name, privilege_type FROM information_schema.role_table_grants WHERE grantee = 'farmaceutico';






