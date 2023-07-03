FROM apache/superset:1.3.2

# Install additional dependencies
USER root
RUN apt-get update && apt-get install -y \
    freetds-dev \
    build-essential \
    default-libmysqlclient-dev \
    libssl-dev \
    libffi-dev \
    libsasl2-dev \
    unixodbc \
    unixodbc-dev \
    freetds-bin \
    tdsodbc \
    odbcinst \
    libodbc1



# Set environment variables for MSSQL drivers
ENV ACCEPT_EULA=Y
ENV PATH="/opt/mssql-tools/bin:${PATH}"

# Install additional Python packages
USER superset
RUN pip install \
    pymssql \
    pyodbc \
    pyathena \
    cx_oracle \
    psycopg2 \
    ldap3 \
    xlrd

# Copy the docker-init.sh script to the container
COPY ./superset/docker-init.sh /app/docker-init.sh

# Set the entrypoint to run the docker-init.sh script
#ENTRYPOINT ["bash", "/app/docker-init.sh"]