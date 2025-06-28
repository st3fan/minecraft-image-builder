# Minecraft Spigot Docker Image Builder

*Stefan Arentz & Claude Code, June 2025*

This repository automatically builds Docker images containing the latest Minecraft Spigot server. Instead of using the stock Minecraft server from Mojang, this project uses Spigot's BuildTools to create optimized server JARs that support plugins and enhanced server management.

## What is Spigot?

Spigot is a high-performance fork of the Minecraft server that provides:
- Plugin support through the Bukkit API
- Performance optimizations
- Additional server management features
- Better resource utilization

## How it Works

The build process uses a multi-stage Docker build:

1. **Build Stage**: Uses OpenJDK 21 JDK to run Spigot's BuildTools.jar, which downloads the official Minecraft server and transforms it into a Spigot server JAR
2. **Runtime Stage**: Uses OpenJDK 21 JRE for a smaller final image containing only the compiled Spigot server

## Manual Builds

GitHub Actions builds new images when manually triggered from the Actions tab. Images are pushed to GitHub Container Registry (GHCR).

## Usage

**Important**: This container requires a data volume to persist world data and configuration files.

Pull and run the latest image:

```bash
docker pull ghcr.io/st3fan/minecraft-image-builder:latest
docker run -p 25565:25565 -v minecraft-data:/data ghcr.io/st3fan/minecraft-image-builder:latest
```

## Data Persistence

The container uses `/data` as the working directory where Minecraft stores:
- World files
- Configuration files (server.properties, spigot.yml, etc.)
- Plugin data
- Logs

**Always mount a volume to `/data`** to persist your server data:

```bash
# Using a named volume (recommended)
docker run -p 25565:25565 -v minecraft-data:/data ghcr.io/st3fan/minecraft-image-builder:latest

# Using a host directory
docker run -p 25565:25565 -v /path/to/minecraft:/data ghcr.io/st3fan/minecraft-image-builder:latest
```

## Security Features

- Container runs as non-root user (UID 1000)
- Read-only application files - server JAR cannot be modified
- Immutable container design prevents accidental changes

## Configuration

The server supports the following environment variables:

- `MINECRAFT_MEMORY`: JVM memory allocation (default: 4G)
- `MINECRAFT_PORT`: Server port (default: 25565)

Example with custom settings:

```bash
docker run -p 8080:8080 \
  -v minecraft-data:/data \
  -e MINECRAFT_MEMORY=8G \
  -e MINECRAFT_PORT=8080 \
  ghcr.io/st3fan/minecraft-image-builder:latest
```