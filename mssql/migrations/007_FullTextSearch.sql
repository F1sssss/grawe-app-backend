-- Setup Full-Text Search for gr_clients_all table
-- Make sure we're using the correct database
USE master;
GO

SET QUOTED_IDENTIFIER ON
GO


-- Check if the database exists, create it if not
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GRAWE_DEV')
    BEGIN
        PRINT 'Creating database GRAWE_DEV...';
        CREATE DATABASE GRAWE_DEV;
        PRINT 'Database GRAWE_DEV created successfully.';
    END
GO

-- Switch to the application database
USE GRAWE_DEV;
GO

PRINT 'Using database: ' + DB_NAME();
-- First verify full-text search is installed
PRINT 'Verifying Full-Text Search is installed...'
IF (SELECT SERVERPROPERTY('IsFullTextInstalled')) = 1
    BEGIN
        PRINT 'Full-Text Search is installed and available.'
    END
ELSE
    BEGIN
        PRINT 'ERROR: Full-Text Search is not installed.'
        RAISERROR('Full-Text Search is not installed. Please check SQL Server installation.', 16, 1)
        RETURN
    END
GO

-- Check if the computed column already exists, if not create it
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gr_clients_all') AND name = 'polisa_text')
    BEGIN
        -- Add a computed column for policy number as text
        ALTER TABLE gr_clients_all
            ADD polisa_text AS CONVERT(NVARCHAR(20), polisa) PERSISTED;

        -- Create an index on the computed column
        CREATE INDEX IX_gr_clients_all_polisa_text
            ON gr_clients_all(polisa_text);

        PRINT 'Added polisa_text column and created index';
    END
ELSE
    BEGIN
        PRINT 'Column polisa_text already exists';
    END
GO

-- Create full-text catalog if it doesn't already exist
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE name = 'ClientSearchCatalog')
    BEGIN
        CREATE FULLTEXT CATALOG ClientSearchCatalog;
        PRINT 'Created full-text catalog ClientSearchCatalog';
    END
ELSE
    BEGIN
        PRINT 'Full-text catalog ClientSearchCatalog already exists';
    END
GO

-- Check if full-text index exists and drop if it does
IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('gr_clients_all'))
    BEGIN
        DROP FULLTEXT INDEX ON gr_clients_all;
        PRINT 'Dropped existing full-text index on gr_clients_all';
    END
GO

-- Create the full-text index
CREATE FULLTEXT INDEX ON gr_clients_all
    (
     klijent LANGUAGE 1033,
     [embg/pib] LANGUAGE 1033,
     polisa_text LANGUAGE 1033
        )
    KEY INDEX PK_gr_clients_all -- Make sure this is the actual primary key of the table
    ON ClientSearchCatalog
    WITH CHANGE_TRACKING AUTO;
PRINT 'Created full-text index on gr_clients_all table';
GO

-- Verify the full-text index is created and active
SELECT
    t.name AS TableName,
    c.name AS ColumnName,
    i.is_enabled AS IsEnabled
FROM
    sys.tables t
        INNER JOIN sys.fulltext_indexes i ON t.object_id = i.object_id
        INNER JOIN sys.fulltext_index_columns ic ON i.object_id = ic.object_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE
    t.name = 'gr_clients_all';
GO