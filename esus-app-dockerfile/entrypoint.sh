#!/bin/bash
# entrypoint.sh (VERSÃO FINAL SIMPLIFICADA)

# Garante que o script pare se algum comando falhar
set -e

echo "O banco de dados está pronto. Iniciando a aplicação eSUS PEC..."

# Inicia a aplicação Java
# O 'exec' substitui o processo do shell pelo processo Java, o que é uma boa prática.
exec java -jar /app/esus-app.jar
