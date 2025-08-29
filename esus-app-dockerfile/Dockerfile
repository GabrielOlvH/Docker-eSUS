#
# Dockerfile para a Aplicação eSUS PEC
#

# --- Estágio 1: Base com Java e dependências ---
FROM openjdk:8-jre-alpine AS base

# Instala pacotes essenciais para download e extração
RUN apk add --no-cache wget unzip bash

# Define o diretório de trabalho
WORKDIR /app

# --- Estágio 2: Download e Preparação ---
FROM base AS downloader

# Argumento que será recebido do docker-compose.yml
ARG URL_DOWNLOAD_ESUS

# Faz o download e renomeia o instalador para um nome padrão
RUN wget -O esus-installer.jar "${URL_DOWNLOAD_ESUS}"

# Extrai o conteúdo do .jar principal, caso seja um pacote
# O '-o' garante que os arquivos sejam sobrescritos sem pedir confirmação
RUN unzip -o esus-installer.jar 'eSUS-AB-PEC-*.jar' -d /app || echo "Unzip failed, assuming esus-installer.jar is the main executable."

# --- Estágio 3: Imagem Final ---
FROM base AS final

WORKDIR /app

# Copia o .jar extraído (ou o instalador original) do estágio anterior
COPY --from=downloader /app/eSUS-AB-PEC-*.jar ./esus-app.jar 2>/dev/null || \
    COPY --from=downloader /app/esus-installer.jar ./esus-app.jar

# Copia o script de inicialização para dentro do contêiner
COPY entrypoint.sh /entrypoint.sh

# Garante que o script de inicialização seja executável
RUN chmod +x /entrypoint.sh

# Expõe a porta padrão da aplicação eSUS
EXPOSE 8080

# Define o script de inicialização como o comando de entrada
ENTRYPOINT ["/entrypoint.sh"]
