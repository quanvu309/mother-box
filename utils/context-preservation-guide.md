# Context Preservation Guide
# Mother Box Framework - Maintaining Context Across Long Workflows

## Overview
This guide provides patterns and best practices for maintaining context during complex agent workflows to prevent token exhaustion and ensure continuity.

## Context Preservation Triggers

### 1. Token-Based Triggers
**Threshold**: 50% of context window
**Action**: Automatic doc-out with context summary
```yaml
trigger:
  type: token_threshold
  value: 50%
  action: "*doc-out --context"
  format: structured_summary
```

### 2. Complexity-Based Triggers
**Threshold**: 5+ decisions or 3+ analysis layers
**Action**: Checkpoint current state
```yaml
trigger:
  type: complexity_threshold
  decisions_made: 5
  analysis_depth: 3
  action: "*doc-out --checkpoint"
```

### 3. Time-Based Triggers
**Interval**: Every 10 minutes of active work
**Action**: Progressive documentation
```yaml
trigger:
  type: time_based
  interval_minutes: 10
  action: "*doc-out --mini"
```

### 4. Event-Based Triggers
Critical workflow events that require context preservation:
```yaml
triggers:
  - event: agent_handoff
    action: "*doc-out --handoff"
  - event: phase_completion
    action: "*doc-out --checkpoint"
  - event: quality_gate
    action: "*doc-out --context"
  - event: error_encountered
    action: "*doc-out --debug"
```

## Documentation Levels

### Micro Documentation (1-2 lines)
**When**: After each significant decision
**Format**: 
```
Decision: [action] | Rationale: [why] | Next: [what]
```

### Mini Documentation (5-10 lines)
**When**: End of each subtask
**Format**:
```markdown
## Subtask: [Name]
- **Completed**: [What was done]
- **Key Decisions**: [List]
- **Output**: [Result]
- **Next Step**: [What comes next]
```

### Checkpoint Documentation (Full section)
**When**: Phase transitions or major milestones
**Format**:
```yaml
checkpoint:
  phase: [Current Phase]
  timestamp: [ISO 8601]
  objectives_completed:
    - [Objective 1]
    - [Objective 2]
  decisions_made:
    - decision: [What]
      rationale: [Why]
      impact: [Result]
  current_state:
    context: [User goal]
    progress: [% complete]
    blockers: [List]
  next_actions:
    - [Action 1]
    - [Action 2]
```

### Full Documentation (Complete dump)
**When**: Token threshold reached or major handoff
**Format**: Complete structured output including all context, decisions, rationale, and state

## Doc-Out Command Variations

### Standard Commands
```bash
*doc-out              # Full documentation with all context
*doc-out --context    # Current state and decisions only
*doc-out --handoff    # Prepare context for agent transition
*doc-out --checkpoint # Create workflow checkpoint
*doc-out --mini       # Brief summary (5-10 lines)
*doc-out --debug      # Include error context and diagnostics
```

### Agent-Specific Examples

#### Analyst Doc-Out
```yaml
*doc-out --handoff:
  discovered_requirements:
    - [Requirement 1]
    - [Requirement 2]
  user_preferences:
    - [Preference 1]
  gaps_identified:
    - [Gap 1]
  next_agent: researcher
  handoff_context: "Need domain research on [topics]"
```

#### PM Doc-Out
```yaml
*doc-out --checkpoint:
  blueprint_status: [% complete]
  agents_defined: [List]
  integration_points: [List]
  pending_decisions: [List]
  quality_score: [X/10]
```

## Implementation in Agent Files

### Core Principles Addition
Every agent should include these principles:
```yaml
core_principles:
  - Context Preservation: Proactively doc-out at 50% token usage or before handoffs
  - LLM Optimization: Use structured outputs and pattern completion for consistency
  - State Awareness: Track decisions, rationale, and next steps continuously
```

### Commands Section Enhancement
```yaml
commands:
  doc-out:
    description: "Output documentation with context preservation"
    variations:
      - "doc-out: Full documentation"
      - "doc-out --context: State summary"
      - "doc-out --handoff: Agent transition"
      - "doc-out --checkpoint: Phase checkpoint"
  context-status:
    description: "Show current context usage"
```

## Workflow Integration

### Phase Transitions
Always trigger full doc-out at phase boundaries:
```yaml
- id: phase-complete
  action: Complete current phase
  context_preservation: doc-out --full
  handoff: next-phase-agents
```

### Agent Handoffs
Preserve context during agent transitions:
```yaml
- id: handoff
  from: analyst
  to: researcher
  context_preservation: doc-out --handoff
  include:
    - key_findings
    - open_questions
    - user_context
```

## Best Practices

### 1. Proactive Preservation
- Don't wait for token limits
- Document before complexity increases
- Checkpoint at natural boundaries

### 2. Structured Output
- Use consistent formats
- Include timestamps
- Tag with phase/agent

### 3. Progressive Detail
- Start with micro docs
- Build to mini summaries
- Checkpoint at milestones
- Full dump when needed

### 4. Context Relevance
- Focus on decisions and rationale
- Preserve user goals
- Track what changed and why
- Identify next actions

### 5. Handoff Quality
- Include everything next agent needs
- Highlight open questions
- Provide clear context
- Specify expected outcomes

## LLM Optimization Patterns

### Pattern Completion
Use consistent patterns for predictable behavior:
```
As [Agent Role], I will [action] because [rationale].
This aligns with [principle] and moves us toward [goal].
```

### Structured Thinking
```
Assessment: [Current situation]
Decision: [What I'm doing]
Rationale: [Why this approach]
Impact: [Expected outcome]
Next: [What comes after]
```

### Role Reinforcement
Every 3rd response, reinforce role:
```
"As the Mother Box [Agent], my focus is [core responsibility]..."
```

## Monitoring and Alerts

### Context Usage Monitoring
```yaml
*context-status:
  token_usage: 45%
  decisions_made: 4
  time_elapsed: 8min
  next_trigger: token_threshold @ 50%
```

### Alert Thresholds
- 40% tokens: Warning
- 50% tokens: Auto doc-out
- 60% tokens: Forced checkpoint
- 70% tokens: Handoff required

## Recovery Procedures

### From Context Loss
1. Load last checkpoint
2. Review decisions made
3. Confirm current state
4. Resume from last action

### From Incomplete Handoff
1. Request context from previous agent
2. Review available documentation
3. Clarify gaps with orchestrator
4. Proceed with caution

## Validation Checklist

- [ ] All agents have context preservation principles
- [ ] Doc-out commands properly configured
- [ ] Workflow triggers at key points
- [ ] Handoff protocols include context
- [ ] Checkpoint formats standardized
- [ ] Recovery procedures documented
- [ ] Monitoring thresholds set
- [ ] LLM patterns implemented

## Quick Reference Card

```
Token > 50%        → *doc-out --context
Decisions > 5      → *doc-out --checkpoint  
Time > 10min       → *doc-out --mini
Agent handoff      → *doc-out --handoff
Phase complete     → *doc-out --full
Error encountered  → *doc-out --debug
Quality gate       → *doc-out --checkpoint
```

---
*Remember: Context preservation is not optional - it's essential for maintaining quality and continuity in complex agent workflows.*