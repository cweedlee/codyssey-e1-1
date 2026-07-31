FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="test web server"

ENV APP_MODE=practice

COPY ./public /usr/share/nginx/html

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
