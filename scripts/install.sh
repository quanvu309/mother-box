#!/bin/bash

# Mother Box Installation Script
# Automated setup for Mother Box agent team creation system

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MOTHER_BOX_VERSION="1.0.0"
INSTALL_DIR="/opt/mother-box"
LOG_FILE="/var/log/mother-box/install.log"
REQUIRED_PYTHON_VERSION="3.9"
REQUIRED_DISK_SPACE_GB=20
REQUIRED_MEMORY_GB=8

# Helper functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1" | tee -a "$LOG_FILE"
}

# Check if running as root for system-wide installation
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log "Running as root - will install system-wide to $INSTALL_DIR"
        SYSTEM_INSTALL=true
    else
        log "Running as user - will install to local directory"
        INSTALL_DIR="$HOME/.mother-box"
        SYSTEM_INSTALL=false
    fi
}

# System requirements check
check_requirements() {
    log "Checking system requirements..."
    
    # Check Python version
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
        if ! python3 -c "import sys; exit(0 if sys.version_info >= ($REQUIRED_PYTHON_VERSION.replace('.', ','),) else 1)"; then
            log_error "Python $REQUIRED_PYTHON_VERSION or higher is required. Found: $PYTHON_VERSION"
            exit 1
        fi
        log "Python version check passed: $PYTHON_VERSION"
    else
        log_error "Python 3 is not installed. Please install Python $REQUIRED_PYTHON_VERSION or higher."
        exit 1
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_warning "Docker not found. Some features may not work."
        read -p "Continue without Docker? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Please install Docker and try again."
            exit 1
        fi
    else
        log "Docker check passed"
    fi
    
    # Check disk space
    AVAILABLE_SPACE=$(df -BG "$(dirname "$INSTALL_DIR")" | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $AVAILABLE_SPACE -lt $REQUIRED_DISK_SPACE_GB ]]; then
        log_error "Insufficient disk space. Required: ${REQUIRED_DISK_SPACE_GB}GB, Available: ${AVAILABLE_SPACE}GB"
        exit 1
    fi
    log "Disk space check passed: ${AVAILABLE_SPACE}GB available"
    
    # Check memory
    AVAILABLE_MEMORY=$(free -g | awk '/^Mem:/{print $2}')
    if [[ $AVAILABLE_MEMORY -lt $REQUIRED_MEMORY_GB ]]; then
        log_warning "Low memory detected. Recommended: ${REQUIRED_MEMORY_GB}GB, Available: ${AVAILABLE_MEMORY}GB"
        log_warning "Installation will continue but performance may be affected."
    else
        log "Memory check passed: ${AVAILABLE_MEMORY}GB available"
    fi
}

# Install system dependencies
install_dependencies() {
    log "Installing system dependencies..."
    
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        sudo apt-get update
        sudo apt-get install -y \
            python3-pip python3-venv python3-dev \
            git curl wget jq \
            build-essential \
            libffi-dev libssl-dev \
            postgresql-client \
            redis-tools
    elif command -v yum &> /dev/null; then
        # RedHat/CentOS
        sudo yum update -y
        sudo yum install -y \
            python3-pip python3-devel \
            git curl wget jq \
            gcc gcc-c++ make \
            openssl-devel libffi-devel \
            postgresql \
            redis
    elif command -v brew &> /dev/null; then
        # macOS
        brew update
        brew install python@3.9 git curl wget jq postgresql redis
    else
        log_warning "Unknown package manager. Please install dependencies manually."
    fi
    
    log "System dependencies installed"
}

# Create installation directory structure
setup_directories() {
    log "Setting up directory structure..."
    
    # Create main directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$(dirname "$LOG_FILE")"
    mkdir -p "$INSTALL_DIR/config"
    mkdir -p "$INSTALL_DIR/data"
    mkdir -p "$INSTALL_DIR/logs"
    mkdir -p "$INSTALL_DIR/backups"
    mkdir -p "$INSTALL_DIR/tmp"
    
    # Set permissions
    if [[ $SYSTEM_INSTALL == true ]]; then
        chown -R mother-box:mother-box "$INSTALL_DIR" || true
        chmod -R 755 "$INSTALL_DIR"
        chmod -R 700 "$INSTALL_DIR/config"
    fi
    
    log "Directory structure created at: $INSTALL_DIR"
}

