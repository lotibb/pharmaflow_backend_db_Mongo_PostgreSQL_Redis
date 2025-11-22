-- ============================================
-- SCRIPT: Demostrar Permisos de Roles
-- ============================================
-- Ejecutar este mismo script conectado como cada rol/usuario
-- Algunas queries funcionarán, otras darán error según los permisos
-- Los errores demuestran las diferencias de permisos entre roles
-- ============================================

-- Verificar con qué usuario estás conectado
SELECT current_user AS usuario_actual;

-- ============================================
-- PRUEBAS: Tabla LOTES
-- ============================================

-- 1. SELECT en lotes
SELECT * FROM public.lotes LIMIT 1;

-- 2. INSERT en lotes
INSERT INTO public.lotes ("medicamentoId", cantidad, fecha_caducidad, version) 
VALUES (1, 100, '2024-12-31', 0);

-- ============================================
-- PRUEBAS: Tabla USUARIOS
-- ============================================

-- 3. SELECT en usuarios
SELECT * FROM public.usuarios LIMIT 1;

-- 4. INSERT en usuarios
-- Nota: created_at y updated_at tienen DEFAULT, no es necesario especificarlos
INSERT INTO public.usuarios (username, password_hash, role) 
VALUES ('test_demo', 'hash', 'investigador');

-- ============================================
-- PRUEBAS: Tabla MEDICAMENTOS
-- ============================================

-- 5. SELECT en medicamentos
SELECT * FROM public.medicamentos LIMIT 1;

-- 6. INSERT en medicamentos
INSERT INTO public.medicamentos (nombre, precio_base) VALUES ('Test', 100);

-- ============================================
-- PRUEBAS: Tabla VENTAS
-- ============================================
-- Nota: Si tu tabla se llama "Venta" (mayúscula), usa public."Venta"
-- Si se llama "ventas" (minúscula), usa public.ventas

-- 7. SELECT en ventas
SELECT * FROM public."Venta" LIMIT 1;  -- O public.ventas si es minúscula

-- 8. INSERT en ventas
INSERT INTO public."Venta" ("medicamentoId", "loteId", "cantidadVendida") 
VALUES (1, 1, 10);  -- O public.ventas si es minúscula
