-- ============================================
-- SCRIPT: Crear Rol "gerente"
-- ============================================
-- 
-- Permisos: Acceso completo (SELECT, INSERT, UPDATE, DELETE) en lotes y usuarios
--
-- ⚠️ ANTES DE EJECUTAR:
-- 1. Reemplaza 'pharmaflow' con el nombre de tu BD
-- 2. Reemplaza 'TuPassword123!' con una contraseña segura
--
-- ============================================

-- Crear rol gerente
CREATE ROLE gerente WITH LOGIN;

-- Permisos de conexión
GRANT CONNECT ON DATABASE pharmaflow TO gerente;  -- ⚠️ Cambiar 'pharmaflow'
GRANT USAGE ON SCHEMA public TO gerente;

-- Permisos completos en tablas
GRANT ALL ON TABLE public.lotes TO gerente;
GRANT ALL ON TABLE public.usuarios TO gerente;

-- Permisos en secuencias (necesario para auto-increment)
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO gerente;

-- Crear usuario
CREATE USER usuario_gerente WITH PASSWORD 'TuPassword123!' IN ROLE gerente;  -- ⚠️ Cambiar contraseña

-- ============================================
-- VERIFICAR que se creó correctamente:
-- ============================================
-- Ejecuta: SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = 'gerente';
-- Ejecuta: SELECT table_name, privilege_type FROM information_schema.role_table_grants WHERE grantee = 'gerente';

