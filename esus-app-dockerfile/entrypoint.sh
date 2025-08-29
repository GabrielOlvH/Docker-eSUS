#!/bin/bash
# entrypoint.sh para o contêiner esus-app

# Ativa o modo 'exit on error' para garantir que o script falhe se algum comando falhar.
set -e

# 1. Lógica de Espera pelo Banco de Dados
# Extrai o host e a porta do banco de dados da variável de ambiente APP_DB_URL.
# Exemplo de URL: jdbc:postgresql://esus-db:5432/esus
DB_HOST=$(echo $APP_DB_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
DB_PORT=$(echo $APP_DB_URL | sed -n 's/.*:\/\/[^:]*:\([0-9]*\).*/\1/p')

echo "Aguardando o banco de dados em ${DB_HOST}:${DB_PORT}..."

# Utiliza 'nc' (netcat) para verificar se a porta do banco de dados está aberta.
# O loop continuará até que o comando 'nc' seja bem-sucedido.
# O timeout de 1 segundo evita que o comando fique preso.
while! nc -z -w1 ${DB_HOST} ${DB_PORT}; do
  echo "Banco de dados indisponível. Tentando novamente em 2 segundos..."
  sleep 2
done

echo "Banco de dados está pronto para aceitar conexões."

# 2. Inicialização da Aplicação eSUS PEC
# Localiza o arquivo.jar principal da aplicação.
# O nome do arquivo pode variar dependendo da versão baixada.
# Este comando procura por um arquivo.jar que corresponda ao padrão.
ESUS_JAR=$(find /app -name "eSUS-AB-PEC-*.jar" | head -n 1)

if; then
  echo "ERRO: Não foi possível encontrar o arquivo.jar do eSUS PEC em /app."
  exit 1
fi

echo "Iniciando a aplicação eSUS PEC a partir de: ${ESUS_JAR}"

# Executa a aplicação Java.
# As variáveis de ambiente (APP_DB_URL, APP_DB_USER, APP_DB_PASSWORD)
# são passadas automaticamente para o processo Java.
# O 'exec' substitui o processo do shell pelo processo Java, o que é uma
# boa prática para o gerenciamento de sinais do Docker.
exec java -jar "${ESUS_JAR}"