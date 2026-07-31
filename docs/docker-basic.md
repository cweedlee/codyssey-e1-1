# Docker 기본 운영 로그

## hello-world 실행

```bash
$ docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
58dee6a49ef1: Pulling fs layer
58dee6a49ef1: Download complete
58dee6a49ef1: Pull complete
c3bdf82c34d1: Download complete
Digest: sha256:c3cbe1cc1aa588a64951ac6286e0df7b27fe2e6324b1001c619bb358770c0178
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.
```

## ubuntu 컨테이너 실행

```bash
$ docker run --rm ubuntu:24.04 sh -c 'pwd; ls; echo ubuntu-container-ok'
Unable to find image 'ubuntu:24.04' locally
24.04: Pulling from library/ubuntu
5ba1b3e1daa0: Download complete
Digest: sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90
Status: Downloaded newer image for ubuntu:24.04
/
bin
boot
dev
etc
home
lib
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
ubuntu-container-ok
```

`--rm` 옵션을 사용하면 컨테이너 종료 후 자동 삭제된다. 장시간 유지되는 컨테이너는 `docker run -d ...`로 백그라운드 실행 후 `docker exec`로 다시 진입할 수 있다.

## 이미지 목록

```bash
$ docker images
IMAGE                      ID             DISK USAGE   CONTENT SIZE   EXTRA
codyssey-e1-1-web:latest   4f8e1f331264       75.9MB         21.8MB   U
mariadb:11.4               a794d9eb009e        493MB          108MB   U
wordpress:6.6-apache       c30c1376b4d2        983MB          244MB   U
```

## 컨테이너 목록

```bash
$ docker ps -a --filter name=codyssey-e1-1
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS                    PORTS                                     NAMES
7214b58a6a9e   wordpress:6.6-apache       "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes             0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   codyssey-e1-1-wordpress
3efb12966314   codyssey-e1-1-web:latest   "/docker-entrypoint.…"   16 minutes ago   Up 16 minutes (healthy)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   codyssey-e1-1-web
cab40be0072c   mariadb:11.4               "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes (healthy)   3306/tcp                                  codyssey-e1-1-mariadb
```

## 로그 확인

```bash
$ docker compose logs --no-color --tail=12 web
codyssey-e1-1-web  | 127.0.0.1 - - [31/Jul/2026:03:30:32 +0000] "GET / HTTP/1.1" 200 922 "-" "curl/8.7.1" "-"
```

## 리소스 확인

```bash
$ docker stats --no-stream codyssey-e1-1-web codyssey-e1-1-wordpress codyssey-e1-1-mariadb
CONTAINER ID   NAME                      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
3efb12966314   codyssey-e1-1-web         0.00%     14.18MiB / 41.07GiB   0.03%     4.3kB / 4.3kB     0B / 12.3kB       19
7214b58a6a9e   codyssey-e1-1-wordpress   0.01%     65.08MiB / 41.07GiB   0.15%     80.2kB / 154kB    0B / 78.4MB       11
cab40be0072c   codyssey-e1-1-mariadb     0.01%     127.8MiB / 41.07GiB   0.30%     43.1kB / 39.6kB   17.5MB / 21.7MB   10
```
