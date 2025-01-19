#!/bin/bash
set -e

# Remove o server.pid para o Rails
rm -f /app/tmp/pids/server.pid

# Executa o comando passado para o container
exec "$@"