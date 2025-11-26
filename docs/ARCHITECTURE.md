# BEEWOO Project Architecture

## Overview

BEEWOO is a comprehensive network security monitoring platform that combines real-time traffic analysis with AI-powered threat detection. The system consists of multiple components working together to capture, analyze, and visualize network traffic for security assessment.

## System Architecture

### High-Level Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Client Side   │    │   Web Platform   │    │   AI Analysis   │
│   (OTHSEC)      │◄──►│   (Web2py)       │◄──►│   Engine        │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Network Traffic │    │   PostgreSQL     │    │  Machine        │
│ Capture         │    │   Database       │    │  Learning       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Core Components

### 1. OTHSEC Client (Network Sniffer)

**Location**: `othsec-win/`

**Technology Stack**:
- **Language**: C
- **Build System**: CMake
- **Dependencies**: 
  - libwebsockets (WebSocket communication)
  - json-c (JSON parsing)
  - OpenSSL (SSL/TLS support)
  - tcpdump (Network packet capture)

**Key Files**:
- `src/server.c` - Main server implementation
- `src/server.h` - Server header definitions
- `src/http.c` - HTTP protocol handling
- `src/protocol.c` - Protocol parsing
- `src/sniffer.c` - Network packet sniffing
- `src/utils.c` - Utility functions

**Functionality**:
- Real-time network traffic capture using tcpdump
- WebSocket-based communication with web platform
- TCP/UDP packet analysis and parsing
- System log monitoring (auth.log on Linux, Windows Event Log on Windows)
- Multi-platform support (Linux, Windows, macOS)

**Communication**:
- WebSocket endpoints:
  - `/tcpdump` - TCP dump data stream
  - `/tail` - System log stream  
  - `/sniffer` - Raw packet sniffer data
- Default port: 20508
- SSL/TLS support for secure communication

### 2. Web Platform (TrackR Application)

**Location**: `web2py/applications/TrackR/`

**Technology Stack**:
- **Framework**: Web2py (Python)
- **Database**: PostgreSQL
- **Frontend**: HTML5, JavaScript, Bootstrap
- **Real-time Communication**: WebRTC, WebSockets

**Architecture Layers**:

#### Models (`models/`)
- `db.py` - Database schema and configuration
- Database tables:
  - `othsec` - Raw network traffic data
  - `ipanalyzed` - Processed IP analysis results
  - `loganalyzed` - System log analysis results
  - `ipligence2` - IP geolocation database
  - `rtc` - WebRTC access tokens
  - `params` - ML algorithm parameters

#### Controllers (`controllers/`)
- `othsec.py` - Main traffic analysis controller
- `trackrctrl.py` - Tracking and geolocation controller
- `default.py` - Default application controller
- `ipligencectrl.py` - IP intelligence controller

#### Views (`views/`)
- Real-time dashboards for traffic visualization
- Geolocation maps for IP tracking
- WebRTC-based remote terminal access
- Machine learning analysis interfaces

**Key Features**:
- Real-time traffic parsing and analysis
- IP geolocation using IPligence database
- Machine learning-based anomaly detection
- WebRTC remote terminal access
- Interactive geographical visualization

### 3. Database Schema

**Primary Tables**:

```sql
-- Raw network traffic data
othsec (
  idn, username, protocol, datetime_remote, datetime_othsec,
  addr_from, addr_to, port_from, port_to,
  iph_version, iph_protocol, tcph_flags, body_message
)

-- Analyzed IP data with geolocation
ipanalyzed (
  idn, username, datetime, ip_version, tcp_protocol,
  ip_addr, port, status, risk, hits,
  longitude, latitude, tcp_flags
)

-- System log analysis
loganalyzed (
  idn, username, logon, datetime, protocol,
  ip_addr, port, service, status,
  conn_tries, auth_failure, banned,
  longitude, latitude
)

-- IP geolocation database
ipligence2 (
  ip_from, ip_to, country_code, country_name,
  continent_code, region_name, city_name,
  latitude, longitude
)
```

### 4. Deployment Infrastructure

**Containerization**: Docker-based deployment
- **Base Image**: Amazon Linux 2
- **Runtime**: Python 3.8 + uWSGI
- **Database**: PostgreSQL (AWS RDS)
- **Platform**: AWS with CodeDeploy integration

**Configuration Files**:
- `Dockerfile` - Container definition
- `entrypoint.sh` - Container startup script
- `appspec.yml` - AWS CodeDeploy specification
- `apprunner.yaml` - AWS App Runner configuration

## Data Flow

### 1. Traffic Capture Flow
```
Network Interface → tcpdump → OTHSEC Client → WebSocket → Web Platform
```

### 2. Data Processing Flow
```
Raw Packets → Parser → Database → ML Analysis → Visualization
```

### 3. Real-time Analysis Flow
```
Live Traffic → Pattern Recognition → Risk Assessment → Alert Generation
```

## Security Features

### Network Traffic Analysis
- **Protocol Support**: TCP, UDP, ICMP, IPv4/IPv6
- **Deep Packet Inspection**: Header analysis and payload examination
- **Traffic Classification**: Protocol identification and service mapping

### Threat Detection
- **Anomaly Detection**: Machine learning-based pattern recognition
- **Geolocation Analysis**: IP-based geographical threat mapping
- **Behavioral Analysis**: Connection pattern analysis
- **Fail2Ban Integration**: Automated threat response

### Machine Learning Components
- **Algorithms**: KNN, SVM, Unsupervised clustering
- **Features**: TCP flags, connection patterns, geographical data
- **Real-time Processing**: Live threat scoring and classification

## Integration Points

### External Services
- **IPligence Database**: IP geolocation services
- **AWS RDS**: PostgreSQL database hosting
- **AWS CodeDeploy**: Automated deployment pipeline
- **WebRTC**: Real-time communication for remote access

### API Endpoints
- `/othsec/InsertTraceInDB` - Traffic data ingestion
- `/othsec/InsertLogInDB` - Log data ingestion  
- `/othsec/InsertSnifInDB` - Raw sniffer data ingestion
- `/othsec/GetListMarkers` - Geolocation data retrieval

## Scalability Considerations

### Horizontal Scaling
- Multiple OTHSEC clients can connect to single web platform
- Database partitioning by user/time for large datasets
- Load balancing for web platform instances

### Performance Optimization
- Real-time data streaming via WebSockets
- Indexed database queries for fast lookups
- Caching layer for frequently accessed geolocation data

## Development Environment

### Build Requirements
- **C Compiler**: GCC/Clang with C99 support
- **Python**: 3.8+ with Web2py framework
- **Database**: PostgreSQL 12+
- **Tools**: CMake, Git, Docker

### Development Workflow
1. Local development with SQLite database
2. Docker containerization for testing
3. AWS deployment via CodeDeploy
4. Continuous integration with automated testing

## Monitoring and Logging

### Application Logging
- Structured logging via Python logging framework
- Debug levels for development and production
- Log rotation and archival

### Performance Monitoring
- Real-time traffic metrics
- Database performance monitoring
- WebSocket connection health checks
- ML algorithm performance tracking

## Future Enhancements

### Planned Features
- Enhanced ML algorithms for better threat detection
- Mobile application for remote monitoring
- API integration with external security tools
- Advanced visualization and reporting capabilities

### Scalability Improvements
- Microservices architecture migration
- Event-driven processing with message queues
- Distributed ML processing capabilities
- Enhanced caching and CDN integration