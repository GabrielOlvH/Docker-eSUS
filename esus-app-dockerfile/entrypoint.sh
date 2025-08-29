#!/bin/bash
# entrypoint.sh (VERSÃO FINAL COM MODO HEADLESS)

# Garante que o script pare se algum comando falhar
set -e

echo "O banco de dados está pronto. Iniciando a aplicação eSUS PEC em modo headless..."

# Inicia a aplicação Java com a flag para desativar a interface gráfica
# O 'exec' substitui o processo do shell pelo processo Java, o que é uma boa prática.
exec java -Djava.awt.headless=true -jar /app/esus-app.jar
