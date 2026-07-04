#!/bin/sh
# Serve the static shapez.io build on Railway's $PORT (default 8080).
set -e
: "${PORT:=8080}"

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen ${PORT} default_server;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location ~* \.(png|jpg|jpeg|gif|webp|svg|mp3|ogg|wav|woff2?|json|atlas)$ {
        expires 7d;
        add_header Cache-Control "public";
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

echo "[shapez] serving static build on :${PORT}"
exec nginx -g 'daemon off;'
