# 1. 프로젝트 개요

1. Terminal, Docker, Git을 포함하는 개발 스테이션을 만든다.

1. 웹 서버를 만들고 컨테이너화하여 조작한다.

1. bind mount를 통하여 docker 내부에서 조작한 데이터가 반영되는 것, 그리고 데이터가 유지되는 것(데이터 영속성)을 검증한다.

1. 이에 사용된 기술과 원리를 이해한다.

# 2. 실행 환경

- OS: macOS (shell: zsh, terminal: iterm) 

- Docker: `Docker version 29.4.1, build 055a478`

- Docker Compose: `Docker Compose version v5.1.3`

- git: git version 2.50.1 (Apple Git-155)

상세 실행 환경 로그: [OS](./docs/environment.md#os), [Shell](./docs/environment.md#shell), [Git](./docs/environment.md#git), [Docker](./docs/environment.md#docker)

# 3. 수행 항목 체크리스트

- [x] [터미널 조작](./docs/terminal-and-permissions.md#기본-조작-로그)
- [x] [권한 변경 실습](./docs/terminal-and-permissions.md#권한-변경-전후)
- [x] [Docker 설치/점검](./docs/environment.md#docker)
- [x] [hello-world 실행](./docs/docker-basic.md#hello-world-실행)
- [x] Dockerfile 빌드/실행
- [x] [포트 매핑 접속(2회)](./docs/compose-wordpress-mariadb.md#nginx-접속-확인)
- [x] [바인드 마운트 반영](./docs/mount-and-volume.md#bind-mount)
- [x] [볼륨 영속성](./docs/mount-and-volume.md#named-volume)
- [x] Git 설정 + VSCode GitHub 연동

# 4. 검증 방법

## bind mount 검증

> 컨테이너 외부 폴더가 컨테이너에 연결되어 있는지 확인한다.
> 상세 로그: [Bind Mount](./docs/mount-and-volume.md#bind-mount)

```bash
docker compose up --build -d
docker compose exec web sh -c 'echo "bind mount updated from container" > /usr/share/nginx/html/bind-proof.txt'
cat public/bind-proof.txt
curl http://localhost:8080/bind-proof.txt
```

## Docker 볼륨 영속성 검증

> 볼륨 영속성이란? 컨테이너가 삭제되거나 종료되어도 데이터가 사라지지 않고 안전하게 유지되는 기능. 아래에서는 외부 볼륨을 마운트해 쓰는 것으로 해결하고 있다.
> 상세 로그: [Named Volume](./docs/mount-and-volume.md#named-volume)

사용하는 외부 볼륨: `web-data`, `wordpress-data`, `mariadb-data`


```bash
docker compose up --build -d
# detach: 현재 터미널창과 분리
# build: 이미지를 새로 빌드해야 할 경우
docker compose exec web sh -c 'echo "volume data survives container removal" > /data/volume-proof.txt'
docker compose down
docker compose up -d
docker compose exec web cat /data/volume-proof.txt
docker compose down
```

## 환경 변수 활용

> 호스트 포트는 `WEB_PORT` 변수를 활용하여 바꿀 수 있다.

```bash
WEB_PORT=8090 docker compose up --build -d
# http://localhost:8090
docker compose down
```



## 터미널 조작 로그 기록

다음 작업을 터미널로 수행하고, 명령어 + 출력 결과를 기술 문서에 기록한다.
현재 위치 확인, 목록 확인(숨김 파일 포함), 이동, 생성, 복사, 이동/이름변경, 삭제
파일 내용 확인, 빈 파일 생성

상세 로그: [기본 조작 로그](./docs/terminal-and-permissions.md#기본-조작-로그)

## 권한 실습 및 증거 기록

권한을 확인/변경하는 명령을 수행하고, 변경 전/후 비교를 기술 문서에 남긴다.
최소 요구: 파일 1개, 디렉토리 1개에 대해 권한 변경 실험을 수행한다.

상세 로그: [권한 변경 전후](./docs/terminal-and-permissions.md#권한-변경-전후)

## Docker 설치 및 기본 점검

Docker 버전 확인 결과를 기록한다. (docker --version)
Docker 데몬 동작 여부 확인 결과를 기록한다. (docker info 또는 동등 점검)

상세 로그: [Docker](./docs/environment.md#docker), [Docker Daemon](./docs/environment.md#docker-daemon)

## Docker 기본 운영 명령 수행

이미지: 다운로드/목록 확인 (예: docker images)
컨테이너: 실행/중지/목록 확인 (예: docker ps, docker ps -a)
운영: 로그 확인 (예: docker logs), 리소스 확인 (예: docker stats)
수행 명령과 출력 결과를 기술 문서에 남긴다.

상세 로그: [이미지 목록](./docs/docker-basic.md#이미지-목록), [컨테이너 목록](./docs/docker-basic.md#컨테이너-목록), [로그 확인](./docs/docker-basic.md#로그-확인), [리소스 확인](./docs/docker-basic.md#리소스-확인)

## 컨테이너 실행 실습

hello-world 실행 성공을 기록한다.
ubuntu 컨테이너를 실행하고 내부 진입 후 간단 명령(예: ls, echo) 수행 결과를 기록한다.
컨테이너 종료/유지(attach/exec 등)의 차이를 스스로 관찰하고 간단히 정리한다.

상세 로그: [hello-world 실행](./docs/docker-basic.md#hello-world-실행), [ubuntu 컨테이너 실행](./docs/docker-basic.md#ubuntu-컨테이너-실행)

## 기존 Dockerfile 기반 커스텀 이미지 제작

아래 방식 중 하나를 선택하여 기존 Dockerfile/이미지 기반의 커스텀 이미지를 만든다.
(A) 웹 서버 베이스 이미지 활용(예: NGINX/Apache 등) + 정적 콘텐츠/설정만 교체
(B) Linux 베이스 이미지(예: ubuntu/alpine 등) + 기본 기능(패키지/사용자/환경변수/헬스체크 등) 추가
제작 결과는 아래 조건을 만족해야 한다.
커스텀 이미지 빌드 성공 및 컨테이너 실행 성공
기술 문서에 다음을 포함한다.
어떤 “기존 베이스(이미지/예시 Dockerfile)”를 선택했는지
내가 적용한 커스텀 포인트 각각의 목적(간단 요약)
빌드/실행 명령 + 핵심 결과(출력/스크린샷)

## 포트 매핑 및 접속 증거

브라우저 접속 화면(또는 curl 응답)을 기술 문서에 첨부한다.
Docker 볼륨 영속성 검증
Docker 볼륨을 생성하고 컨테이너에 연결한다.
컨테이너 삭제 전/후로 데이터를 확인하여 데이터가 유지됨을 증명한다.

상세 로그: [NGINX 접속 확인](./docs/compose-wordpress-mariadb.md#nginx-접속-확인), [WordPress 접속 확인](./docs/compose-wordpress-mariadb.md#wordpress-접속-확인)

## Git 설정 및 GitHub 연동

- Git 사용자 정보/기본 브랜치 설정을 완료하고 git config --list 결과를 기록한다.

- GitHub 로그인 및 저장소 연동을 완료하고, 연동 증거(스크린샷 등)를 기술 문서에 첨부한다.

상세 로그: [GitHub remote 저장소](./docs/github-integration.md#remote-저장소), [브랜치 추적 상태](./docs/github-integration.md#브랜치-추적-상태), [Git 사용자 설정](./docs/github-integration.md#git-사용자-설정)

보안 및 개인정보 보호

- 기술 문서/로그/스크린샷에 토큰, 비밀번호, 개인키, 인증 코드 등이 포함되지 않도록 마스킹한다.

- 의심되는 민감정보가 노출된 경우, 즉시 히스토리/문서에서 제거하고 재발급 절차를 수행한다 (가능한 범위에서).

# 5. 트러블슈팅

## 5-1. Docker 소켓 권한 오류

- 문제: `docker info`, `docker ps -a` 실행 시 Docker API permission denied 오류가 발생했다.
- 원인: Docker daemon이 실행 중이 아니거나, 현재 터미널에서 Docker 소켓에 접근하지 못하는 상태였다.
- 해결: Docker Desktop 또는 OrbStack 실행 상태와 Docker context를 확인한 뒤 같은 명령을 다시 실행해 정상 출력 확인.
- 상세 기록: [Docker 소켓 권한 오류](./docs/troubleshooting.md#1-docker-소켓-권한-오류)

## 5-2. docker images 명령 인자 오류

- 문제: `docker images codyssey-e1-1-web wordpress mariadb` 실행 시 인자를 1개만 받을 수 있다는 오류가 발생했다.
- 원인: `docker images`는 repository 인자를 최대 1개만 받는 명령이다.
- 해결: 전체 목록은 `docker images`, 개별 이미지는 `docker images codyssey-e1-1-web`처럼 하나씩 조회했다.
- 상세 기록: [docker images 명령 인자 오류](./docs/troubleshooting.md#2-docker-images-명령-인자-오류)

# 추가: BONUS

- [x] Docker Compose 기초
    - docker-compose.yml의 기본 구조를 학습하고, 단일 서비스를 Compose로 실행한다.
    - 컨테이너 실행 명령이 “문서화된 실행 설정”으로 바뀌는 이유
- [x] Docker Compose 멀티 컨테이너
    - 웹 서버 + (임의의 보조 서비스) 2개 이상을 Compose로 함께 실행한다.
    - 컨테이너 간 네트워크 통신이 가능한지 확인한다.
    - 네트워크/서비스 디스커버리 개념 맛보기
- [x] Compose 운영 명령어 습득
    - up, down, ps, logs를 사용해 실행/종료/상태/로그를 관리한다.
    - 운영 관점의 “상태 확인 루틴” 만들기
- [x] 환경 변수 활용
    - Dockerfile 또는 Compose에서 환경 변수를 주입해 서버 포트/모드를 바꿔본다.
    - 설정과 코드의 분리
- [x] GitHub SSH 키 설정
    - HTTPS 대신 SSH로 푸시가 가능하도록 키를 등록하고 동작을 확인한다.
        - 인증 방식 차이와 보안 습관


# 추가: 실행 방법

### docker-compose 기반 실행

상세 로그: [Compose 실행](./docs/compose-wordpress-mariadb.md#실행), [상태 확인](./docs/compose-wordpress-mariadb.md#상태-확인), [WordPress와 MariaDB 연결 확인](./docs/compose-wordpress-mariadb.md#wordpress와-mariadb-연결-확인)

```bash
cp .env.example .env
docker compose up --build -d
curl http://localhost:8080
curl -I http://localhost:8081
docker compose ps
docker compose logs web
docker compose logs wordpress
docker compose logs mariadb
docker compose down
```

- NGINX 접속: `http://localhost:8080`

- WordPress 접속: `http://localhost:8081`

- MariaDB는 외부 포트를 열지 않고 Compose 내부 네트워크에서 `mariadb:3306`으로만 접근한다.

### docker 명령어를 통한 실행

```bash
docker build -t codyssey-e1-1-web .
# -t : tag, 식별자
docker run --name codyssey-e1-1-web-manual -p 8080:80 -v "$(pwd)/public:/usr/share/nginx/html" -d codyssey-e1-1-web
curl http://localhost:8080
docker logs codyssey-e1-1-web-manual
docker stop codyssey-e1-1-web-manual
docker rm codyssey-e1-1-web-manual
```
