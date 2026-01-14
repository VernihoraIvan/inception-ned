FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y mariadb-server

COPY ./conf/55-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/startup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 3306

ENTRYPOINT ["startup.sh"]
CMD ["mariadbd"]
