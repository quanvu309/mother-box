# BMAD Patterns for Mother Box

Essential patterns and best practices for creating BMAD-compliant agent teams.

## Agent Definition Patterns

### Activation Pattern
```yaml
activation-instructions:
  - STEP 1: Read THIS ENTIRE FILE - it contains your complete persona definition
  - STEP 2: Adopt the persona defined in the 'agent' and 'persona' sections below
  - STEP 3: Greet user with your name/role and mention `*help` command
  - DO NOT: Load any other agent files during activation
  - ONLY load dependency files when user selects them for execution
  - CRITICAL: [Role-specific critical instruction]
  - On activation, ONLY greet user and then HALT to await user requested assistance
```

### Command Pattern
```yaml
commands: # All commands require * prefix when used
  - help: Show numbered list of commands
  - [action]: [Description of what command does]
  - yolo: Toggle skip confirmations mode
  - doc-out: Output documentation
  - exit: Complete session and return
```

### Persona Pattern
```yaml
persona:
  role: [Primary function and expertise]
  style: [Adjectives describing communication style]
  identity: [Core identity statement]
  focus: [Main areas of focus]
  core_principles:
    - [Principle 1]: [Explanation]
    - [Principle 2]: [Explanation]
    # ... up to 10 principles
    - Numbered Options Protocol: Always use numbered lists for selections
```

## Prompt Engineering Patterns

### Role Establishment Pattern
Strong role establishment that prevents drift:
```
You are [Name], a [Role] with [X years] experience in [Domain].
Your primary mission is [Core Purpose].
You ALWAYS [Key Behavior 1].
You NEVER [Key Restriction 1].
```

### Decision Authority Pattern
Clear decision-making boundaries:
```
You CAN decide:
- [Decision type 1]
- [Decision type 2]

You MUST escalate:
- [Escalation trigger 1]
- [Escalation trigger 2]

You REFER to [Other Agent] for:
- [Their domain 1]
- [Their domain 2]
```

### Context Preservation Pattern
Maintaining context across interactions:
```yaml
context-management:
  preserve:
    - Current project state
    - User preferences
    - Previous decisions
    - Open issues
  update:
    - After each interaction
    - At phase transitions
    - When decisions made
  format:
    structured: JSON object
    versioned: true
    shareable: between agents
```

## Communication Patterns

### Direct Message Pattern
```
FROM: @[SourceAgent]
TO: @[TargetAgent]
REQUEST: [Specific request]
CONTEXT: [Relevant background]
DEADLINE: [When needed]
FORMAT: [Expected response format]
```

### Handoff Pattern
```
HANDOFF INITIATED
FROM: [Current Agent]
TO: [Next Agent]
STATUS: [Work completed]
REMAINING: [Work to be done]
CONTEXT: [Full context object]
DEPENDENCIES: [What's needed]
```

### Event Notification Pattern
```
EVENT: [EventType]
SOURCE: [Agent/System]
TIMESTAMP: [ISO 8601]
DATA: [Event payload]
HANDLERS: [Agents to respond]
```

## Task Patterns

### Elicitation Task Pattern
```markdown
## Step N: [Elicitation Goal]

Ask these questions (one at a time):
1. [Question 1]
2. [Question 2]

Based on answers, probe deeper:
- If [condition], ask [follow-up]
- If [condition], explore [area]

KEY PRINCIPLE: [Guiding principle]
```

### Validation Task Pattern
```markdown
## Validation Process

Present findings:
"Let me confirm what I understood..."
- Point 1: [Summary]
- Point 2: [Summary]

Get confirmation:
- "Is this accurate?"
- "What did I miss?"
- "What should I adjust?"

Document result:
- Confirmed: [Yes/No]
- Changes: [List]
- Next steps: [Actions]
```

## Quality Patterns

### Review Pattern
```yaml
review-criteria:
  clarity:
    - Unambiguous instructions
    - Clear outputs defined
    - No vague language
  consistency:
    - Voice matches role
    - Terminology uniform
    - Patterns consistent
  completeness:
    - All sections present
    - Dependencies listed
    - Error handling included
  compliance:
    - BMAD format followed
    - Standards met
    - Best practices applied
```

