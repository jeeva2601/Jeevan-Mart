#!/bin/sh
set -eu
# Render provides PORT dynamically. Keep Tomcat's HTTP connector aligned with it.
PORT="${PORT:-8080}"
if [ ! -d /var/data ]; then
  mkdir -p /var/data 2>/dev/null || true
fi
sed -i "s/port=\"8080\"/port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml
exec catalina.sh run
