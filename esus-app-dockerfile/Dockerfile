#
# Dockerfile para a Aplicação eSUS PEC (VERSÃO FINAL COM FONTES)
#

# --- Estágio 1: Base com Java e dependências ---
FROM openjdk:8-jre-alpine AS base
LABEL maintainer="Gemini"

# Instala pacotes essenciais, incluindo fontes e o configurador de fontes
RUN apk add --no-cache wget bash ttf-dejavu fontconfig

# Define o diretório de trabalho
WORKDIR /app

# --- Estágio 2: Download ---
FROM base AS downloader

# Argumento que será recebido do docker-compose.yml
ARG URL_DOWNLOAD_ESUS

# Faz o download e renomeia o instalador para um nome padrão.
RUN wget -O esus-app.jar "${URL_DOWNLOAD_ESUS}"

# --- Estágio 3: Imagem Final ---
FROM base AS final

WORKDIR /app

# Copia o .jar baixado diretamente do estágio anterior para a imagem final.
COPY --from=downloader /app/esus-app.jar ./esus-app.jar

# Copia o script de inicialização para dentro do contêiner
COPY entrypoint.sh /entrypoint.sh

# Garante que o script de inicialização seja executável
RUN chmod +x /entrypoint.sh

# Expõe a porta padrão da aplicação eSUS
EXPOSE 8080

# Define o script de inicialização como o comando de entrada
ENTRYPOINT ["/entrypoint.sh"]
