FROM steamcmd/steamcmd AS steambuild
MAINTAINER Rebecca Wardle <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ARG APPID=1690800
ARG STEAM_BETA
ARG PORT=7777
ARG QUERY_PORT=15777
ARG BEACON_PORT=15000
ARG UID=999
ARG GID=999

ENV CONFIG_LOC="/config"
ENV SAVES_LOC="/saves"
ENV INSTALL_LOC="/satisfactory"
ENV GAME_CONFIG_LOC="/home/satisfactory/.config/Epic/FactoryGame/Saved"

# Make our config and give it to the steam user
USER root

# Setup directory structure and permissions
RUN groupadd -g ${GID} satisfactory && \
    useradd -m -s /bin/false -u ${UID} -g satisfactory satisfactory && \
    mkdir -p ${GAME_CONFIG_LOC} ${CONFIG_LOC} ${INSTALL_LOC} ${SAVES_LOC} && \
    ln -s ${SAVES_LOC} ${GAME_CONFIG_LOC}/SaveGames && \
    chown -R satisfactory:satisfactory ${INSTALL_LOC} ${CONFIG_LOC} ${SAVES_LOC} \
        /home/satisfactory/.config/Epic

USER satisfactory
ENV HOME="/home/satisfactory"

# Install the satisfactory server
RUN steamcmd \
        +login anonymous \
        +force_install_dir ${INSTALL_LOC} \
        +app_update ${APPID} ${STEAM_BETA} validate \
        +quit

COPY docker-entrypoint.sh /docker-entrypoint.sh

# I/O
VOLUME $CONFIG_LOC
EXPOSE $PORT/udp
EXPOSE $QUERY_PORT/udp
EXPOSE $BEACON_PORT/udp

# Expose and run
WORKDIR $INSTALL_LOC
VOLUME $SAVES_LOC
ENTRYPOINT /docker-entrypoint.sh