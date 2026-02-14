# MS SQL Server 2025 - Home Assistant App

Run Microsoft SQL Server 2025 as a containerized service within Home Assistant OS/Supervised. This add-on provides a fully functional SQL Server 2025 database engine that integrates seamlessly with your Home Assistant installation.

## Features

- **MS SQL Server 2025** - Latest version of Microsoft's enterprise database engine
- **Multiple Editions** - Support for Developer, Express, Standard, and Enterprise editions
- **Persistent Storage** - Data stored in Home Assistant's `/share` directory for persistence across restarts
- **Easy Configuration** - Simple YAML-based configuration through Home Assistant UI
- **ODBC Driver Included** - Microsoft ODBC Driver 18 for SQL Server connectivity
- **Command-Line Tools** - `sqlcmd` and `bcp` utilities (v18) for database management
- **amd64 Architecture** - Optimized for x86-64 systems (SQL Server does not support ARM architectures)

## Installation

### Adding the Repository

1. Navigate to **Settings** → **Add-ons** → **Add-on Store** in your Home Assistant instance
2. Click the **⋮** menu in the top-right corner
3. Select **Repositories**
4. Add the following URL:
   ```
   https://github.com/phdindota/MSSQLSERVER-HA-ADDON
   ```
5. Click **Add**
6. Close the dialog

### Installing the Add-on

1. Find "MS SQL Server 2025" in the add-on store
2. Click on the add-on
3. Click **Install**
4. Wait for the installation to complete

## Configuration

Before starting the add-on, you must configure it with at least the EULA acceptance and SA password.

### Minimum Required Configuration

```yaml
accept_eula: true
sa_password: "YourStrongPassword123!"
```

### Full Configuration Options

| Option | Description | Default | Required |
|--------|-------------|---------|----------|
| `accept_eula` | Accept Microsoft SQL Server EULA | `false` | **Yes** |
| `sa_password` | SA (admin) password (min 8 chars, complexity required) | `""` | **Yes** |
| `mssql_pid` | SQL Server edition | `Developer` | No |
| `mssql_data_dir` | Data files directory | `/share/mssqlserver/data` | No |
| `mssql_log_dir` | Log files directory | `/share/mssqlserver/log` | No |
| `mssql_backup_dir` | Backup files directory | `/share/mssqlserver/backup` | No |

### Configuration Example

```yaml
accept_eula: true
sa_password: "MySecureP@ssw0rd!"
mssql_pid: "Developer"
mssql_data_dir: "/share/mssqlserver/data"
mssql_log_dir: "/share/mssqlserver/log"
mssql_backup_dir: "/share/mssqlserver/backup"
```

### Password Requirements

The SA password must meet SQL Server complexity requirements:
- Minimum **8 characters**
- Must contain at least **3** of the following:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Digits (0-9)
  - Symbols (!@#$%^&*()_+-=[]{}|;:,.<>?)

### Available Editions

- **Developer** - Full-featured free edition for development/testing (default)
- **Express** - Free lightweight edition with limitations
- **Standard** - Commercial edition (requires valid license)
- **Enterprise** - Full-featured commercial edition (requires valid license)

## Quick Start

1. **Accept the EULA**: Set `accept_eula: true` in the configuration
   - [Microsoft SQL Server EULA](https://go.microsoft.com/fwlink/?linkid=857698)

2. **Set SA Password**: Configure a strong password for the SA (administrator) account

3. **Start the Add-on**: Click the **Start** button

4. **Enable Auto-start** (optional): Toggle "Start on boot" to start SQL Server automatically

## Connecting to SQL Server

Once the add-on is running, you can connect to SQL Server on port **1433**.

### Connection Details

- **Server**: `homeassistant.local,1433` or `<your-ha-ip>,1433`
- **Port**: `1433`
- **Username**: `sa`
- **Password**: The password you configured
- **Authentication**: SQL Server Authentication

### Using SQL Server Management Studio (SSMS)

1. Open SSMS on your Windows machine
2. Server name: `homeassistant.local,1433`
3. Authentication: SQL Server Authentication
4. Login: `sa`
5. Password: Your configured SA password
6. Click **Connect**

### Using Azure Data Studio

1. Open Azure Data Studio
2. Click **New Connection**
3. Connection type: Microsoft SQL Server
4. Server: `homeassistant.local,1433`
5. Authentication type: SQL Login
6. User name: `sa`
7. Password: Your configured SA password
8. Click **Connect**

### Using sqlcmd (Command Line)

**Note**: This add-on includes `sqlcmd` v18. You can use it from within the container.

**From within the add-on container**:
```bash
# Using sqlcmd v18
sqlcmd -S localhost -U sa -P 'YourPassword' -Q "SELECT name FROM sys.databases"

# Interactive mode
sqlcmd -S localhost -U sa -P 'YourPassword'
```

**From your local machine**:
```bash
sqlcmd -S homeassistant.local,1433 -U sa -P 'YourPassword'
```

### Using Connection Strings

**.NET / C#**:
```
Server=homeassistant.local,1433;Database=master;User Id=sa;Password=YourPassword;TrustServerCertificate=True;
```

**Python (pyodbc)**:
```python
import pyodbc
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 18 for SQL Server};'
    'SERVER=homeassistant.local,1433;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=YourPassword;'
    'TrustServerCertificate=yes;'
)
```

## Data Persistence

All SQL Server data, **including the master system database**, is stored in the Home Assistant `/share/mssqlserver` directory by default:

- **Data files**: `/share/mssqlserver/data` (includes `master.mdf`)
- **Log files**: `/share/mssqlserver/log` (includes `mastlog.ldf`)
- **Backups**: `/share/mssqlserver/backup`

This ensures your databases persist across add-on restarts and updates. The master database, which tracks all user databases, is now stored in persistent storage, so your databases will survive Home Assistant restarts. You can access these directories from the Home Assistant file system.

## Important Notes

### Architecture Limitation

⚠️ **This add-on only supports amd64 (x86-64) architecture.**

SQL Server does not support ARM-based systems (including Raspberry Pi). You must run this add-on on:
- x86-64 based systems
- Intel or AMD processors
- Not compatible with: Raspberry Pi, ARM-based devices

### Memory Requirements

Microsoft recommends a minimum of **2GB RAM** for SQL Server. Ensure your Home Assistant host has sufficient memory available.

### EULA Acceptance

You must accept the Microsoft SQL Server End User License Agreement to use this add-on. Set `accept_eula: true` in the configuration.

- [SQL Server 2025 EULA](https://go.microsoft.com/fwlink/?linkid=857698)

## Resources

- [Microsoft SQL Server 2025 Documentation](https://learn.microsoft.com/en-us/sql/sql-server/)
- [SQL Server on Linux Documentation](https://learn.microsoft.com/en-us/sql/linux/)
- [SQL Server Container Images](https://hub.docker.com/_/microsoft-mssql-server)
- [Add-on Repository](https://github.com/phdindota/MSSQLSERVER-HA-ADDON)

## Support

For issues and feature requests, please use the [GitHub Issues](https://github.com/phdindota/MSSQLSERVER-HA-ADDON/issues) page.

## License

This add-on is provided under the MIT License. However, Microsoft SQL Server itself is subject to Microsoft's licensing terms. Please ensure you have appropriate licenses for non-Developer/Express editions.
