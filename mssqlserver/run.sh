#!/usr/bin/env bash
set -e

# ==============================================================================
# MS SQL Server 2025 Add-on - Startup Script
# ==============================================================================

bashio::log.info "Starting MS SQL Server 2025 add-on..."

# ==============================================================================
# Read configuration from Home Assistant
# ==============================================================================
ACCEPT_EULA=$(bashio::config 'accept_eula')
SA_PASSWORD=$(bashio::config 'sa_password')
MSSQL_PID=$(bashio::config 'mssql_pid')
MSSQL_DATA_DIR=$(bashio::config 'mssql_data_dir')
MSSQL_LOG_DIR=$(bashio::config 'mssql_log_dir')
MSSQL_BACKUP_DIR=$(bashio::config 'mssql_backup_dir')

# ==============================================================================
# Validate EULA acceptance
# ==============================================================================
if ! bashio::var.true "${ACCEPT_EULA}"; then
    bashio::log.error "You must accept the Microsoft SQL Server EULA to use this add-on."
    bashio::log.error "Set 'accept_eula: true' in the add-on configuration."
    bashio::log.error "EULA: https://go.microsoft.com/fwlink/?linkid=857698"
    bashio::exit.nok "EULA not accepted"
fi

bashio::log.info "EULA accepted"

# ==============================================================================
# Validate SA password
# ==============================================================================
if bashio::var.is_empty "${SA_PASSWORD}"; then
    bashio::log.error "SA password is required but not set."
    bashio::log.error "Set 'sa_password' in the add-on configuration."
    bashio::exit.nok "SA password not set"
fi

# Check password length (minimum 8 characters)
if [ ${#SA_PASSWORD} -lt 8 ]; then
    bashio::log.error "SA password must be at least 8 characters long."
    bashio::exit.nok "SA password too short"
fi

# Check password complexity (must contain at least 3 of: uppercase, lowercase, digits, symbols)
complexity_count=0
[[ "${SA_PASSWORD}" =~ [A-Z] ]] && ((complexity_count++))
[[ "${SA_PASSWORD}" =~ [a-z] ]] && ((complexity_count++))
[[ "${SA_PASSWORD}" =~ [0-9] ]] && ((complexity_count++))
[[ "${SA_PASSWORD}" =~ [^a-zA-Z0-9] ]] && ((complexity_count++))

if [ ${complexity_count} -lt 3 ]; then
    bashio::log.error "SA password does not meet complexity requirements."
    bashio::log.error "Password must contain at least 3 of the following:"
    bashio::log.error "  - Uppercase letters (A-Z)"
    bashio::log.error "  - Lowercase letters (a-z)"
    bashio::log.error "  - Digits (0-9)"
    bashio::log.error "  - Symbols (!@#$%^&*()_+-=[]{}|;:,.<>?)"
    bashio::exit.nok "SA password does not meet complexity requirements"
fi

bashio::log.info "SA password validated successfully"

# ==============================================================================
# Create data directories if they don't exist
# ==============================================================================
bashio::log.info "Creating data directories..."

if [ ! -d "${MSSQL_DATA_DIR}" ]; then
    bashio::log.info "Creating data directory: ${MSSQL_DATA_DIR}"
    if ! mkdir -p "${MSSQL_DATA_DIR}" 2>/dev/null; then
        bashio::log.error "Failed to create data directory: ${MSSQL_DATA_DIR}"
        bashio::log.error "Please ensure the /share directory has correct permissions for the mssql user (UID 10001)"
        bashio::exit.nok "Failed to create data directory"
    fi
fi

if [ ! -d "${MSSQL_LOG_DIR}" ]; then
    bashio::log.info "Creating log directory: ${MSSQL_LOG_DIR}"
    if ! mkdir -p "${MSSQL_LOG_DIR}" 2>/dev/null; then
        bashio::log.error "Failed to create log directory: ${MSSQL_LOG_DIR}"
        bashio::log.error "Please ensure the /share directory has correct permissions for the mssql user (UID 10001)"
        bashio::exit.nok "Failed to create log directory"
    fi
fi

if [ ! -d "${MSSQL_BACKUP_DIR}" ]; then
    bashio::log.info "Creating backup directory: ${MSSQL_BACKUP_DIR}"
    if ! mkdir -p "${MSSQL_BACKUP_DIR}" 2>/dev/null; then
        bashio::log.error "Failed to create backup directory: ${MSSQL_BACKUP_DIR}"
        bashio::log.error "Please ensure the /share directory has correct permissions for the mssql user (UID 10001)"
        bashio::exit.nok "Failed to create backup directory"
    fi
fi

bashio::log.info "Data directories created successfully"

# ==============================================================================
# Export environment variables for SQL Server
# ==============================================================================
export ACCEPT_EULA="Y"
export MSSQL_SA_PASSWORD="${SA_PASSWORD}"
export MSSQL_PID="${MSSQL_PID}"
export MSSQL_DATA_DIR="${MSSQL_DATA_DIR}"
export MSSQL_LOG_DIR="${MSSQL_LOG_DIR}"
export MSSQL_BACKUP_DIR="${MSSQL_BACKUP_DIR}"

# ==============================================================================
# Log startup information
# ==============================================================================
bashio::log.info "MS SQL Server 2025 configuration:"
bashio::log.info "  Edition: ${MSSQL_PID}"
bashio::log.info "  Data directory: ${MSSQL_DATA_DIR}"
bashio::log.info "  Log directory: ${MSSQL_LOG_DIR}"
bashio::log.info "  Backup directory: ${MSSQL_BACKUP_DIR}"
bashio::log.info "  Port: 1433"
bashio::log.info ""
bashio::log.info "Starting SQL Server..."

# ==============================================================================
# Start SQL Server
# ==============================================================================
exec /opt/mssql/bin/sqlservr
