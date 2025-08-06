# Team Template Guide

## Overview
Team templates define the composition and coordination of multiple agents working together. Unlike individual agent definitions (which follow `agent-definition-template.md`), team templates are YAML configurations that specify team structure, workflows, and integration.

## Structure Difference

### Individual Agent (uses agent-definition-template.md)
- Single agent definition file in Markdown format
- Contains complete persona and behavior
- Self-contained with commands and dependencies
- Located in `/agents/` directory

### Team Template (this guide)
- Team composition file in YAML format
- References multiple agents
- Defines workflows and coordination
- Located in `/templates/team-templates/` directory

## Team Template Structure

```yaml
# Team Template Structure
team:
  name: "Team Name"
  domain: "Domain/Industry"
  size: number_of_agents
  architecture: "Coordination pattern"
  context_preservation: enabled  # New addition

agents:
  # For each agent in the team
  - name: "Agent Display Name"
    id: "unique-agent-id"
    role: "Brief role description"
    # Reference to full agent definition
    agent_definition: "agents/[agent-name].md"  # Points to full definition
    personality:
      traits: "Key personality traits"
      background: "Professional background"
      communication: "Communication style"
    capabilities:
      - "Capability 1"
      - "Capability 2"
    commands:
      - "*command1"
      - "*command2"
    context_triggers:  # New addition
      - token_threshold: 50%
      - handoff: always
      - complexity: 5_decisions

workflows:
  workflow_name:
    trigger: "When this workflow starts"
    context_preservation: checkpoint  # New addition
    steps:
      1:
        agent: "agent-id"
        action: "What the agent does"
        doc_out: "trigger type"  # New addition
      2:
        parallel:  # Optional parallel execution
          - agent: "agent-id-1"
            action: "Action 1"
          - agent: "agent-id-2"
            action: "Action 2"

integrations:
  - name: "Tool/Platform"
    purpose: "Why it's used"
    agents: ["agent-id-1", "agent-id-2"]

success_metrics:
  - metric: "Metric name"
    target: "Target value"
    owner: "responsible-agent-id"

customization_points:
  setting_name: ["Option1", "Option2"]
```

## Relationship to Agent Definitions

### Team Template References
Each agent in the team template should have:
1. **Summary info** in the team template (for quick reference)
2. **Full definition** in a separate file following `agent-definition-template.md`

Example:
```yaml
agents:
  - name: "Data Analyst"
    id: "data-analyst"
    agent_definition: "agents/data-analyst.md"  # Full definition here
    # Summary info for team coordination
    role: "Data analysis and insights"
    capabilities: ["SQL", "Python", "Statistics"]
```

### Creating Agents for Teams

1. **Step 1**: Define team structure in team template
2. **Step 2**: Create individual agents using `agent-definition-template.md`
3. **Step 3**: Link agents in team template to their definitions

## Enhanced Team Template with Context Preservation

```yaml
# Modern team template with context preservation
team:
  name: "Development Team"
  context_preservation:
    enabled: true
    strategy: progressive
    checkpoints:
      - phase_completion
      - agent_handoff
      - complexity_threshold

agents:
  - name: "Tech Lead"
    id: "tech-lead"
    agent_definition: "agents/tech-lead.md"
    context_role: orchestrator  # Manages team context
    context_triggers:
      - type: token_threshold
        value: 40%  # Lower threshold for orchestrator
        action: team_checkpoint
      - type: team_handoff
        action: full_context_transfer

workflows:
  feature_development:
    context_strategy: incremental
    steps:
      1:
        agent: "tech-lead"
        action: "Review requirements"
        context_output: requirements_summary
      2:
        agent: "developer"
        action: "Implement feature"
        context_input: requirements_summary
        context_output: implementation_notes
      3:
        agent: "qa"
        action: "Test feature"
        context_input: implementation_notes
        context_preservation: checkpoint

context_preservation:
  team_triggers:
    - type: workflow_completion
      action: full_team_doc_out
    - type: blocker_encountered
      action: context_checkpoint
    - type: shift_change  # Team handoff
      action: comprehensive_handoff
  
  documentation_protocol:
    micro: "Each agent decision"
    mini: "Step completion"
    checkpoint: "Phase boundary"
    full: "Workflow completion"
```

## Best Practices

### 1. Team Composition
- Include 5-10 agents maximum for manageability
- Define clear role boundaries
- Avoid overlapping responsibilities
- Include at least one orchestrator/coordinator

### 2. Workflow Design
- Keep workflows under 10 steps
- Use parallel execution where possible
- Include validation steps
- Add context preservation points

### 3. Integration Points
- List all external tools/platforms
- Specify which agents use each tool
- Document API/interface requirements

### 4. Success Metrics
- Define measurable targets
- Assign clear ownership
- Include both team and individual metrics

### 5. Context Management
- Add context triggers for each agent
- Define handoff protocols
- Specify documentation levels
- Include recovery procedures

## Examples

### Good Team Template Structure
✅ Clear agent roles
✅ Well-defined workflows
✅ Context preservation built-in
✅ Measurable success criteria
✅ Links to full agent definitions

### What NOT to Do
❌ Don't put full agent definitions in team template
❌ Don't create overlapping roles
❌ Don't skip context preservation
❌ Don't forget integration details
❌ Don't omit success metrics

## File Organization

```
mother-box/
├── agents/                          # Individual agent definitions
│   ├── data-analyst.md             # Full agent using agent-definition-template.md
│   ├── ml-specialist.md            # Full agent using agent-definition-template.md
│   └── ...
├── templates/
│   ├── agent-definition-template.md # Template for individual agents
│   ├── team-template-guide.md      # This file
│   └── team-templates/             # Team compositions
│       ├── data-analytics-team.yaml
│       ├── devops-team.yaml
│       └── ...
```

## Creating a New Team

1. **Plan the team**:
   - Identify needed roles
   - Define workflows
   - Determine integrations

2. **Create team template**:
   ```bash
   cp templates/team-templates/example-team.yaml \
      templates/team-templates/my-team.yaml
   ```

3. **Create individual agents**:
   ```bash
   # For each agent in the team
   cp templates/agent-definition-template.md \
      agents/my-agent.md
   ```

4. **Link agents to team**:
   - Add agent references in team template
   - Ensure agent IDs match

5. **Add context preservation**:
   - Define team-level triggers
   - Add workflow checkpoints
   - Specify handoff protocols

## Validation Checklist

- [ ] Team has clear purpose and domain
- [ ] All agents have defined roles
- [ ] Workflows cover main scenarios
- [ ] Context preservation configured
- [ ] Success metrics defined
- [ ] Integrations documented
- [ ] Each agent has full definition file
- [ ] No role overlaps or gaps
- [ ] Handoff protocols specified
- [ ] Documentation levels defined

---
*Remember: Team templates orchestrate agents, while agent definitions (using agent-definition-template.md) define individual behaviors.*