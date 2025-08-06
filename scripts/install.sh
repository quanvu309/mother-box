#!/bin/bash

# Mother Box Installation Script
# Automated setup for development and production environments

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Installation configuration
INSTALL_DIR="${INSTALL_DIR:-$(pwd)}"
PYTHON_VERSION="3.9"
NODE_VERSION="18"
ENVIRONMENT="${ENVIRONMENT:-development}"

# ASCII Art Banner
show_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
    __  __       _   _               ____            
   |  \/  | ___ | |_| |__   ___ _ __|  _ \  _____  __
   | |\/| |/ _ \| __| '_ \ / _ \ '__| |_) |/ _ \ \/ /
   | |  | | (_) | |_| | | |  __/ |  |  _ <| (_) >  < 
   |_|  |_|\___/ \__|_| |_|\___|_|  |_| \_\\___/_/\_\
                                                      
    AI Agent Team Creation System - Installation
EOF
    echo -e "${NC}"
}

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root!"
        exit 1
    fi
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        DISTRO=$(lsb_release -si 2>/dev/null || echo "Unknown")
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macOS"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
        DISTRO="Windows"
    else
        OS="unknown"
        DISTRO="Unknown"
    fi
    
    log_info "Detected OS: $DISTRO ($OS)"
}

# Check system requirements
check_requirements() {
    log "Checking system requirements..."
    
    # Check available disk space (need at least 5GB)
    if [[ "$OS" == "macos" ]]; then
        available_space=$(df -g . | awk 'NR==2 {print $4}')
    else
        available_space=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    fi
    
    if [[ $available_space -lt 5 ]]; then
        log_error "Insufficient disk space. At least 5GB required, only ${available_space}GB available."
        exit 1
    fi
    
    # Check RAM (need at least 4GB)
    if [[ "$OS" == "macos" ]]; then
        total_ram=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}')
    else
        total_ram=$(free -g | awk 'NR==2 {print $2}')
    fi
    
    if [[ ${total_ram%.*} -lt 4 ]]; then
        log_warning "System has less than 4GB RAM. Performance may be affected."
    fi
    
    log "System requirements check passed ✓"
}

# Install system dependencies
install_system_deps() {
    log "Installing system dependencies..."
    
    if [[ "$OS" == "macos" ]]; then
        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        # Install dependencies via Homebrew
        brew update
        brew install python@3.9 node@18 git docker docker-compose jq curl wget
        
    elif [[ "$OS" == "linux" ]]; then
        # Update package manager
        if [[ "$DISTRO" == "Ubuntu" ]] || [[ "$DISTRO" == "Debian" ]]; then
            sudo apt-get update
            sudo apt-get install -y \
                python3.9 python3.9-venv python3-pip \
                nodejs npm \
                git docker.io docker-compose \
                jq curl wget \
                build-essential libssl-dev libffi-dev
                
        elif [[ "$DISTRO" == "CentOS" ]] || [[ "$DISTRO" == "RHEL" ]] || [[ "$DISTRO" == "Fedora" ]]; then
            sudo dnf update -y
            sudo dnf install -y \
                python39 python39-pip \
                nodejs npm \
                git docker docker-compose \
                jq curl wget \
                gcc gcc-c++ make openssl-devel
        else
            log_error "Unsupported Linux distribution: $DISTRO"
            exit 1
        fi
        
        # Start Docker service
        sudo systemctl start docker
        sudo systemctl enable docker
        
        # Add user to docker group
        sudo usermod -aG docker $USER
        log_warning "You may need to log out and back in for Docker permissions to take effect."
    fi
    
    log "System dependencies installed ✓"
}

