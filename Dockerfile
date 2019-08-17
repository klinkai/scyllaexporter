FROM openjdk:8-alpine
LABEL maintainer="Fabio Covolo Mazzo <fabio.mazzo@klink.ai>"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV SCYLLADB_HOST **None**
ENV SCYLLADB_PORT **None**
ENV SCYLLADB_USER **None**
ENV SCYLLADB_PASSWORD **None**
ENV SCYLLADB_KEYSPACE **None**
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PATH 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
RUN mkdir /backup
WORKDIR /backup
ADD cql-exporter.jar /backup/cql-exporter.jar
ADD cql-exporter.sh /backup/cql-exporter.sh 
RUN chmod +x /backup/cql-exporter.sh
ADD run.sh /backup/run.sh
ADD backup.sh /backup/backup.sh

CMD ["sh", "run.sh"]