# Install Python dependencies
install_python_deps() {
    log "Installing Python dependencies..."
    
    # Create virtual environment
    python3 -m venv "$INSTALL_DIR/venv"
    
    # Activate virtual environment
    source "$INSTALL_DIR/venv/bin/activate"
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel
    
    # Install core dependencies
    pip install \
        pyyaml \
        requests \
        click \
        jinja2 \
        jsonschema \
        python-dotenv \
        psutil \
        redis \
        celery \
        fastapi \
        uvicorn \
        prometheus-client \
        structlog
    
    # Install AI/ML dependencies
    pip install \
        openai \
        anthropic \
        langchain \
        transformers \
        sentence-transformers \
        faiss-cpu
    
    log "Python dependencies installed"
}

# Copy Mother Box files
install_mother_box() {
    log "Installing Mother Box files..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PACKAGE_ROOT="$(dirname "$SCRIPT_DIR")"
    
    # Copy core files
    cp -r "$PACKAGE_ROOT/agents" "$INSTALL_DIR/"
    cp -r "$PACKAGE_ROOT/workflows" "$INSTALL_DIR/"
    cp -r "$PACKAGE_ROOT/templates" "$INSTALL_DIR/"
    cp -r "$PACKAGE_ROOT/data" "$INSTALL_DIR/"
    cp -r "$PACKAGE_ROOT/utils" "$INSTALL_DIR/"
    cp -r "$PACKAGE_ROOT/checklists" "$INSTALL_DIR/"
    cp -r "$PACKAGE_ROOT/examples" "$INSTALL_DIR/"
    
    # Copy configuration files
    cp "$PACKAGE_ROOT/config"/* "$INSTALL_DIR/config/"
    
    # Copy scripts
    mkdir -p "$INSTALL_DIR/scripts"
    cp "$PACKAGE_ROOT/scripts"/* "$INSTALL_DIR/scripts/"
    chmod +x "$INSTALL_DIR/scripts"/*.sh
    
    # Copy API specification
    mkdir -p "$INSTALL_DIR/api"
    cp "$PACKAGE_ROOT/api"/* "$INSTALL_DIR/api/"
    
    log "Mother Box files installed"
}

# Setup configuration
setup_configuration() {
    log "Setting up configuration..."
    
    # Create environment file from template
    cat > "$INSTALL_DIR/.env" << EOF
# Mother Box Configuration
MOTHER_BOX_VERSION=$MOTHER_BOX_VERSION
MOTHER_BOX_ENVIRONMENT=development
MOTHER_BOX_INSTALL_DIR=$INSTALL_DIR
MOTHER_BOX_LOG_LEVEL=INFO

# API Configuration
MOTHER_BOX_API_HOST=localhost
MOTHER_BOX_API_PORT=8080
MOTHER_BOX_API_KEY=mb_$(openssl rand -hex 16)

# Database Configuration (SQLite by default)
DATABASE_URL=sqlite:///$INSTALL_DIR/data/mother-box.db

# Redis Configuration (optional)
REDIS_URL=redis://localhost:6379/0

# Research Configuration
RESEARCH_DEPTH=standard
ENABLE_COMMUNITY_RESEARCH=true
EXPERT_INTERVIEW_COUNT=3

# Quality Configuration
MIN_QUALITY_SCORE=8.5
ENABLE_EXPERT_VALIDATION=true
AUTO_IMPROVEMENT=true

# Security Configuration
SECRET_KEY=$(openssl rand -base64 32)
ENABLE_ENCRYPTION=true
ENABLE_AUDIT_LOGGING=true

# Integration Configuration (add your keys)
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
SLACK_WEBHOOK_URL=your_slack_webhook_here
EOF
    
    # Set secure permissions on config
    chmod 600 "$INSTALL_DIR/.env"
    
    log "Configuration files created"
    log_info "Please edit $INSTALL_DIR/.env with your API keys and preferences"
}

# Create systemd service (Linux only)
setup_service() {
    if [[ $SYSTEM_INSTALL == true && -d /etc/systemd/system ]]; then
        log "Creating systemd service..."
        
        cat > /etc/systemd/system/mother-box.service << EOF
[Unit]
Description=Mother Box AI Agent Team Creation System
After=network.target
Wants=network.target

[Service]
Type=simple
User=mother-box
Group=mother-box
WorkingDirectory=$INSTALL_DIR
Environment=PATH=$INSTALL_DIR/venv/bin
EnvironmentFile=$INSTALL_DIR/.env
ExecStart=$INSTALL_DIR/venv/bin/python -m mother_box.api
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
        
        # Create mother-box user if it doesn't exist
        if ! id "mother-box" &>/dev/null; then
            useradd -r -s /bin/false -d "$INSTALL_DIR" mother-box
        fi
        
        systemctl daemon-reload
        systemctl enable mother-box
        
        log "Systemd service created and enabled"
    fi
}

# Create command line aliases
setup_cli() {
    log "Setting up command line interface..."
    
    # Create mother-box command
    cat > "$INSTALL_DIR/bin/mother-box" << EOF
#!/bin/bash
source "$INSTALL_DIR/venv/bin/activate"
cd "$INSTALL_DIR"
python -m mother_box.cli "\$@"
EOF
    chmod +x "$INSTALL_DIR/bin/mother-box"
    
    # Add to PATH for current user
    if [[ $SYSTEM_INSTALL == false ]]; then
        echo 'export PATH="$HOME/.mother-box/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.mother-box/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
    else
        ln -sf "$INSTALL_DIR/bin/mother-box" /usr/local/bin/mother-box
    fi
    
    log "CLI setup complete"
}

# Initialize database and perform first-time setup
initialize_system() {
    log "Initializing Mother Box system..."
    
    source "$INSTALL_DIR/venv/bin/activate"
    cd "$INSTALL_DIR"
    
    # Initialize database
    python -c "
from mother_box.database import init_db
init_db()
print('Database initialized')
"
    
    # Validate installation
    python -c "
from mother_box.core import MotherBox
mb = MotherBox()
print('Mother Box initialization successful')
print(f'Version: {mb.version}')
print(f'Agents available: {len(mb.available_agents)}')
"
    
    log "System initialization complete"
}

# Run post-installation tests
run_tests() {
    log "Running post-installation tests..."
    
    source "$INSTALL_DIR/venv/bin/activate"
    cd "$INSTALL_DIR"
    
    # Run smoke tests
    if [[ -f scripts/smoke-test.sh ]]; then
        bash scripts/smoke-test.sh
    fi
    
    # Test API endpoints
    python -c "
import requests
import time
from subprocess import Popen

# Start API server in background
proc = Popen(['python', '-m', 'mother_box.api'])
time.sleep(5)

try:
    # Test health endpoint
    response = requests.get('http://localhost:8080/health')
    assert response.status_code == 200
    print('Health check: PASS')
    
    # Test version endpoint
    response = requests.get('http://localhost:8080/version')
    assert response.status_code == 200
    print('Version check: PASS')
    
    print('All tests passed!')
finally:
    proc.terminate()
"
    
    log "Post-installation tests completed successfully"
}

# Display installation summary
show_summary() {
    log "==============================================="
    log "🎉 Mother Box Installation Complete!"
    log "==============================================="
    log ""
    log "Installation Details:"
    log "  Version: $MOTHER_BOX_VERSION"
    log "  Install Directory: $INSTALL_DIR"
    log "  Configuration: $INSTALL_DIR/.env"
    log "  Logs: $LOG_FILE"
    log ""
    log "Next Steps:"
    log "1. Edit configuration file: $INSTALL_DIR/.env"
    log "   - Add your OpenAI/Anthropic API keys"
    log "   - Configure integrations (Slack, etc.)"
    log ""
    log "2. Start the system:"
    if [[ $SYSTEM_INSTALL == true ]]; then
        log "   sudo systemctl start mother-box"
    else
        log "   source $INSTALL_DIR/venv/bin/activate"
        log "   cd $INSTALL_DIR"
        log "   python -m mother_box.api"
    fi
    log ""
    log "3. Create your first agent team:"
    log "   mother-box create-team --domain 'Customer Support' --size 5"
    log ""
    log "4. Access the web interface:"
    log "   http://localhost:8080/dashboard"
    log ""
    log "Documentation:"
    log "  - User Guide: $INSTALL_DIR/README.md"
    log "  - API Docs: http://localhost:8080/docs"
    log "  - Examples: $INSTALL_DIR/examples/"
    log ""
    log "Support:"
    log "  - Community: https://community.mother-box.ai"
    log "  - Documentation: https://docs.mother-box.ai"
    log "  - Issues: https://github.com/mother-box/issues"
    log ""
    log "Happy agent team building! 🚀"
}

# Main installation function
main() {
    echo "🤖 Mother Box Installation Script v$MOTHER_BOX_VERSION"
    echo "================================================="
    
    # Create log directory
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # Check permissions and requirements
    check_permissions
    check_requirements
    
    # Ask for confirmation
    echo ""
    read -p "Proceed with installation to $INSTALL_DIR? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    # Run installation steps
    install_dependencies
    setup_directories
    install_python_deps
    install_mother_box
    setup_configuration
    setup_service
    setup_cli
    initialize_system
    run_tests
    show_summary
}

# Handle interrupts
trap 'log_error "Installation interrupted"; exit 1' INT TERM

# Run main installation
main "$@"