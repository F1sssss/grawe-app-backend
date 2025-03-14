#!/bin/bash
set -e

# Start SQL Server
/opt/mssql/bin/sqlservr &
pid=$!

# Wait for SQL Server to start
echo "Waiting for SQL Server to start..."
for i in {1..90}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "SELECT 1" -C &> /dev/null; then
        echo "SQL Server started"
        break
    fi
    echo "Waiting for SQL Server to start ($i/90)..."
    sleep 1
done

# Check if SQL Server is actually running
if ! /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "SELECT 1" -C &> /dev/null; then
    echo "SQL Server failed to start in 90 seconds"
    exit 1
fi

# Initialize the database if this is the first run
if [ ! -f /var/opt/mssql/data/.initialized ]; then
    echo "Initializing database..."

    # Create the database if it doesn't exist
    echo "Creating database if it doesn't exist..."
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GRAWE_DEV') BEGIN CREATE DATABASE GRAWE_DEV; END" -C

    # Get a list of all SQL scripts and sort them numerically
    SQL_SCRIPTS=$(find /usr/src/sql -name "*.sql" | sort -V)

    # Execute each script in order
    for script in $SQL_SCRIPTS; do
        echo "Executing $script..."
        /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d GRAWE_DEV -i "$script" -C || {
            echo "Error executing $script"
            # Continue despite errors to run all scripts
            # exit 1
        }
    done

    # Mark as initialized
    touch /var/opt/mssql/data/.initialized
    echo "Database initialization complete"
else
    echo "Database already initialized, skipping initialization"
fi

# Wait for SQL Server to exit
wait $pid