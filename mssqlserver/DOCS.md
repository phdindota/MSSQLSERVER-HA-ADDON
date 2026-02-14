# MS SQL Server 2025 Add-on Documentation

## Overview

The MS SQL Server 2025 add-on brings Microsoft's enterprise-grade relational database management system to Home Assistant. This add-on runs SQL Server 2025 in a containerized environment, providing a robust database solution for storing and managing data within your Home Assistant ecosystem.

**Included Tools:**
- **ODBC Driver 18** - Microsoft's official ODBC driver for SQL Server connectivity
- **sqlcmd & bcp** - Command-line tools for SQL Server management (v18)
- **unixodbc-dev** - ODBC development headers for building ODBC applications

### Key Benefits

- **Enterprise Features**: Full SQL Server 2025 capabilities including T-SQL, stored procedures, triggers, and more
- **Integration Ready**: Use SQL Server to store sensor data, automation logs, or custom application data
- **Familiar Tools**: Connect using industry-standard tools like SSMS, Azure Data Studio, or sqlcmd
- **Persistent Storage**: Data survives restarts and updates through Home Assistant's share directory
- **Multiple Editions**: Choose from Developer, Express, Standard, or Enterprise editions

## Prerequisites

### System Requirements

- **Architecture**: amd64 (x86-64) only - SQL Server does NOT support ARM processors
- **Memory**: Minimum 2GB RAM recommended by Microsoft
- **Disk Space**: At least 6GB for SQL Server binaries plus space for your databases
- **Home Assistant**: Supervisor-based installation (Home Assistant OS or Supervised)

### Supported Platforms

✅ **Supported**:
- x86-64 based systems
- Intel processors
- AMD processors
- Home Assistant OS on x86-64
- Home Assistant Supervised on x86-64

❌ **Not Supported**:
- Raspberry Pi (all models)
- ARM-based single-board computers
- Apple Silicon (M1/M2) devices
- Any ARM/aarch64 architecture

## Installation

### Step 1: Add the Repository

1. Open Home Assistant web interface
2. Navigate to **Settings** → **Add-ons** → **Add-on Store**
3. Click the **⋮** (three dots) menu in the top-right corner
4. Select **Repositories**
5. Enter this URL:
   ```
   https://github.com/phdindota/MSSQLSERVER-HA-ADDON
   ```
6. Click **Add**, then **Close**

### Step 2: Install the Add-on

1. Refresh the add-on store page
2. Scroll down to find "MS SQL Server 2025"
3. Click on the add-on card
4. Click the **Install** button
5. Wait for installation to complete (may take several minutes)

### Step 3: Configure the Add-on

Before starting, you must configure at least two required settings:

1. Go to the **Configuration** tab
2. Set the following **required** options:
   ```yaml
   accept_eula: true
   sa_password: "YourStrongPassword123!"
   ```
3. Optionally configure other settings (see Configuration section below)
4. Click **Save**

### Step 4: Start the Add-on

1. Go to the **Info** tab
2. Click **Start**
3. Wait for the add-on to start (may take 1-2 minutes)
4. Check the **Log** tab for startup messages

## Configuration Options

### Required Options

#### accept_eula (boolean)

**Required**: Yes  
**Default**: `false`

You must set this to `true` to accept the Microsoft SQL Server End User License Agreement.

- EULA: https://go.microsoft.com/fwlink/?linkid=857698

```yaml
accept_eula: true
```

#### sa_password (string)

**Required**: Yes  
**Default**: `""` (empty)

The password for the `sa` (System Administrator) account. This is the main administrative account for SQL Server.

**Requirements**:
- Minimum 8 characters
- Must contain at least 3 of the following:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Digits (0-9)
  - Special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)

**Good Examples**:
```yaml
sa_password: "MySecureP@ssw0rd!"
sa_password: "HomeAssist123!"
sa_password: "Sql2025#Server"
```

**Bad Examples** (will be rejected):
```yaml
sa_password: "password"        # Too simple, no complexity
sa_password: "12345678"        # No letters
sa_password: "Short1!"         # Too short (less than 8 characters)
```

### Optional Options

#### mssql_pid (string)

**Required**: No  
**Default**: `"Developer"`  
**Options**: `Developer`, `Express`, `Standard`, `Enterprise`

