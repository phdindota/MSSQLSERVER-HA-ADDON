# Changelog

## 1.2.1

### Fixed
- **Docker Build**: Fixed Docker build failure with `gpg: cannot open '/dev/tty': No such device or address` by adding `--batch --yes` flags to the `gpg --dearmor` command for non-interactive execution

## 1.2.0

### Added
- **ODBC Driver 17 & 18**: Installed Microsoft ODBC Driver 17 and 18 for SQL Server, enabling ODBC-based connections from applications and scripts
- **Command-Line Tools**: Added `sqlcmd` and `bcp` utilities (both v17 and v18) for direct database management from within the container
- **unixodbc-dev**: Included ODBC development headers for building ODBC applications
- **PATH Configuration**: Added `/opt/mssql-tools18/bin` and `/opt/mssql-tools/bin` to PATH for easy access to sqlcmd and bcp

### Documentation
- Updated DOCS.md with comprehensive ODBC driver information and usage examples
- Added sqlcmd and bcp usage examples for both interactive and automated scenarios
- Updated README.md to highlight included ODBC drivers and command-line tools

## 1.1.0

### Fixed
- **Database Persistence**: Fixed critical issue where user databases would disappear after restarting Home Assistant. The master database is now stored in the persistent `/share` volume instead of the ephemeral container storage, ensuring SQL Server remembers all databases across restarts.

### Changed
- Added `MSSQL_MASTER_DATA_FILE` and `MSSQL_MASTER_LOG_FILE` environment variables to persist the master database to `/share/mssqlserver/data/master.mdf` and `/share/mssqlserver/log/mastlog.ldf` respectively.

## 1.0.0

- Initial release
- SQL Server 2025 (Developer Edition by default)
- Configurable SA password, edition, and data directories
- Persistent storage via Home Assistant /share directory
