FROM mcr.microsoft.com/mssql/server:2025-latest

# Switch to root for package installation
USER root

# Install dependencies (including gosu for privilege dropping)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Install bashio for Home Assistant integration
RUN mkdir -p /usr/lib/bashio \
    && curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" \
    | tar -xzf - --strip 2 -C /usr/lib/bashio bashio-0.16.2/lib \
    && chmod -R a+r /usr/lib/bashio \
    && chmod a+x /usr/lib/bashio/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio

COPY run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 1433

# Run as root - the entrypoint script will create directories
# and then drop privileges to mssql user for sqlservr
CMD [ "/run.sh" ]
