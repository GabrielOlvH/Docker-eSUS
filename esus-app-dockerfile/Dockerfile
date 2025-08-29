# Dockerfile para a aplicação eSUS PEC

# Estágio 1: Builder - Responsável por baixar e preparar a aplicação
# Utilizamos uma imagem slim para manter o tamanho do estágio de construção reduzido.
FROM debian:bullseye-slim AS builder

# 1. Definição do Argumento de Construção
# Este argumento receberá o URL de download do eSUS PEC.jar.
# É obrigatório passá-lo durante o comando 'docker build' ou via configuração do Coolify.
ARG URL_DOWNLOAD_ESUS

# 2. Instalação de Dependências
# Instala 'wget' para baixar o arquivo e 'unzip' caso o.jar seja um autoextraível
# que precise ser descompactado (uma prática comum em instaladores Java).
# A opção --no-install-recommends evita pacotes desnecessários.
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip && \
    rm -rf /var/lib/apt/lists/*

# 3. Download e Preparação
# Define o diretório de trabalho e baixa o arquivo.jar usando o URL fornecido.
WORKDIR /app
RUN wget --progress=bar:force -O esus-installer.jar "${URL_DOWNLOAD_ESUS}"

# 4. Extração (se necessário)
# Muitos instaladores.jar são, na verdade, arquivos zip.
# Esta etapa tenta extrair o conteúdo. Se for um.jar executável simples,
# esta etapa pode falhar graciosamente ou não fazer nada, mas é uma boa prática
# para garantir que o conteúdo real da aplicação esteja disponível.
# Se a extração for bem-sucedida, o.jar principal da aplicação estará dentro.
# Se não, o próprio 'esus-installer.jar' é o executável.
RUN unzip -o esus-installer.jar |

| echo "Não foi possível extrair, assumindo que é um JAR executável."

# -----------------------------------------------------------------------------

# Estágio 2: Final - Cria a imagem de tempo de execução enxuta
# Utiliza uma imagem JRE oficial, segura e otimizada.
FROM eclipse-temurin:11-jre-focal

# 1. Configuração do Ambiente
# Define o diretório de trabalho e cria um usuário não-privilegiado para executar a aplicação.
# Executar contêineres como 'root' é uma má prática de segurança.
WORKDIR /app
RUN groupadd --gid 1000 esus && \
    useradd --uid 1000 --gid 1000 --shell /bin/bash --create-home esus

# 2. Cópia dos Artefatos
# Copia a aplicação preparada do estágio 'builder' para a imagem final.
# Também copia o script de entrypoint, que será criado separadamente.
COPY --from=builder /app/ /app/
COPY entrypoint.sh /app/entrypoint.sh

# 3. Definição de Permissões
# Garante que o usuário 'esus' tenha posse dos arquivos da aplicação e que
# o script de entrypoint seja executável.
RUN chown -R esus:esus /app && \
    chmod +x /app/entrypoint.sh

# 4. Exposição da Porta
# Expõe a porta 8080, que é a porta padrão para muitas aplicações Java
# e a porta que o eSUS PEC utiliza.
EXPOSE 8080

# 5. Configuração do Usuário e Ponto de Entrada
# Define o usuário 'esus' como o usuário padrão para executar o contêiner.
# Define o script 'entrypoint.sh' como o comando a ser executado quando o contêiner iniciar.
USER esus
ENTRYPOINT ["/app/entrypoint.sh"]