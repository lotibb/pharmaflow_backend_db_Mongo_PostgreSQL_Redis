
-- OPTION 1: Generate DROP CONSTRAINT statements (review first, then copy and execute)
SELECT 'ALTER TABLE public.' || quote_ident(tablename) || ' DROP CONSTRAINT IF EXISTS ' || quote_ident(indexname) || ';' AS drop_command
FROM pg_indexes 
WHERE schemaname = 'public' 
AND indexname ~ '.*_key\d+$'  -- Matches indexes ending with _key followed by numbers
AND indexname NOT LIKE '%_pkey'  -- Don't delete primary keys
ORDER BY tablename, indexname;

-- OPTION 2: Execute directly - Drops constraints (not indexes)
DO $$
DECLARE
    idx_record RECORD;
BEGIN
    FOR idx_record IN 
        SELECT tablename, indexname
        FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND indexname ~ '.*_key\d+$'
        AND indexname NOT LIKE '%_pkey'
    LOOP
        BEGIN
            EXECUTE 'ALTER TABLE public.' || quote_ident(idx_record.tablename) || ' DROP CONSTRAINT IF EXISTS ' || quote_ident(idx_record.indexname);
            RAISE NOTICE 'Dropped constraint: %.%', idx_record.tablename, idx_record.indexname;
        EXCEPTION
            WHEN OTHERS THEN
                -- If constraint drop fails, try dropping as index
                BEGIN
                    EXECUTE 'DROP INDEX IF EXISTS public.' || quote_ident(idx_record.indexname);
                    RAISE NOTICE 'Dropped index: %', idx_record.indexname;
                EXCEPTION
                    WHEN OTHERS THEN
                        RAISE NOTICE 'Could not drop: % - %', idx_record.indexname, SQLERRM;
                END;
        END;
    END LOOP;
END $$;


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
