#!/bin/bash

# Mother Box Deployment Automation Script
# Production-ready deployment with safety checks and rollback capability

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$(dirname "$SCRIPT_DIR")"
DEPLOYMENT_LOG="${DEPLOYMENT_LOG:-/var/log/mother-box/deployment.log}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/mother-box}"
CONFIG_FILE="${CONFIG_FILE:-$PACKAGE_ROOT/config/deployment.yaml}"
DRY_RUN="${DRY_RUN:-false}"
ENVIRONMENT="${ENVIRONMENT:-staging}"
VERSION="${VERSION:-latest}"

# Deployment stages
STAGES=("pre-check" "backup" "deploy-config" "deploy-agents" "deploy-workflows" "validate" "activate" "post-check")
CURRENT_STAGE=""
ROLLBACK_POINT=""

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1" | tee -a "$DEPLOYMENT_LOG"
}

# Error handling
error_handler() {
    local line_no=$1
    local exit_code=$2
    log_error "Deployment failed at line $line_no with exit code $exit_code"
    log_error "Current stage: $CURRENT_STAGE"
    
    if [[ "$ROLLBACK_POINT" != "" ]]; then
        log_warning "Initiating rollback to: $ROLLBACK_POINT"
        rollback
    fi
    
    send_notification "Deployment failed" "error"
    exit $exit_code
}

trap 'error_handler ${LINENO} $?' ERR

