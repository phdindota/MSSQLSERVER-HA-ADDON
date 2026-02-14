# Changelog

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