The SQL Server edition/product ID to use.

- **Developer**: Full-featured free edition for development and testing (not licensed for production)
- **Express**: Free lightweight edition with feature limitations (max 10GB database size)
- **Standard**: Commercial edition requiring valid license
- **Enterprise**: Full-featured commercial edition requiring valid license

```yaml
mssql_pid: "Developer"
```

#### mssql_data_dir (string)

**Required**: No  
**Default**: `/share/mssqlserver/data`

Directory path where SQL Server stores database data files (.mdf, .ndf).

```yaml
mssql_data_dir: "/share/mssqlserver/data"
```

#### mssql_log_dir (string)

**Required**: No  
**Default**: `/share/mssqlserver/log`

Directory path where SQL Server stores transaction log files (.ldf).

```yaml
mssql_log_dir: "/share/mssqlserver/log"
```

#### mssql_backup_dir (string)

**Required**: No  
**Default**: `/share/mssqlserver/backup`

Directory path where SQL Server stores backup files (.bak).

```yaml
mssql_backup_dir: "/share/mssqlserver/backup"
```

## Connecting to SQL Server

### Connection Information

Once the add-on is running, use these connection details:

| Parameter | Value |
|-----------|-------|
| **Host** | `homeassistant.local` or your Home Assistant IP address |
| **Port** | `1433` |
| **Username** | `sa` |
| **Password** | Your configured SA password |
| **Authentication** | SQL Server Authentication |

### SQL Server Management Studio (SSMS)

SSMS is the primary management tool for SQL Server on Windows.