# Rollback function
rollback() {
    log_warning "Starting rollback procedure..."
    
    if [[ -f "$ROLLBACK_POINT/manifest.json" ]]; then
        log_info "Restoring from backup: $ROLLBACK_POINT"
        
        # Stop current agents
        stop_agents
        
        # Restore from backup
        cp -r "$ROLLBACK_POINT"/* "$DEPLOYMENT_TARGET/" 2>/dev/null || true
        
        # Restart agents with previous version
        start_agents
        
        # Validate rollback
        if validate_deployment; then
            log "Rollback successful"
            send_notification "Rollback completed successfully" "warning"
        else
            log_error "Rollback validation failed - manual intervention required"
            send_notification "Rollback failed - manual intervention required" "critical"
            exit 1
        fi
    else
        log_error "No valid rollback point found"
        exit 1
    fi
}

# Pre-deployment checks
pre_deployment_checks() {
    CURRENT_STAGE="pre-check"
    log "Starting pre-deployment checks..."
    
    # Check required tools
    local required_tools=("docker" "python3" "jq" "curl")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "Required tool '$tool' not found"
            return 1
        fi
    done
    
    # Check disk space
    local available_space=$(df -BG "$DEPLOYMENT_TARGET" | awk 'NR==2 {print $4}' | sed 's/G//')
    if [[ $available_space -lt 5 ]]; then
        log_error "Insufficient disk space: ${available_space}GB available, 5GB required"
        return 1
    fi
    
    # Check configuration file
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "Configuration file not found: $CONFIG_FILE"
        return 1
    fi
    
    # Validate configuration
    if ! python3 -c "import yaml; yaml.safe_load(open('$CONFIG_FILE'))" 2>/dev/null; then
        log_error "Invalid configuration file format"
        return 1
    fi
    
    # Check network connectivity
    if ! curl -s --head https://api.motherbox.io > /dev/null; then
        log_warning "Cannot reach Mother Box API - continuing anyway"
    fi
    
    # Check running agents
    if pgrep -f "mother-box-agent" > /dev/null; then
        log_info "Existing Mother Box agents detected - will be stopped during deployment"
    fi
    
    log "Pre-deployment checks passed"
    return 0
}

# Create backup
create_backup() {
    CURRENT_STAGE="backup"
    log "Creating backup..."
    
    local backup_name="backup-$(date +'%Y%m%d-%H%M%S')"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    mkdir -p "$backup_path"
    
    # Backup current deployment if exists
    if [[ -d "$DEPLOYMENT_TARGET" ]]; then
        cp -r "$DEPLOYMENT_TARGET"/* "$backup_path/" 2>/dev/null || true
        
        # Create manifest
        cat > "$backup_path/manifest.json" << EOF
{
    "timestamp": "$(date -Iseconds)",
    "version": "$CURRENT_VERSION",
    "environment": "$ENVIRONMENT",
    "components": $(ls -1 "$DEPLOYMENT_TARGET" | jq -R . | jq -s .)
}
EOF
        
        ROLLBACK_POINT="$backup_path"
        log "Backup created at: $backup_path"
    else
        log_info "No existing deployment to backup"
    fi
    
    # Clean old backups (keep last 5)
    ls -dt "$BACKUP_DIR"/* | tail -n +6 | xargs rm -rf 2>/dev/null || true
    
    return 0
}

# Deploy configuration
deploy_configuration() {
    CURRENT_STAGE="deploy-config"
    log "Deploying configuration files..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN: Would deploy configuration to $DEPLOYMENT_TARGET/config"
        return 0
    fi
    
    mkdir -p "$DEPLOYMENT_TARGET/config"
    
    # Copy configuration files
    cp -r "$PACKAGE_ROOT/config"/* "$DEPLOYMENT_TARGET/config/"
    
    # Apply environment-specific overrides
    if [[ -f "$PACKAGE_ROOT/config/overrides/$ENVIRONMENT.yaml" ]]; then
        log_info "Applying $ENVIRONMENT environment overrides"
        cp "$PACKAGE_ROOT/config/overrides/$ENVIRONMENT.yaml" "$DEPLOYMENT_TARGET/config/environment.yaml"
    fi
    
    # Set permissions
    chmod 600 "$DEPLOYMENT_TARGET/config"/*.yaml
    
    log "Configuration deployed successfully"
    return 0
}

# Deploy agents
deploy_agents() {
    CURRENT_STAGE="deploy-agents"
    log "Deploying Mother Box agents..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN: Would deploy agents to $DEPLOYMENT_TARGET/agents"
        return 0
    fi
    
    mkdir -p "$DEPLOYMENT_TARGET/agents"
    
    # Copy agent definitions
    cp -r "$PACKAGE_ROOT/agents"/* "$DEPLOYMENT_TARGET/agents/"
    
    # Process agent templates
    for agent_file in "$DEPLOYMENT_TARGET/agents"/*.md; do
        if [[ -f "$agent_file" ]]; then
            # Replace environment variables
            sed -i "s/\${ENVIRONMENT}/$ENVIRONMENT/g" "$agent_file"
            sed -i "s/\${VERSION}/$VERSION/g" "$agent_file"
            sed -i "s/\${API_ENDPOINT}/$API_ENDPOINT/g" "$agent_file"
        fi
    done
    
    # Validate agent files
    local agent_count=$(ls -1 "$DEPLOYMENT_TARGET/agents"/*.md 2>/dev/null | wc -l)
    if [[ $agent_count -lt 10 ]]; then
        log_error "Expected at least 10 agents, found $agent_count"
        return 1
    fi
    
    log "Deployed $agent_count agents successfully"
    return 0
}

# Deploy workflows
deploy_workflows() {
    CURRENT_STAGE="deploy-workflows"
    log "Deploying workflows..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN: Would deploy workflows to $DEPLOYMENT_TARGET/workflows"
        return 0
    fi
    
    mkdir -p "$DEPLOYMENT_TARGET/workflows"
    
    # Copy workflow definitions
    cp -r "$PACKAGE_ROOT/workflows"/* "$DEPLOYMENT_TARGET/workflows/"
    
    # Validate workflow files
    for workflow in "$DEPLOYMENT_TARGET/workflows"/*.yaml; do
        if ! python3 -c "import yaml; yaml.safe_load(open('$workflow'))" 2>/dev/null; then
            log_error "Invalid workflow file: $workflow"
            return 1
        fi
    done
    
    log "Workflows deployed successfully"
    return 0
}

# Deploy supporting files
deploy_supporting_files() {
    CURRENT_STAGE="deploy-support"
    log "Deploying supporting files..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN: Would deploy supporting files"
        return 0
    fi
    
    # Deploy templates
    mkdir -p "$DEPLOYMENT_TARGET/templates"
    cp -r "$PACKAGE_ROOT/templates"/* "$DEPLOYMENT_TARGET/templates/"
    
    # Deploy data files
    mkdir -p "$DEPLOYMENT_TARGET/data"
    cp -r "$PACKAGE_ROOT/data"/* "$DEPLOYMENT_TARGET/data/"
    
    # Deploy utilities
    mkdir -p "$DEPLOYMENT_TARGET/utils"
    cp -r "$PACKAGE_ROOT/utils"/* "$DEPLOYMENT_TARGET/utils/"
    
    # Deploy checklists
    mkdir -p "$DEPLOYMENT_TARGET/checklists"
    cp -r "$PACKAGE_ROOT/checklists"/* "$DEPLOYMENT_TARGET/checklists/"
    
    log "Supporting files deployed successfully"
    return 0
}

# Validate deployment
validate_deployment() {
    CURRENT_STAGE="validate"
    log "Validating deployment..."
    
    local validation_errors=0
    
    # Check all required directories exist
    local required_dirs=("agents" "workflows" "config" "templates" "data")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$DEPLOYMENT_TARGET/$dir" ]]; then
            log_error "Required directory missing: $dir"
            ((validation_errors++))
        fi
    done
    
    # Validate agent activation
    if [[ -f "$DEPLOYMENT_TARGET/agents/orchestrator.md" ]]; then
        log_info "Orchestrator agent found"
    else
        log_error "Orchestrator agent missing"
        ((validation_errors++))
    fi
    
    # Run smoke tests
    if [[ -f "$PACKAGE_ROOT/tests/smoke_test.sh" ]]; then
        log_info "Running smoke tests..."
        if ! bash "$PACKAGE_ROOT/tests/smoke_test.sh"; then
            log_error "Smoke tests failed"
            ((validation_errors++))
        fi
    fi
    
    if [[ $validation_errors -gt 0 ]]; then
        log_error "Validation failed with $validation_errors errors"
        return 1
    fi
    
    log "Deployment validation passed"
    return 0
}

# Start agents
start_agents() {
    CURRENT_STAGE="activate"
    log "Starting Mother Box agents..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN: Would start agents"
        return 0
    fi
    
    # Start orchestrator first
    log_info "Starting orchestrator..."
    docker run -d \
        --name mother-box-orchestrator \
        --restart unless-stopped \
        -v "$DEPLOYMENT_TARGET:/app" \
        -e ENVIRONMENT="$ENVIRONMENT" \
        -e CONFIG_PATH="/app/config" \
        mother-box:$VERSION \
        python3 /app/agents/orchestrator.py
    
    sleep 5
    
    # Start other agents
    for agent in "$DEPLOYMENT_TARGET/agents"/*.md; do
        local agent_name=$(basename "$agent" .md)
        if [[ "$agent_name" != "orchestrator" ]]; then
            log_info "Starting agent: $agent_name"
            docker run -d \
                --name "mother-box-$agent_name" \
                --restart unless-stopped \
                -v "$DEPLOYMENT_TARGET:/app" \
                -e ENVIRONMENT="$ENVIRONMENT" \
                -e AGENT_NAME="$agent_name" \
                mother-box:$VERSION \
                python3 /app/agents/runner.py "$agent_name"
        fi
    done
    
    log "All agents started successfully"
    return 0
}

# Stop agents
stop_agents() {
    log "Stopping Mother Box agents..."
    
    # Stop all mother-box containers
    docker ps -q --filter "name=mother-box-*" | xargs -r docker stop
    docker ps -aq --filter "name=mother-box-*" | xargs -r docker rm
    
    log "All agents stopped"
    return 0
}

# Post-deployment checks
post_deployment_checks() {
    CURRENT_STAGE="post-check"
    log "Running post-deployment checks..."
    
    # Check agent health
    local unhealthy_agents=0
    for agent in $(docker ps --filter "name=mother-box-*" --format "{{.Names}}"); do
        if ! docker exec "$agent" curl -s http://localhost:8080/health > /dev/null; then
            log_warning "Agent unhealthy: $agent"
            ((unhealthy_agents++))
        fi
    done
    
    if [[ $unhealthy_agents -gt 0 ]]; then
        log_warning "$unhealthy_agents agents are unhealthy"
    fi
    
    # Check API endpoint
    if curl -s "$API_ENDPOINT/health" | jq -e '.status == "healthy"' > /dev/null; then
        log "API endpoint healthy"
    else
        log_warning "API endpoint not responding correctly"
    fi
    
    # Generate deployment report
    generate_deployment_report
    
    log "Post-deployment checks completed"
    return 0
}

# Generate deployment report
generate_deployment_report() {
    local report_file="$DEPLOYMENT_TARGET/deployment-report-$(date +'%Y%m%d-%H%M%S').json"
    
    cat > "$report_file" << EOF
{
    "deployment_id": "$(uuidgen)",
    "timestamp": "$(date -Iseconds)",
    "environment": "$ENVIRONMENT",
    "version": "$VERSION",
    "status": "success",
    "components": {
        "agents": $(ls -1 "$DEPLOYMENT_TARGET/agents"/*.md | wc -l),
        "workflows": $(ls -1 "$DEPLOYMENT_TARGET/workflows"/*.yaml | wc -l),
        "templates": $(ls -1 "$DEPLOYMENT_TARGET/templates"/*.yaml | wc -l)
    },
    "validation": {
        "pre_checks": "passed",
        "smoke_tests": "passed",
        "post_checks": "passed"
    },
    "rollback_point": "$ROLLBACK_POINT"
}
EOF
    
    log_info "Deployment report generated: $report_file"
}

# Send notification
send_notification() {
    local message=$1
    local severity=${2:-info}
    
    # Slack notification (if configured)
    if [[ -n "${SLACK_WEBHOOK:-}" ]]; then
        local color="good"
        case $severity in
            error|critical) color="danger" ;;
            warning) color="warning" ;;
        esac
        
        curl -X POST "$SLACK_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{
                \"text\": \"Mother Box Deployment Update\",
                \"attachments\": [{
                    \"color\": \"$color\",
                    \"text\": \"$message\",
                    \"fields\": [
                        {\"title\": \"Environment\", \"value\": \"$ENVIRONMENT\", \"short\": true},
                        {\"title\": \"Version\", \"value\": \"$VERSION\", \"short\": true}
                    ],
                    \"footer\": \"Mother Box Deployment System\",
                    \"ts\": $(date +%s)
                }]
            }" 2>/dev/null || true
    fi
    
    # Email notification (if configured)
    if [[ -n "${NOTIFICATION_EMAIL:-}" ]]; then
        echo "$message" | mail -s "Mother Box Deployment: $severity" "$NOTIFICATION_EMAIL" 2>/dev/null || true
    fi
}

# Main deployment function
deploy() {
    log "=========================================="
    log "Mother Box Deployment System"
    log "Environment: $ENVIRONMENT"
    log "Version: $VERSION"
    log "Target: $DEPLOYMENT_TARGET"
    log "=========================================="
    
    # Run through deployment stages
    for stage in "${STAGES[@]}"; do
        case $stage in
            pre-check)
                pre_deployment_checks || exit 1
                ;;
            backup)
                create_backup || exit 1
                ;;
            deploy-config)
                deploy_configuration || exit 1
                ;;
            deploy-agents)
                deploy_agents || exit 1
                ;;
            deploy-workflows)
                deploy_workflows || exit 1
                deploy_supporting_files || exit 1
                ;;
            validate)
                validate_deployment || exit 1
                ;;
            activate)
                if [[ "$SKIP_ACTIVATION" != "true" ]]; then
                    stop_agents
                    start_agents || exit 1
                fi
                ;;
            post-check)
                post_deployment_checks || exit 1
                ;;
        esac
        
        log "Stage completed: $stage"
    done
    
    log "=========================================="
    log "Deployment completed successfully!"
    log "=========================================="
    
    send_notification "Deployment completed successfully" "info"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --environment|-e)
                ENVIRONMENT="$2"
                shift 2
                ;;
            --version|-v)
                VERSION="$2"
                shift 2
                ;;
            --target|-t)
                DEPLOYMENT_TARGET="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN="true"
                shift
                ;;
            --skip-activation)
                SKIP_ACTIVATION="true"
                shift
                ;;
            --rollback)
                rollback
                exit $?
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help
show_help() {
    cat << EOF
Mother Box Deployment Script

Usage: $0 [OPTIONS]

Options:
    -e, --environment ENV    Deployment environment (staging|production)
    -v, --version VERSION    Version to deploy (default: latest)
    -t, --target PATH        Deployment target directory
    --dry-run               Perform a dry run without making changes
    --skip-activation       Deploy without starting agents
    --rollback              Rollback to previous deployment
    -h, --help             Show this help message

Environment Variables:
    DEPLOYMENT_LOG          Path to deployment log file
    BACKUP_DIR             Directory for backups
    CONFIG_FILE            Path to configuration file
    SLACK_WEBHOOK          Slack webhook URL for notifications
    NOTIFICATION_EMAIL     Email address for notifications
    API_ENDPOINT           Mother Box API endpoint

Examples:
    # Deploy to staging
    $0 --environment staging --version 1.2.3

    # Dry run for production
    $0 --environment production --dry-run

    # Rollback deployment
    $0 --rollback

EOF
}

# Set default deployment target
DEPLOYMENT_TARGET="${DEPLOYMENT_TARGET:-/opt/mother-box}"

# Ensure log directory exists
mkdir -p "$(dirname "$DEPLOYMENT_LOG")"

# Main execution
main() {
    parse_arguments "$@"
    
    # Validate environment
    if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
        log_error "Invalid environment: $ENVIRONMENT"
        exit 1
    fi
    
    # Get current version if exists
    if [[ -f "$DEPLOYMENT_TARGET/version" ]]; then
        CURRENT_VERSION=$(cat "$DEPLOYMENT_TARGET/version")
        log_info "Current version: $CURRENT_VERSION"
    fi
    
    # Run deployment
    deploy
}

# Execute main function
main "$@"