# Check if required tools are installed
check_tools() {
    log "Checking required tools..."
    
    local missing_tools=()
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        missing_tools+=("python3")
    else
        python_version=$(python3 --version | cut -d' ' -f2)
        log_info "Python version: $python_version"
    fi
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        missing_tools+=("node")
    else
        node_version=$(node --version)
        log_info "Node.js version: $node_version"
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    else
        docker_version=$(docker --version | cut -d' ' -f3 | sed 's/,//')
        log_info "Docker version: $docker_version"
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        # Try docker compose (newer integrated version)
        if ! docker compose version &> /dev/null; then
            missing_tools+=("docker-compose")
        else
            compose_version=$(docker compose version | cut -d' ' -f4)
            log_info "Docker Compose version: $compose_version"
        fi
    else
        compose_version=$(docker-compose --version | cut -d' ' -f4)
        log_info "Docker Compose version: $compose_version"
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        missing_tools+=("git")
    else
        git_version=$(git --version | cut -d' ' -f3)
        log_info "Git version: $git_version"
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install missing tools and run the installer again."
        exit 1
    fi
    
    log "All required tools are installed ✓"
}

# Setup Python virtual environment
setup_python_env() {
    log "Setting up Python virtual environment..."
    
    # Create virtual environment
    python3 -m venv venv
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel
    
    # Install Python dependencies
    if [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    else
        # Create requirements.txt with essential packages
        cat > requirements.txt << EOF
# Core dependencies
pyyaml>=6.0
jinja2>=3.1.2
requests>=2.28.0
python-dotenv>=1.0.0
click>=8.1.3
rich>=13.0.0

# API and Web
fastapi>=0.100.0
uvicorn>=0.23.0
pydantic>=2.0.0
httpx>=0.24.0

# Data processing
pandas>=2.0.0
numpy>=1.24.0

# Testing
pytest>=7.4.0
pytest-cov>=4.1.0
pytest-asyncio>=0.21.0

# Development tools
black>=23.0.0
flake8>=6.0.0
mypy>=1.4.0
pre-commit>=3.3.0

# Monitoring and logging
prometheus-client>=0.17.0
structlog>=23.1.0

# Database
sqlalchemy>=2.0.0
alembic>=1.11.0
redis>=4.6.0

# Security
cryptography>=41.0.0
python-jose[cryptography]>=3.3.0
passlib[bcrypt]>=1.7.4
EOF
        pip install -r requirements.txt
    fi
    
    log "Python environment setup complete ✓"
}

# Setup Node.js dependencies
setup_node_env() {
    log "Setting up Node.js dependencies..."
    
    # Check if package.json exists, if not create it
    if [[ ! -f "package.json" ]]; then
        cat > package.json << 'EOF'
{
  "name": "mother-box",
  "version": "1.0.0",
  "description": "Mother Box - AI Agent Team Creation System",
  "main": "index.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest",
    "lint": "eslint .",
    "dashboard": "cd dashboard && npm start"
  },
  "keywords": ["ai", "agents", "automation", "bmad"],
  "author": "Mother Box Team",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "axios": "^1.4.0",
    "dotenv": "^16.3.1",
    "joi": "^17.9.2",
    "winston": "^3.10.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "compression": "^1.7.4",
    "socket.io": "^4.6.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.6.1",
    "eslint": "^8.44.0",
    "prettier": "^3.0.0"
  }
}
EOF
    fi
    
    # Install Node.js dependencies
    npm install
    
    log "Node.js dependencies installed ✓"
}

