# Installation of simplephpapp
- Create a directory for dockerfiles and app-files (you can use any directory)
```bash
mkdir /app ; cd /app
```
- Clone repository
```bash
git clone https://github.com/Saritasa/simplephpapp.git
```
- Type cd simplephpapp to switch working directory
```bash
cd simplephpapp
```
- Run command for install composer dependencies. (You need to be patient - it will take a couple of minutes)
```bash
docker run --rm -v $(pwd):/app composer install
```
- Run command for install static dependencies.
```bash
docker run --rm -v $(pwd):/app -w /app node npm install
```
- Run command for build static scripts
```bash
docker run --rm -v $(pwd):/app -w /app node npm run production
```
- Then type command for switch directory
```bash
cd ..
```
- and create some files in the /app directory (or another directory, if you choosed another one in Step 1)
1) nginx.conf 
```bash
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        root  /var/www/app/public;
        listen       80;
        server_name  localhost;

        location / {
        index index.php index.html index.htm;
        }

        location ~ \.php$ {
            fastcgi_pass   php:9000;
            fastcgi_index  index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }
    }
}

```
2) Dockerfile (don-t forget about case sencitive)
```bash
FROM php:7.2-fpm AS php
COPY --chown=www-data:www-data ./simplephpapp /var/www/app
WORKDIR /var/www/app
RUN cp .env.example .env
RUN php artisan key:generate
```
3) Dokerfilenginx
```bash
FROM docker.io/nginx:latest AS nginx
COPY --chown=www-data:www-data ./simplephpapp/public /var/www/app/public
```
4) and the last one docker-compose.yml
```bash
services:
  nginx:
   image: nginx
   build:
    context: .
    dockerfile: Dockerfilenginx
   ports:
      - 80:80
   volumes:
     - ./nginx.conf:/etc/nginx/nginx.conf
  php:
   image: php:7.2-fpm
   build: .
```
- Then you need just build images by commands
```bash
docker-compose build php
```
```bash
docker-compose build nginx
```
- And turn containers ON by command (add -d if you want to start it in detach mode)
```bash
docker-compose up
```
--If you start containers in detach mode, you can check it by command
```bash
docker ps
```
