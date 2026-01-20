FROM debian:bookworm

EXPOSE 443

RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key \
    -out /etc/nginx/ssl/nginx-selfsigned.crt -subj "/C=DE/ST=Berlin/L=Berlin/O=42/CN=localhost"

RUN mkdir -p /var/www/html

CMD ["nginx", "-g", "daemon off;"]

