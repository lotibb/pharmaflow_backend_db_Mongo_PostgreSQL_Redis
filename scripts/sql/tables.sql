CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

-- Table: medicamentos
CREATE TABLE IF NOT EXISTS medicamentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_base NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

-- Table: lotes
CREATE TABLE IF NOT EXISTS lotes (
    id SERIAL PRIMARY KEY,
    medicamentoId INTEGER NOT NULL REFERENCES medicamentos(id),
    cantidad INTEGER NOT NULL,
    fecha_caducidad DATE NOT NULL,
    version INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

-- Table: ventas
CREATE TABLE IF NOT EXISTS ventas (
    id SERIAL PRIMARY KEY,
    "medicamentoId" INTEGER NOT NULL,
    "loteId" INTEGER NOT NULL,
    "cantidadVendida" INTEGER NOT NULL,
    "fechaVenta" TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lotes_medicamento ON lotes(medicamentoId);

-- List all indexes
SELECT 
    t.schemaname AS schema_name,
    t.tablename AS table_name,
    t.indexname AS index_name,
    t.indexdef AS index_definition,
    CASE 
        WHEN i.indisunique THEN 'UNIQUE'
        WHEN i.indisprimary THEN 'PRIMARY KEY'
        ELSE 'INDEX'
    END AS index_type,
    CASE 
        WHEN i.indisunique THEN 'Sí'
        ELSE 'No'
    END AS is_unique,
    pg_size_pretty(pg_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.indexname))) AS index_size
FROM 
    pg_indexes t
    LEFT JOIN pg_index i ON i.indexrelid = (quote_ident(t.schemaname)||'.'||quote_ident(t.indexname))::regclass
WHERE 
    t.schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
    t.schemaname, t.tablename, t.indexname;
