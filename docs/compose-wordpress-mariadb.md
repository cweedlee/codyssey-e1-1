# Compose, WordPress, MariaDB 검증

## Compose 설정 확인

```bash
$ docker compose config
services:
  web:
    image: codyssey-e1-1-web:latest
    ports:
      - mode: ingress
        target: 80
        published: "8080"
  wordpress:
    image: wordpress:6.6-apache
    environment:
      WORDPRESS_DB_HOST: mariadb:3306
    ports:
      - mode: ingress
        target: 80
        published: "8081"
  mariadb:
    image: mariadb:11.4
    environment:
      MARIADB_DATABASE: wordpress
volumes:
  mariadb-data:
  web-data:
  wordpress-data:
```

## 실행

```bash
$ cp .env.example .env
$ docker compose up --build -d
Image wordpress:6.6-apache Pulled
Image mariadb:11.4 Pulled
Image codyssey-e1-1-web:latest Built
Container codyssey-e1-1-mariadb Started
Container codyssey-e1-1-mariadb Healthy
Container codyssey-e1-1-wordpress Started
Container codyssey-e1-1-web Started
```

## 상태 확인

```bash
$ docker compose ps
NAME                      IMAGE                      SERVICE     STATUS                    PORTS
codyssey-e1-1-mariadb     mariadb:11.4               mariadb     Up 4 minutes (healthy)   3306/tcp
codyssey-e1-1-web         codyssey-e1-1-web:latest   web         Up 4 minutes (healthy)   0.0.0.0:8080->80/tcp
codyssey-e1-1-wordpress   wordpress:6.6-apache       wordpress   Up 4 minutes             0.0.0.0:8081->80/tcp
```

## NGINX 접속 확인

```bash
$ curl -i --max-time 10 http://localhost:8080/
HTTP/1.1 200 OK
Server: nginx/1.27.5
Content-Type: text/html

<!doctype html>
<html lang="ko">
```

## WordPress 접속 확인

```bash
$ curl -I --max-time 10 http://localhost:8081/
HTTP/1.1 302 Found
Server: Apache/2.4.62 (Debian)
X-Powered-By: PHP/8.2.25
X-Redirect-By: WordPress
Location: http://localhost:8081/wp-admin/install.php
```

## WordPress와 MariaDB 연결 확인

```bash
$ docker compose exec mariadb mariadb -uwordpress -p'****' wordpress -e 'SELECT DATABASE(); SHOW TABLES;'
DATABASE()
wordpress
```

WordPress 컨테이너는 `WORDPRESS_DB_HOST=mariadb:3306`으로 DB에 연결한다. `mariadb`는 Compose 서비스 이름이며, 같은 Compose 네트워크 안에서 호스트명처럼 해석된다.
