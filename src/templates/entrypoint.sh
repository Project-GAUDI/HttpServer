#! /bin/sh

cat application.info

exec dotnet HttpServer.dll "$@"
