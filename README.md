# BEEWOO - AI-Powered Network Security Platform

BEEWOO is a comprehensive network security monitoring platform that combines real-time traffic analysis with artificial intelligence to detect and visualize network threats. The system captures network traffic, analyzes it using machine learning algorithms, and provides interactive geographical visualization of potential security risks.

## Features

- **Real-time Network Monitoring**: Captures and analyzes TCP/UDP traffic using advanced packet sniffing
- **AI-Powered Threat Detection**: Machine learning algorithms (KNN, SVM) for anomaly detection
- **Geolocation Mapping**: Interactive maps showing geographical origin of network connections
- **Multi-Platform Support**: Works on Windows, Linux, and macOS
- **WebRTC Integration**: Remote terminal access for system administration
- **Live Dashboards**: Real-time visualization of network activity and threats

## Architecture

```
Client (OTHSEC) ←→ Web Platform (Web2py) ←→ AI Analysis Engine
       ↓                    ↓                      ↓
Network Capture      PostgreSQL DB        Machine Learning
```

## Installation

### Prerequisites

- **System Requirements**: Windows 10+, Ubuntu 20.04+, or macOS 11+
- **Network Tools**: tcpdump (Linux/macOS) or Npcap (Windows)
- **Database**: PostgreSQL 15+
- **Runtime**: Python 3.11+, Docker 24+ (recommended)
- **Build Tools**: CMake 3.16+, GCC/Clang with C11 support

### Option 1: Docker Compose (Recommended)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Sam9682/ai-beewoo.git
   cd ai-beewoo
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Start with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

4. **Access the platform**: Open `http://localhost:8080` in your browser

### Option 2: Manual Installation

#### Web Platform Setup

1. **Install Python dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Configure database** (edit `web2py/applications/TrackR/private/appconfig.ini`):
   ```ini
   [db]
   uri = postgres://user:password@localhost/beewoo
   migrate = true
   pool_size = 10
   ```

3. **Start Web2py server**:
   ```bash
   cd web2py
   python web2py.py -a your_password -i 0.0.0.0 -p 8080
   ```

#### OTHSEC Client Setup

1. **Install build dependencies**:
   
   **Ubuntu/Debian**:
   ```bash
   sudo apt-get install build-essential cmake libwebsockets-dev libjson-c-dev libssl-dev tcpdump
   ```
   
   **Windows**: Install Visual Studio Build Tools, vcpkg for dependencies

2. **Build OTHSEC client**:
   ```bash
   cd othsec-win
   mkdir build && cd build
   cmake ..
   make
   ```

3. **Run OTHSEC client** (requires admin/root privileges):
   ```bash
   sudo ./othsec -p 20508
   ```

### Option 3: Pre-built Binaries

Download platform-specific binaries from the releases:
- `beewoo_win10-x64.zip` - Windows 64-bit
- `beewoo_ubuntu.18.04-x64.zip` - Ubuntu 64-bit
- `beewoo_osx.10.12-x64.zip` - macOS 64-bit

## Quick Start Guide

### 1. Initial Setup

1. **Register an account** at the web platform
2. **Configure your network interface** for monitoring
3. **Start the OTHSEC client** with appropriate permissions

### 2. Basic Usage

#### Starting Network Monitoring

1. **Launch OTHSEC client**:
   ```bash
   # Linux/macOS
   sudo ./othsec -p 20508 -i eth0
   
   # Windows (as Administrator)
   othsec.exe -p 20508 -i "Ethernet"
   ```

2. **Access web dashboard**: Navigate to `http://localhost:8080/TrackR`

3. **Login** with your credentials

#### Viewing Network Activity

1. **Real-time Traffic**: Go to `OTHSEC → Display Xterm Form Sniffer`
2. **Geolocation Map**: Access `TrackR → Display Geoloc Map`
3. **Traffic Analysis**: View `OTHSEC → Display IP Analyzed Grid`

#### Understanding the Dashboard

- **Green markers**: Normal traffic
- **Yellow markers**: Suspicious activity
- **Red markers**: Potential threats or banned IPs
- **Traffic grid**: Detailed packet information with protocol analysis

### 3. Advanced Features

#### Machine Learning Analysis

1. **Configure ML parameters**: Go to `TrackR → Machine Learning Settings`
2. **Run anomaly detection**: Access `TrackR → Display Machine Learning Analysis`
3. **View results**: Check threat scores and classifications

#### Remote Terminal Access

1. **Enable WebRTC**: Go to `Default → WebRTC Master`
2. **Connect remotely**: Use the provided connection URL
3. **Execute commands**: Run system commands through the web interface

#### Custom Monitoring Rules

1. **Set IP filters**: Configure trusted/untrusted IP ranges
2. **Define alerts**: Set thresholds for suspicious activity
3. **Export data**: Download traffic logs in CSV format

### 4. Troubleshooting

#### Common Issues

**OTHSEC client won't start**:
- Ensure you have administrator/root privileges
- Check if tcpdump is installed and accessible
- Verify network interface name is correct

**No traffic data appearing**:
- Confirm OTHSEC client is connected (check port 20508)
- Verify database connection in web platform
- Check firewall settings

**Geolocation not working**:
- Ensure IPligence database is populated
- Check internet connectivity for IP lookups
- Verify database permissions

#### Log Files

- **Web platform logs**: `web2py/logs/web2py.log`
- **OTHSEC client**: Console output with debug level `-d 7`
- **Database logs**: Check PostgreSQL logs for connection issues

### 5. Configuration Options

#### OTHSEC Client Options

```bash
othsec [options]
  -p, --port              Port to listen (default: 7681)
  -i, --interface         Network interface to bind
  -c, --credential        Basic auth (username:password)
  -S, --ssl               Enable SSL
  -C, --ssl-cert          SSL certificate path
  -K, --ssl-key           SSL key path
  -d, --debug             Debug level (0-7)
```

#### Web Platform Configuration

Edit `web2py/applications/TrackR/private/appconfig.ini`:

```ini
[smtp]
server = smtp.gmail.com:587
sender = your-email@gmail.com
login = your-email@gmail.com:password

[db]
uri = postgres://user:pass@host/dbname
pool_size = 10
migrate = true
```

## Security Considerations

- **Run with minimal privileges**: Use dedicated service accounts
- **Enable SSL/TLS**: Configure certificates for production use
- **Network isolation**: Deploy in segmented network environments
- **Regular updates**: Keep dependencies and OS updated
- **Access control**: Implement proper authentication and authorization

## Support

- **Documentation**: See `ARCHITECTURE.md` for technical details
- **Issues**: Report bugs on GitHub repository
- **Community**: Join discussions in project forums

## License

© ELITELCO 2018 - www.elitelco.net

---

**⚠️ Important**: BEEWOO requires network monitoring privileges. Ensure compliance with local laws and organizational policies before deployment.