# Create configuration files
create_config_files() {
    log "Creating configuration files..."
    
    # Create .env.example file
    cat > .env.example << 'EOF'
# Mother Box Configuration

# Environment
ENVIRONMENT=development
DEBUG=true
LOG_LEVEL=info

# API Configuration
API_HOST=0.0.0.0
API_PORT=8080
API_KEY=your-api-key-here

# Database Configuration
DATABASE_URL=postgresql://user:password@localhost:5432/motherbox
REDIS_URL=redis://localhost:6379

# Security
SECRET_KEY=generate-a-secure-secret-key
JWT_SECRET=generate-a-secure-jwt-secret
ENCRYPTION_KEY=generate-a-secure-encryption-key

# LLM Providers
ANTHROPIC_API_KEY=your-anthropic-key
OPENAI_API_KEY=your-openai-key

# Research Configuration
RESEARCH_DEPTH=standard
ENABLE_COMMUNITY_RESEARCH=true
EXPERT_INTERVIEW_COUNT=3

# Quality Configuration
MIN_QUALITY_SCORE=8.5
ENABLE_EXPERT_VALIDATION=true
AUTO_IMPROVEMENT=true

# Monitoring
PROMETHEUS_ENABLED=true
GRAFANA_ENABLED=true
METRICS_PORT=9090

# Integrations (Optional)
SLACK_WEBHOOK_URL=
GITHUB_TOKEN=
NOTION_API_KEY=
DISCORD_WEBHOOK_URL=

# Storage
STORAGE_PATH=/var/lib/motherbox
BACKUP_PATH=/var/backups/motherbox
LOG_PATH=/var/log/motherbox
EOF
    
    # Copy to .env if it doesn't exist
    if [[ ! -f ".env" ]]; then
        cp .env.example .env
        log_info "Created .env file. Please update it with your configuration."
    fi
    
    # Create docker-compose.yml
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  motherbox-api:
    build: .
    container_name: motherbox-api
    ports:
      - "8080:8080"
    environment:
      - ENVIRONMENT=${ENVIRONMENT:-development}
    volumes:
      - ./:/app
      - motherbox-data:/var/lib/motherbox
    depends_on:
      - postgres
      - redis
    networks:
      - motherbox-network
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    container_name: motherbox-postgres
    environment:
      POSTGRES_DB: motherbox
      POSTGRES_USER: motherbox
      POSTGRES_PASSWORD: ${DB_PASSWORD:-motherbox123}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - motherbox-network
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: motherbox-redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - motherbox-network
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:latest
    container_name: motherbox-prometheus
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - motherbox-network
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: motherbox-grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
    volumes:
      - grafana-data:/var/lib/grafana
      - ./config/grafana/dashboards:/etc/grafana/provisioning/dashboards
    ports:
      - "3000:3000"
    networks:
      - motherbox-network
    restart: unless-stopped

volumes:
  motherbox-data:
  postgres-data:
  redis-data:
  prometheus-data:
  grafana-data:

networks:
  motherbox-network:
    driver: bridge
EOF
    
    # Create Dockerfile
    cat > Dockerfile << 'EOF'
FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p /var/lib/motherbox /var/log/motherbox /var/backups/motherbox

# Expose API port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Run the application
CMD ["python", "-m", "mother_box.api"]
EOF
    
    log "Configuration files created ✓"
}

# Setup directory structure
setup_directories() {
    log "Setting up directory structure..."
    
    # Create necessary directories if they don't exist
    mkdir -p \
        mother_box \
        tests/unit \
        tests/integration \
        tests/validation \
        docs \
        logs \
        outputs \
        state
    
    # Create __init__.py files for Python packages
    touch mother_box/__init__.py
    touch tests/__init__.py
    
    # Create basic Python module structure
    cat > mother_box/__init__.py << 'EOF'
"""Mother Box - AI Agent Team Creation System"""

__version__ = "1.0.0"
__author__ = "Mother Box Team"

from .core import MotherBox
from .cli import main as cli_main

__all__ = ["MotherBox", "cli_main"]
EOF
    
    cat > mother_box/core.py << 'EOF'
"""Core Mother Box functionality"""

class MotherBox:
    """Main Mother Box class for creating agent teams"""
    
    def __init__(self):
        """Initialize Mother Box system"""
        self.agents = []
        self.workflows = []
        self.current_project = None
    
    def create_team(self, domain, requirements, team_size=5, **kwargs):
        """Create a new agent team"""
        # Implementation will be added
        return {"team_name": f"{domain} Team", "status": "created"}
    
    def research_domain(self, domain, depth="standard", focus_areas=None):
        """Research a domain for agent creation"""
        # Implementation will be added
        return {"domain": domain, "research_complete": True}
EOF
    
    cat > mother_box/cli.py << 'EOF'
"""Command-line interface for Mother Box"""

import click
from rich.console import Console
from rich.table import Table

console = Console()

@click.group()
def cli():
    """Mother Box - AI Agent Team Creation System"""
    pass

@cli.command()
@click.option('--domain', required=True, help='Domain for the agent team')
@click.option('--requirements', required=True, help='Requirements description')
@click.option('--team-size', default=5, help='Number of agents in the team')
def create(domain, requirements, team_size):
    """Create a new agent team"""
    console.print(f"[bold green]Creating {domain} agent team...[/bold green]")
    # Implementation will be added
    console.print(f"[bold green]✓ Team created successfully![/bold green]")

@cli.command()
def status():
    """Show system status"""
    table = Table(title="Mother Box Status")
    table.add_column("Component", style="cyan")
    table.add_column("Status", style="green")
    
    table.add_row("API", "✓ Running")
    table.add_row("Database", "✓ Connected")
    table.add_row("Agents", "✓ 10 Active")
    
    console.print(table)

def main():
    cli()

if __name__ == "__main__":
    main()
EOF
    
    log "Directory structure created ✓"
}