### Gate Pattern
```yaml
quality-gate:
  name: [Gate Name]
  phase: [When it occurs]
  owner: [Responsible agent]
  criteria:
    - [Criterion 1]: [How measured]
    - [Criterion 2]: [How measured]
  minimum-score: [X/10]
  actions:
    pass: [Next step]
    fail: [Remediation]
```

## Integration Patterns

### Sequential Work Pattern
```yaml
sequence:
  - step: 1
    agent: [Agent A]
    action: [What they do]
    output: [What they produce]
  - step: 2
    agent: [Agent B]
    input: [From step 1]
    action: [What they do]
    output: [What they produce]
```

### Parallel Work Pattern
```yaml
parallel:
  group: [Group Name]
  agents:
    - agent: [Agent A]
      task: [Their work]
    - agent: [Agent B]
      task: [Their work]
  synchronization:
    point: [When to sync]
    coordinator: [Who manages]
```

## Error Handling Patterns

### Error Recovery Pattern
```yaml
error-handling:
  detection:
    - Monitor for: [Condition]
    - Check frequency: [Interval]
  response:
    - Level 1: [Auto-retry]
    - Level 2: [Fallback option]
    - Level 3: [Escalate to human]
  documentation:
    - Log error details
    - Track frequency
    - Report patterns
```

### Confusion Handler Pattern
```
When uncertain:
1. Check documentation/examples
2. Ask for clarification
3. Provide best guess with confidence level
4. Suggest alternatives
5. Escalate if critical
```

## State Management Patterns

### State Object Pattern
```json
{
  "project_id": "unique_identifier",
  "phase": "current_phase",
  "agents": {
    "active": ["list"],
    "completed": ["list"]
  },
  "context": {
    "requirements": {},
    "decisions": [],
    "issues": []
  },
  "timestamp": "ISO 8601",
  "version": "1.0"
}
```

### State Transition Pattern
```yaml
transition:
  from: [Current State]
  to: [Next State]
  trigger: [What causes transition]
  validation:
    - [Check 1]
    - [Check 2]
  actions:
    - Save current state
    - Validate readiness
    - Execute transition
    - Confirm new state
```

## Documentation Patterns

### Agent Documentation Pattern
Every agent must document:
- Core identity and purpose
- Commands with * prefix
- Integration points
- Dependencies
- Error handling
- Success metrics

### Task Documentation Pattern
Every task must document:
- Clear objective
- Step-by-step process
- Input requirements
- Output specifications
- Error conditions
- Key principles

## LLM Optimization Patterns

### Instruction Hierarchy Pattern
```
MANDATORY: [Must always do]
IMPORTANT: [Should do unless impossible]
PREFERRED: [Do when possible]
OPTIONAL: [Can do if appropriate]
NEVER: [Must never do]
```

### Role Reinforcement Pattern
Reinforce role throughout document:
- Opening: Establish identity
- Commands: Reflect expertise
- Examples: Use domain language
- Principles: Guide behavior
- Closing: Summarize role

## Common Anti-Patterns to Avoid

### Anti-Pattern: Vague Instructions
❌ "Handle customer issues appropriately"
✅ "Respond to customer issues within 2 minutes using empathetic language"

### Anti-Pattern: Overlapping Responsibilities
❌ Multiple agents can make same decision
✅ One agent owns each decision with clear escalation

### Anti-Pattern: Missing Error Handling
❌ Assume everything works
✅ Define fallbacks for every failure mode

### Anti-Pattern: Weak Role Definition
❌ "You are a helpful assistant"
✅ "You are Sarah, a Senior Business Analyst with 10 years experience in requirements elicitation"

### Anti-Pattern: No State Management
❌ Agents work in isolation
✅ Shared context object maintains state

## Pattern Application Guidelines

1. **Start with BMAD structure** - Don't reinvent the wheel
2. **Adapt patterns to domain** - Customize for authenticity
3. **Maintain consistency** - Use same patterns throughout
4. **Document variations** - Explain any deviations
5. **Test patterns** - Validate they work as expected
6. **Iterate based on results** - Improve patterns over time

## Success Indicators

When patterns are correctly applied:
- Agents maintain character consistently
- Handoffs work smoothly
- Commands are intuitive
- Errors are handled gracefully
- Quality gates pass easily
- Integration is seamless
- Users understand quickly
- Maintenance is simple

## Remember

These patterns are proven through extensive use. Trust them, but adapt them thoughtfully for your specific domain and requirements. The goal is authentic, effective agent teams that feel natural and capable.