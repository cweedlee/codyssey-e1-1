# 터미널 조작 및 권한 실습

## 기본 조작 로그

```bash
$ mkdir -p proof-lab/dir-a
$ pwd
/Users/haecho/projects/codyssey-e1-1

$ ls -la
total 96
drwxr-xr-x  13 haecho  staff    416 Jul 31 12:31 .
drwxr-xr-x@ 41 haecho  staff   1312 Jul 31 11:53 ..
-rw-r--r--   1 haecho  staff     48 Jul 31 12:01 .dockerignore
-rw-r--r--   1 haecho  staff    157 Jul 31 12:13 .env
drwxr-xr-x  12 haecho  staff    384 Jul 31 12:18 .git
-rw-r--r--   1 haecho  staff     24 Jul 31 12:13 .gitignore
-rw-r--r--   1 haecho  staff    267 Jul 31 12:04 Dockerfile
-rw-r--r--   1 haecho  staff   8382 Jul 31 12:13 README.md
-rw-r--r--   1 haecho  staff   1374 Jul 31 12:13 compose.yaml
drwxr-xr-x   2 haecho  staff     64 Jul 31 12:16 proof
drwxr-xr-x   3 haecho  staff     96 Jul 31 12:31 proof-lab
drwxr-xr-x   5 haecho  staff    160 Jul 31 12:03 public
-rw-r--r--   1 haecho  staff  12717 Jul 31 12:16 subject

$ touch proof-lab/empty.txt
$ printf 'hello proof\n' > proof-lab/source.txt
$ cp proof-lab/source.txt proof-lab/copy.txt
$ mv proof-lab/copy.txt proof-lab/renamed.txt
$ cat proof-lab/renamed.txt
hello proof

$ rm proof-lab/empty.txt
$ ls -la proof-lab
total 16
drwxr-xr-x   5 haecho  staff  160 Jul 31 12:31 .
drwxr-xr-x  13 haecho  staff  416 Jul 31 12:31 ..
drwxr-xr-x   2 haecho  staff   64 Jul 31 12:31 dir-a
-rw-r--r--   1 haecho  staff   12 Jul 31 12:31 renamed.txt
-rw-r--r--   1 haecho  staff   12 Jul 31 12:31 source.txt
```

## 권한 변경 전후

```bash
$ ls -ld proof-lab/dir-a && ls -l proof-lab/source.txt
drwxr-xr-x  2 haecho  staff  64 Jul 31 12:31 proof-lab/dir-a
-rw-r--r--  1 haecho  staff  12 Jul 31 12:31 proof-lab/source.txt

$ chmod 700 proof-lab/dir-a && chmod 600 proof-lab/source.txt
$ ls -ld proof-lab/dir-a && ls -l proof-lab/source.txt
drwx------  2 haecho  staff  64 Jul 31 12:31 proof-lab/dir-a
-rw-------  1 haecho  staff  12 Jul 31 12:31 proof-lab/source.txt

$ chmod 755 proof-lab/dir-a && chmod 644 proof-lab/source.txt
$ ls -ld proof-lab/dir-a && ls -l proof-lab/source.txt
drwxr-xr-x  2 haecho  staff  64 Jul 31 12:31 proof-lab/dir-a
-rw-r--r--  1 haecho  staff  12 Jul 31 12:31 proof-lab/source.txt
```

## 권한 해석

- `755`: 소유자는 읽기/쓰기/실행, 그룹과 기타 사용자는 읽기/실행 가능
- `644`: 소유자는 읽기/쓰기, 그룹과 기타 사용자는 읽기 가능
- `700`: 소유자만 읽기/쓰기/실행 가능
- `600`: 소유자만 읽기/쓰기 가능
