FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build-env
WORKDIR /app

COPY ./ ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

# busyboxイメージをビルドステージに追加
FROM busybox:1.37.0-glibc AS busybox-stage

FROM mcr.microsoft.com/dotnet/runtime:10.0-noble-chiseled-extra
WORKDIR /app
COPY --from=build-env /app/out ./

USER root
# shを使用できるようにするため、busybox(軽量sh)バイナリをビルドステージからコピー&インストール
COPY --from=busybox-stage /bin/busybox /bin/busybox
RUN ["/bin/busybox", "--install", "/bin"]

COPY templates/entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

RUN { \
    echo "module name : HttpServer"; \
    echo "module version : 7.0.1"; \
} > ./application.info

RUN useradd -ms /bin/bash moduleuser
USER moduleuser

EXPOSE 8080

LABEL org.opencontainers.image.description="HttpServer is an Azure IoT edge module that receives HTTP requests and sends them as messages."

ENTRYPOINT ["/app/entrypoint.sh"]