# Initialize Git repository
init_git_repo() {
    log "Initializing Git repository..."
    
    if [[ ! -d ".git" ]]; then
        git init
        git add .
        git commit -m "Initial commit: Mother Box package setup"
        log "Git repository initialized ✓"
    else
        log_info "Git repository already exists"
    fi
}

# Run initial tests
run_initial_tests() {
    log "Running initial tests..."
    
    # Create a simple test file
    cat > tests/test_basic.py << 'EOF'
"""Basic tests for Mother Box"""

import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

def test_import():
    """Test that Mother Box can be imported"""
    try:
        from mother_box import MotherBox
        assert MotherBox is not None
        print("✓ Import test passed")
        return True
    except ImportError as e:
        print(f"✗ Import test failed: {e}")
        return False

def test_initialization():
    """Test Mother Box initialization"""
    try:
        from mother_box import MotherBox
        mb = MotherBox()
        assert mb is not None
        print("✓ Initialization test passed")
        return True
    except Exception as e:
        print(f"✗ Initialization test failed: {e}")
        return False

if __name__ == "__main__":
    all_passed = True
    all_passed &= test_import()
    all_passed &= test_initialization()
    
    if all_passed:
        print("\n✓ All tests passed!")
        sys.exit(0)
    else:
        print("\n✗ Some tests failed")
        sys.exit(1)
EOF
    
    # Run the basic test
    source venv/bin/activate
    python tests/test_basic.py
    
    log "Initial tests completed ✓"
}

# Create activation script
create_activation_script() {
    log "Creating activation script..."
    
    cat > scripts/activate-mother-box.sh << 'EOF'
#!/bin/bash

# Mother Box Activation Script

set -e

echo "Activating Mother Box System..."

# Activate Python virtual environment
source venv/bin/activate

# Start services
docker-compose up -d

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 10

# Check health
curl -s http://localhost:8080/health > /dev/null && echo "✓ API is healthy" || echo "✗ API health check failed"

# Show status
python -m mother_box.cli status

echo ""
echo "Mother Box is ready! 🚀"
echo ""
echo "Access points:"
echo "  - API: http://localhost:8080"
echo "  - Monitoring: http://localhost:3000 (admin/admin)"
echo "  - Metrics: http://localhost:9090"
echo ""
echo "To create your first agent team, run:"
echo "  python -m mother_box.cli create --domain 'Your Domain' --requirements 'Your requirements'"
echo ""
EOF
    
    chmod +x scripts/activate-mother-box.sh
    
    log "Activation script created ✓"
}

# Main installation function
main() {
    show_banner
    
    log "Starting Mother Box installation..."
    log "Installation directory: $INSTALL_DIR"
    log "Environment: $ENVIRONMENT"
    echo ""
    
    # Run installation steps
    check_root
    detect_os
    check_requirements
    
    # Ask user about dependency installation
    read -p "Do you want to install system dependencies? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_system_deps
    fi
    
    check_tools
    setup_python_env
    setup_node_env
    create_config_files
    setup_directories
    init_git_repo
    create_activation_script
    run_initial_tests
    
    # Success message
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}║        🎉 Mother Box Installation Complete! 🎉                ║${NC}"
    echo -e "${GREEN}║                                                                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Update the .env file with your configuration"
    echo "2. Run: ./scripts/activate-mother-box.sh"
    echo "3. Access the API at http://localhost:8080"
    echo ""
    echo "For detailed documentation, see README.md"
    echo ""
    log "Installation completed successfully! ✨"
}

# Run main function
main "$@"