FROM mcr.microsoft.com/mssql/server:2025-latest

# Switch to root for package installation
USER root

# Install dependencies (including gosu for privilege dropping)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    gosu \
    gnupg2 \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Install Microsoft ODBC Driver 18 for SQL Server
# The base image already includes the Microsoft APT repository (microsoft-prod.list)
# Note: ODBC Driver 17 is not available for Ubuntu 24.04, only Driver 18
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        msodbcsql18 \
        mssql-tools18 \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add sqlcmd and bcp to PATH
ENV PATH="$PATH:/opt/mssql-tools18/bin"

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