1. Download and install SSMS from [Microsoft](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
2. Launch SSMS
3. In the "Connect to Server" dialog:
   - **Server type**: Database Engine
   - **Server name**: `homeassistant.local,1433` (note the comma)
   - **Authentication**: SQL Server Authentication
   - **Login**: `sa`
   - **Password**: Your configured SA password
4. Click **Connect**

### Azure Data Studio

Azure Data Studio is a cross-platform SQL Server management tool (Windows, macOS, Linux).

1. Download and install from [Microsoft](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio)
2. Launch Azure Data Studio
3. Click **New Connection** or press Ctrl+N
4. Fill in the connection details:
   - **Connection type**: Microsoft SQL Server
   - **Server**: `homeassistant.local,1433`
   - **Authentication type**: SQL Login
   - **User name**: `sa`
   - **Password**: Your configured SA password
   - **Trust server certificate**: Yes
5. Click **Connect**

### sqlcmd (Command Line)

sqlcmd is included with SQL Server and available separately as a cross-platform tool. **This add-on includes sqlcmd v18**, which is accessible from within the add-on container.

**⚠️ Security Note**: The examples below show passwords on the command line for simplicity. In production environments, avoid exposing passwords in command history by:
- Using environment variables: `sqlcmd -S localhost -U sa -P "$SA_PASSWORD"`
- Omitting `-P` to prompt interactively: `sqlcmd -S localhost -U sa` (then enter password when prompted)
- Using configuration files with restricted permissions

**From within the add-on container** (using Terminal add-on or `docker exec`):
```bash
# Using sqlcmd v18
sqlcmd -S localhost -U sa -P 'YourPassword' -Q "SELECT @@VERSION"

# Interactive mode
sqlcmd -S localhost -U sa -P 'YourPassword'
```

**From outside the container** (Linux/macOS):
```bash
sqlcmd -S homeassistant.local,1433 -U sa -P 'YourPassword' -C
```

**Windows**:
```cmd
sqlcmd -S homeassistant.local,1433 -U sa -P "YourPassword" -C
```

The `-C` flag trusts the server certificate (useful for self-signed certificates).

**Using bcp (Bulk Copy Program)**:

The `bcp` utility is also included for bulk data import/export operations:

```bash
# Export data from a table to a file
bcp YourDatabase.dbo.YourTable out /share/mssqlserver/backup/data.txt -S localhost -U sa -P 'YourPassword' -c

# Import data from a file to a table
bcp YourDatabase.dbo.YourTable in /share/mssqlserver/backup/data.txt -S localhost -U sa -P 'YourPassword' -c
```

### Programming Language Connections

#### Python (pyodbc)

**Note**: This add-on includes ODBC Driver 18.

```python
import pyodbc

# Using ODBC Driver 18
connection_string = (
    'DRIVER={ODBC Driver 18 for SQL Server};'
    'SERVER=homeassistant.local,1433;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=YourPassword;'
    'TrustServerCertificate=yes;'
)

conn = pyodbc.connect(connection_string)
cursor = conn.cursor()
cursor.execute("SELECT @@VERSION")
row = cursor.fetchone()
print(row[0])
conn.close()
```

#### .NET / C#

```csharp
using Microsoft.Data.SqlClient;

string connectionString = 
    "Server=homeassistant.local,1433;" +
    "Database=master;" +
    "User Id=sa;" +
    "Password=YourPassword;" +
    "TrustServerCertificate=True;";

using (SqlConnection conn = new SqlConnection(connectionString))
{
    conn.Open();
    using (SqlCommand cmd = new SqlCommand("SELECT @@VERSION", conn))
    {
        string version = cmd.ExecuteScalar().ToString();
        Console.WriteLine(version);
    }
}
```

#### Node.js (mssql)

```javascript
const sql = require('mssql');

const config = {
    user: 'sa',
    password: 'YourPassword',
    server: 'homeassistant.local',
    port: 1433,
    database: 'master',
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

async function connect() {
    try {
        await sql.connect(config);
        const result = await sql.query`SELECT @@VERSION`;
        console.log(result.recordset);
    } catch (err) {
        console.error(err);
    }
}

connect();
```

## Data Persistence

### Storage Directories

All SQL Server data, **including the master system database**, is stored in the Home Assistant `/share` directory, ensuring persistence across restarts, updates, and reinstalls.

Default locations:
```
/share/mssqlserver/data/     - Database files (.mdf, .ndf), including master.mdf
/share/mssqlserver/log/      - Transaction logs (.ldf), including mastlog.ldf
/share/mssqlserver/backup/   - Backup files (.bak)
```

**Important**: The master database is now persisted to the `/share` volume, which means SQL Server will remember all your user databases even after Home Assistant or the add-on restarts. Previously, the master database was stored in the container's ephemeral storage, causing databases to appear to "disappear" after restarts.

### Accessing Files

You can access these directories through:

1. **File Editor Add-on**: Navigate to `/share/mssqlserver`
2. **SSH/Terminal Add-on**: `cd /share/mssqlserver`
3. **Samba Share**: Access the `share` folder from your network

### Changing Storage Locations

You can customize storage paths in the add-on configuration:

```yaml
mssql_data_dir: "/share/mssqlserver/data"
mssql_log_dir: "/share/mssqlserver/log"
mssql_backup_dir: "/share/mssqlserver/backup"
```

**Note**: Changing these paths after initial setup may require manually moving existing database files.

## Backup and Restore

### Creating Backups

**Using T-SQL**:
```sql
BACKUP DATABASE YourDatabase
TO DISK = '/share/mssqlserver/backup/YourDatabase.bak'
WITH FORMAT, INIT, NAME = 'Full Backup';
```

**Using SSMS**:
1. Connect to SQL Server
2. Right-click the database → Tasks → Back Up
3. Set backup destination to `/share/mssqlserver/backup/YourDatabase.bak`
4. Click OK

### Restoring Backups

**Using T-SQL**:
```sql
RESTORE DATABASE YourDatabase
FROM DISK = '/share/mssqlserver/backup/YourDatabase.bak'
WITH REPLACE;
```

**Using SSMS**:
1. Connect to SQL Server
2. Right-click Databases → Restore Database
3. Select Device → Add → Browse to `/share/mssqlserver/backup/YourDatabase.bak`
4. Click OK

### Scheduled Backups

You can use SQL Server Agent (in non-Express editions) or create a Home Assistant automation to schedule backups using sqlcmd:

```yaml
automation:
  - alias: "Daily SQL Backup"
    trigger:
      platform: time
      at: "02:00:00"
    action:
      service: shell_command.sql_backup

shell_command:
  sql_backup: >
    docker exec addon_local_mssqlserver
    sqlcmd -S localhost -U sa -P 'YourPassword'
    -Q "BACKUP DATABASE YourDB TO DISK='/share/mssqlserver/backup/daily.bak' WITH INIT"
```

## ODBC Drivers and Command-Line Tools

This add-on includes Microsoft's official ODBC driver and command-line tools, enabling direct database access and management from within the container.

### Included Components

| Component | Version | Description |
|-----------|---------|-------------|
| **ODBC Driver 18** | msodbcsql18 | Latest ODBC driver with TLS encryption by default |
| **mssql-tools18** | v18 | Command-line tools: `sqlcmd` and `bcp` (v18) |
| **unixodbc-dev** | Latest | ODBC development headers for building applications |

**Note**: ODBC Driver 17 and mssql-tools v17 are not included because they are not available for Ubuntu 24.04. Only Driver 18 packages are available in the Ubuntu 24.04 Microsoft repository.

### Using sqlcmd from the Container

You can execute SQL queries directly from within the add-on container using `sqlcmd`:

**Access the container terminal** (via Terminal add-on or SSH):
```bash
docker exec -it addon_local_mssqlserver bash
```

**Run queries**:
```bash
# List all databases
sqlcmd -S localhost -U sa -P 'YourPassword' -Q "SELECT name FROM sys.databases"

# Create a new database
sqlcmd -S localhost -U sa -P 'YourPassword' -Q "CREATE DATABASE MyNewDB"

# Run a SQL script
sqlcmd -S localhost -U sa -P 'YourPassword' -i /share/mssqlserver/backup/script.sql

# Interactive mode
sqlcmd -S localhost -U sa -P 'YourPassword'
```

### Using bcp for Bulk Operations

The `bcp` (Bulk Copy Program) utility allows you to efficiently import and export large amounts of data:

```bash
# Export table data to CSV
bcp "SELECT * FROM MyDatabase.dbo.MyTable" queryout /share/mssqlserver/backup/export.csv -S localhost -U sa -P 'YourPassword' -c -t,

# Import data from CSV to table
bcp MyDatabase.dbo.MyTable in /share/mssqlserver/backup/data.csv -S localhost -U sa -P 'YourPassword' -c -t,

# Export with native format (faster, preserves data types)
bcp MyDatabase.dbo.MyTable out /share/mssqlserver/backup/data.bcp -S localhost -U sa -P 'YourPassword' -n
```

### ODBC Connection Strings

When connecting from applications, use ODBC Driver 18:

**ODBC Driver 18**:
```
DRIVER={ODBC Driver 18 for SQL Server};SERVER=homeassistant.local,1433;DATABASE=master;UID=sa;PWD=YourPassword;TrustServerCertificate=yes;
```

### Tool Locations

The command-line tools are installed in the following locations and added to PATH:

- **sqlcmd v18**: `/opt/mssql-tools18/bin/sqlcmd`
- **bcp v18**: `/opt/mssql-tools18/bin/bcp`

You can call `sqlcmd` or `bcp` directly without specifying the full path as they are in the system PATH.

## Troubleshooting

### EULA Not Accepted

**Error**: "You must accept the Microsoft SQL Server EULA to use this add-on"

**Solution**: Set `accept_eula: true` in the add-on configuration and restart.

### Weak Password Error

**Error**: "SA password does not meet complexity requirements"

**Solution**: Ensure your password:
- Is at least 8 characters long
- Contains at least 3 of: uppercase, lowercase, digits, symbols

Example: `MySecureP@ssw0rd!`

### Insufficient Memory

**Error**: SQL Server fails to start or crashes

**Symptoms**: 
- Add-on starts then stops immediately
- "Out of memory" errors in logs

**Solution**:
- Ensure your system has at least 2GB RAM available
- Consider using Express edition which has lower memory requirements
- Close other memory-intensive add-ons or applications

### Cannot Connect from Client

**Problem**: Connection timeout or refused

**Checklist**:
1. Verify the add-on is running (check Info tab)
2. Check port 1433 is exposed (should be by default)
3. Try using IP address instead of `homeassistant.local`
4. Check firewall settings on your client machine
5. Verify SA password is correct
6. Try adding `-C` flag to sqlcmd to trust certificate

### Add-on Won't Start

**Steps**:
1. Check the Log tab for error messages
2. Verify configuration is valid YAML
3. Ensure `accept_eula: true` is set
4. Ensure `sa_password` meets requirements
5. Check system has sufficient disk space
6. Restart Home Assistant if needed

### Database File Corruption

**Problem**: Database marked as suspect or won't attach

**Solutions**:
1. Try restoring from a backup
2. Use SQL Server emergency mode to recover
3. Check disk space availability
4. Review SQL Server error logs in `/share/mssqlserver/log`

### Architecture Error

**Error**: "exec format error" or "cannot execute binary file"

**Cause**: Trying to run on ARM-based system (Raspberry Pi, etc.)

**Solution**: SQL Server only supports x86-64 architecture. You must use a different system or consider alternative databases like PostgreSQL or MariaDB for ARM devices.

## Security Considerations

### Password Security

- **Never use simple passwords** like "password" or "12345678"
- **Don't share your SA password** with untrusted users
- **Consider creating separate SQL logins** with limited permissions for applications
- **Rotate passwords regularly** for production use

### Network Security

- SQL Server is exposed on port 1433 to your local network
- Consider using firewall rules to restrict access if needed
- For internet exposure, use a VPN instead of port forwarding
- SQL Server uses TLS encryption for connections by default

### Creating Limited Users

Instead of using the SA account for everything, create application-specific logins:

```sql
-- Create a new login
CREATE LOGIN app_user WITH PASSWORD = 'AnotherStr0ngP@ss!';

-- Create a user in your database
USE YourDatabase;
CREATE USER app_user FOR LOGIN app_user;

-- Grant specific permissions
ALTER ROLE db_datareader ADD MEMBER app_user;
ALTER ROLE db_datawriter ADD MEMBER app_user;
```

### Backup Encryption

Consider encrypting sensitive backups:

```sql
BACKUP DATABASE YourDatabase
TO DISK = '/share/mssqlserver/backup/YourDatabase_encrypted.bak'
WITH 
    ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = MyCert),
    FORMAT, INIT;
```

## Advanced Usage

### Enabling SQL Server Agent

SQL Server Agent (for job scheduling) is available in Standard and Enterprise editions:

**Note**: Agent is not available in Developer or Express editions.

### Database Mail

Configure Database Mail for email notifications (requires SMTP server):

```sql
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
```

### Performance Tuning

- Monitor memory usage with `sp_configure 'max server memory'`
- Enable instant file initialization for better performance
- Configure appropriate database recovery models
- Regular index maintenance

### High Availability

For production scenarios, consider:
- Regular automated backups
- Database mirroring or Always On availability groups (Enterprise edition)
- External backup storage
- Monitoring and alerting

## FAQ

**Q: Can I run this on Raspberry Pi?**  
A: No, SQL Server only supports x86-64 (amd64) architecture.

**Q: What edition should I use?**  
A: Use Developer for development/testing, Express for small databases, Standard/Enterprise for production (requires licenses).

**Q: How do I upgrade SQL Server?**  
A: Update the add-on when new versions are released. Your data in `/share/mssqlserver` will persist.

**Q: Can I use this in production?**  
A: Developer edition is not licensed for production. Use Express (free, limited) or purchase Standard/Enterprise licenses.

**Q: How do I change the SA password?**  
A: Update the configuration and restart the add-on. Alternatively, use ALTER LOGIN in T-SQL.

**Q: Why is my database so slow?**  
A: Check available memory, disk I/O, and SQL Server performance counters. Consider indexing and query optimization.

**Q: Can I access SQL Server from outside my network?**  
A: Yes, but use a VPN for security. Avoid exposing port 1433 directly to the internet.

## Resources

- [SQL Server 2025 Documentation](https://learn.microsoft.com/en-us/sql/sql-server/)
- [SQL Server on Linux](https://learn.microsoft.com/en-us/sql/linux/)
- [T-SQL Reference](https://learn.microsoft.com/en-us/sql/t-sql/)
- [SQL Server Container Images](https://hub.docker.com/_/microsoft-mssql-server)
- [GitHub Repository](https://github.com/phdindota/MSSQLSERVER-HA-ADDON)

## Getting Help

- **GitHub Issues**: https://github.com/phdindota/MSSQLSERVER-HA-ADDON/issues
- **Home Assistant Community**: https://community.home-assistant.io/
- **Microsoft SQL Docs**: https://learn.microsoft.com/en-us/sql/

---

*This add-on is community-maintained and not officially supported by Microsoft or Home Assistant.*
