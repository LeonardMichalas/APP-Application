FROM postgres:12.1-alpine
 
ENV POSTGRES_PASSWORD postgres
 
ENV POSTGRES_DB testdb
 
COPY ./init/init.sql /docker-entrypoint-initdb.d/
