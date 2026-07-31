# 트러블슈팅

## 1. Docker 소켓 권한 오류

문제:

```bash
$ docker info
permission denied while trying to connect to the docker API at unix:///Users/haecho/.docker/run/docker.sock
```

원인: Docker CLI는 설치되어 있지만 Docker daemon에 연결하지 못했다.

추측: Docker Desktop 또는 OrbStack이 꺼져 있거나, 현재 터미널에서 Docker 소켓에 접근할 권한이 없거나, Docker context가 잘못 선택된 경우에 발생한다.

해결: Docker Desktop 또는 OrbStack을 실행한 뒤 `docker info`를 다시 실행해 Server 정보가 출력되는지 확인한다. 계속 실패하면 현재 context와 소켓 경로를 확인한다.

권한 문제가 계속되면 터미널을 새로 열거나, macOS의 경우 Docker Desktop 설정과 로그인 상태를 확인한다. Linux 환경에서는 현재 사용자를 `docker` 그룹에 추가한 뒤 다시 로그인해야 할 수 있다.

## 2. docker images 명령 인자 오류

문제:

```bash
$ docker images codyssey-e1-1-web wordpress mariadb
docker: 'docker images' requires at most 1 argument
```

원인:`docker images`는 repository 인자를 최대 1개만 받을 수 있다.

확인: 도움말 출력에 `docker images [OPTIONS] [REPOSITORY[:TAG]]` 형식이 표시되었다.

해결/대안: 전체 이미지 목록은 `docker images`로 확인하고, 특정 이미지는 한 번에 하나씩 조회한다.

```bash
docker images
docker images codyssey-e1-1-web
docker images wordpress
docker images mariadb
```
