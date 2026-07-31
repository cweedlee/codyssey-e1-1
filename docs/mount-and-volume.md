# Bind Mount 및 Volume 검증

## Bind Mount

설정 위치: `compose.yaml`

```yaml
volumes:
  - ./public:/usr/share/nginx/html
```

컨테이너 내부에서 파일을 만들고, 호스트와 HTTP 응답에서 같은 내용을 확인했다.

```bash
$ docker compose exec web sh -c 'echo "bind mount updated from container" > /usr/share/nginx/html/bind-proof.txt'

$ cat public/bind-proof.txt
bind mount updated from container

$ curl -s http://localhost:8080/bind-proof.txt
bind mount updated from container
```

## Named Volume

설정 위치: `compose.yaml`

```yaml
volumes:
  - web-data:/data
  - wordpress-data:/var/www/html
  - mariadb-data:/var/lib/mysql
```

`web-data`에 파일을 만들고 컨테이너를 삭제한 뒤 다시 실행해도 데이터가 유지되는 것을 확인했다.

```bash
$ docker compose exec web sh -c 'echo "volume data survives container removal" > /data/volume-proof.txt'

$ docker compose down
Container codyssey-e1-1-web Removed
Network codyssey-e1-1_default Removed

$ docker compose up -d
Container codyssey-e1-1-web Started

$ docker compose exec web cat /data/volume-proof.txt
volume data survives container removal
```

주의: `docker compose down -v`를 실행하면 named volume도 삭제되어 데이터가 초기화된다.
