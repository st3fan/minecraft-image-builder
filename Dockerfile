FROM openjdk:21-slim-bookworm

RUN useradd -u 1000 -d /data -m minecraft

WORKDIR /minecraft

COPY spigot.jar /minecraft/spigot.jar

RUN chmod 755 /minecraft/spigot.jar && \
    chmod -R 755 /minecraft

VOLUME ["/data"]

ENV MINECRAFT_MEMORY=4G
ENV MINECRAFT_PORT=25565

EXPOSE ${MINECRAFT_PORT}

USER minecraft

CMD ["sh", "-c", "cd /data && java -Xmx${MINECRAFT_MEMORY} -Xms${MINECRAFT_MEMORY} -jar /minecraft/spigot.jar nogui"]