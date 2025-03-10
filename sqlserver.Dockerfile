FROM mcr.microsoft.com/mssql/server:2019-latest

USER root

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer

RUN apt-get update
RUN apt-get install -yq gnupg gnupg2 gnupg1 curl apt-transport-https

RUN curl https://packages.microsoft.com/keys/microsoft.asc -o /var/opt/mssql/ms-key.cer
RUN apt-key add /var/opt/mssql/ms-key.cer
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list -o /etc/apt/sources.list.d/mssql-server-2019.list
RUN apt-get update

RUN apt-get install -y mssql-server-fts mssql-tools unixodbc-dev

ENV PATH="${PATH}:/opt/mssql-tools/bin"

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists

RUN mkdir -p /docker-entrypoint-initdb.d

COPY ./mssql-entrypoint.sh /
RUN chmod +x /mssql-entrypoint.sh

ENTRYPOINT ["/mssql-entrypoint.sh"]