FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["testProject/TestProject.csproj", "./testProject/TestProject.csproj"]
RUN dotnet restore --verbosity=normal "testProject/TestProject.csproj"

COPY . .
WORKDIR "/src/"
RUN dotnet publish testProject/TestProject.csproj --os linux --arch x64 -c Release -o /app/publish


FROM node:20.9 as node
WORKDIR /app
COPY testProject/js/package.json /app/package.json
COPY testProject/js/package-lock.json /app/package-lock.json
RUN npm install

FROM ghcr.io/sigmagmbh/dotnet-libnode-docker:latest AS libnode
FROM ubuntu/dotnet-aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
#COPY --from=node /app/node_modules /app/js/node_modules
COPY --from=libnode lib/libnode.so.115 /app/js/libnode.so.115
ENTRYPOINT ["dotnet", "/app/TestProject.dll"]
