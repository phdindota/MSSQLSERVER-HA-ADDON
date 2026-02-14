ARG BUILD_FROM
FROM mcr.microsoft.com/mssql/server:2025-latest

# Add bashio for Home Assistant integration
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install bashio
RUN curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v0.16.2.tar.gz" \
    | tar -xzf - --strip 1 -C /tmp \
    && mv /tmp/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio

COPY run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 1433

CMD [ "/run.sh" ]
