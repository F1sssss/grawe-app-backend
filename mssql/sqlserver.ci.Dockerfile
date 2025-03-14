FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer

ENV PATH="${PATH}:/opt/mssql-tools18/bin"

USER root

# Copy the entrypoint script and make it executable
COPY mssql-entrypoint.sh /
RUN chmod +x /mssql-entrypoint.sh

# Create directory for SQL initialization scripts
RUN mkdir -p /usr/src/sql

# Copy any SQL scripts if you have them
# COPY ./sql-scripts/*.sql /usr/src/sql/

# Switch back to mssql user
USER mssql

ENTRYPOINT ["/mssql-entrypoint.sh"]