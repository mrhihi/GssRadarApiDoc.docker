FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

# 修正安裝套件時遇到的問題(badproxy)

RUN echo 'Acquire::http::Pipeline-Depth 0;' > /etc/apt/apt.conf.d/99fixbadproxy
RUN echo 'Acquire::http::No-Cache true;' >> /etc/apt/apt.conf.d/99fixbadproxy
RUN echo 'Acquire::BrokenProxy true;' >> /etc/apt/apt.conf.d/99fixbadproxy

RUN dotnet tool install -g dotnet-script
RUN apt update -y 
RUN apt install -y -q vim
RUN apt install -y asciidoctor
RUN gem install asciidoctor-pdf --pre

COPY libexec /app/libexec
COPY swagger2markup /app/swagger2markup
COPY GssRadarApiDoc /app/GssRadarApiDoc
COPY Api /app/Api

# 因為 swagger2markup 用的 jdk 是 oepnjdk 1.8 版，所以不能用 apt 安裝要另外處理
# x64 cpu 用的 jdk
COPY OpenJDK8U-x64.tar.gz /app
RUN tar -xf /app/OpenJDK8U-x64.tar.gz -C /app

# arm cpu 用的 jdk
#COPY OpenJDK8U-aarch64.tar.gz /app
#RUN tar -xf /app/OpenJDK8U-aarch64.tar.gz -C /app

ENV PATH="$PATH:/app"
RUN chmod +x /app/swagger2markup
RUN chmod +x /app/GssRadarApiDoc/1-Convert.sh
RUN chmod +x /app/GssRadarApiDoc/2-merge.sh
RUN chmod +x /app/GssRadarApiDoc/2.1-replace.csx
RUN chmod +x /app/GssRadarApiDoc/3-ToPDF.sh
RUN chmod +x /app/GssRadarApiDoc/Run.sh

ENV JAVA_HOME="/app/jdk8u432-b06"
ENV PATH=$PATH:$JAVA_HOME/bin
ENV PATH="$PATH:/root/.dotnet/tools"
