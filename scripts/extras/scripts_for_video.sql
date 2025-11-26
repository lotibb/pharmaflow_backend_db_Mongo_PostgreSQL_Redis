CREATE ROLE farmaceutico WITH LOGIN;

-- Permisos de conexión
GRANT CONNECT ON DATABASE pharmaflow TO farmaceutico;  -- ⚠️ Cambiar 'pharmaflow' por tu base de datos
GRANT USAGE ON SCHEMA public TO farmaceutico;

-- Permisos en tabla "ventas": INSERT (registrar) y SELECT (consultar)
GRANT INSERT, SELECT ON TABLE public."Venta" TO farmaceutico;

-- Permisos en tabla "lotes": UPDATE (modificar) y SELECT (consultar)
GRANT UPDATE, SELECT ON TABLE public.lotes TO farmaceutico;

-- Permisos adicionales: SELECT en medicamentos (necesario para relaciones)
GRANT SELECT ON TABLE public.medicamentos TO farmaceutico;

-- Permisos en secuencias (necesario para auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO farmaceutico;

-- Crear usuario con contraseña
CREATE USER usuario_farmaceutico45 WITH 
    PASSWORD '123456'  -- ⚠️ CAMBIAR ESTA CONTRASEÑA
    IN ROLE farmaceutico;

-- Verificar que se creó correctamente
SELECT rolname FROM pg_roles WHERE rolname = 'farmaceutico';
SELECT rolname FROM pg_roles WHERE rolname = 'usuario_farmaceutico45';

-- ============================================
-- SCRIPT: Crear Rol "investigador" - Solo Lectura
-- ============================================
-- 
-- Permisos: Solo SELECT en medicamentos, lotes, ventas
-- NO puede ver usuarios, NO puede modificar datos
--
-- ⚠️ ANTES DE EJECUTAR:
-- 1. Reemplaza 'pharmaflow' con el nombre de tu BD
-- 2. Reemplaza 'TuPassword123!' con una contraseña segura
-- 3. Verifica el nombre de tu tabla de ventas (ventas o Venta)
--
-- ============================================

-- Crear rol investigador
CREATE ROLE investigador WITH LOGIN;

-- Permisos de conexión
GRANT CONNECT ON DATABASE pharmaflow TO investigador;  -- ⚠️ Cambiar 'pharmaflow'
GRANT USAGE ON SCHEMA public TO investigador;

-- Permisos SELECT en tablas relacionales
GRANT SELECT ON TABLE public.medicamentos TO investigador;
GRANT SELECT ON TABLE public.lotes TO investigador;
GRANT SELECT ON TABLE public."Venta" TO investigador;  -- O public."Venta" si es mayúscula

-- NO puede ver usuarios
REVOKE ALL ON TABLE public.usuarios FROM investigador;

-- NO puede modificar datos
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public FROM investigador;
REVOKE USAGE, UPDATE ON ALL SEQUENCES IN SCHEMA public FROM investigador;

-- NO puede modificar estructura
REVOKE CREATE ON SCHEMA public FROM investigador;

-- Crear usuario
CREATE USER usuario_investigador45 WITH PASSWORD '123456' IN ROLE investigador;  -- ⚠️ Cambiar contraseña

-- ============================================
-- VERIFICAR que se creó correctamente:
-- ============================================
-- Ejecuta: SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'investigador';
-- Ejecuta: SELECT table_name, privilege_type FROM information_schema.role_table_grants WHERE grantee = 'investigador';

SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'investigador';







