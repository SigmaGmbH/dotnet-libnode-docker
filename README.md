# dotnet libnode docker


Docker builds for https://github.com/microsoft/node-api-dotnet/


Based on https://github.com/jasongin/nodejs

as per this comment https://github.com/microsoft/node-api-dotnet/issues/107#issuecomment-2057928923

## Usage example

This example uses https://hub.docker.com/r/ubuntu/dotnet-aspnet
image.

Image `mcr.microsoft.com/dotnet/aspnet` is known NOT to work because of GLIBC errors.

```docker
FROM ghcr.io/sigmagmbh/dotnet-libnode-docker:latest AS libnode
FROM ubuntu/dotnet-aspnet:8.0 AS final
COPY --from=libnode lib/libnode.so.115 /app/js/libnode.so.115
ENTRYPOINT ["dotnet", "/app/TestProject.dll"]
```

## Compile yourself - reproduce

This repo uses [Nix package manager](https://nixos.org/download/) for reproducible builds.
We recommend using https://github.com/DeterminateSystems/nix-installer installer to install Nix.


```bash
git clone https://github.com/SigmaGmbH/dotnet-libnode-docker
cd dotnet-libnode-docker
# Build the library itself
nix build .
# Build the docker container
nix build .#libnode-docker
docker load < result
```

## Compile yourself - docker

```bash
git clone https://github.com/SigmaGmbH/dotnet-libnode-docker
cd dotnet-libnode-docker
docker run --platform linux/amd64 --rm -it -v .:/app nixpkgs/nix-flakes nix build /app
```