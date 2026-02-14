FROM mcr.microsoft.com/mssql/server:2025-latest

# Switch to root for package installation
USER root

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install bashio for Home Assistant integration
RUN curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" \
    | tar -xzf - --strip 1 -C /tmp \
    && mv /tmp/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio

COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Switch back to mssql user
USER mssql

EXPOSE 1433

CMD [ "/run.sh" ]
