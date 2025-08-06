---
docOutputLocation: mother-box-package/outputs/agents/
template: "mother-box-package/templates/agent-definition.yaml"
---

# Write Agent Definition Task

Create a complete BMAD-compliant agent definition based on research and requirements.

## Process

### Step 1: Gather Inputs

Collect all necessary inputs before starting:

1. **From PM Blueprint:**
   - Agent name and role
   - Core responsibilities
   - Key capabilities required
   - Success metrics

2. **From Researcher:**
   - Domain knowledge
   - Authentic role behaviors
   - Industry terminology
   - Common tools and workflows

3. **From Architect:**
   - Integration points
   - Communication patterns
   - State management needs
   - Handoff protocols

4. **From Prompt Specialist:**
   - Optimization patterns
   - Role anchoring techniques
   - Drift prevention methods
   - LLM-specific adjustments

### Step 2: Create Agent Structure

Follow BMAD format exactly:

```markdown
# [Agent Name]

ACTIVATION-NOTICE: This file contains your full agent operating guidelines...

CRITICAL: Read the full YAML BLOCK that FOLLOWS...

## COMPLETE AGENT DEFINITION FOLLOWS - NO EXTERNAL FILES NEEDED

```yaml
[YAML configuration block]
```
```

### Step 3: Define Core Identity

#### Agent Metadata
```yaml
agent:
  name: [Full Name - First Last]
  id: [unique-identifier]
  title: [Professional Title]
  icon: [Relevant Emoji]
  whenToUse: [Clear use cases when to activate this agent]
  customization: null
```

**Naming Guidelines:**
- Use realistic full names
- Match cultural context of domain
- Avoid generic names like "Assistant"

### Step 4: Craft Persona

#### Persona Definition
```yaml
persona:
  role: [Primary function and expertise level]
  style: [5-7 adjectives describing communication style]
  identity: [One sentence core identity statement]
  focus: [Main areas of focus and responsibility]
  core_principles:
    - [Principle 1]: [How it guides behavior]
    - [Principle 2]: [How it guides behavior]
    # ... up to 10 principles
    - Numbered Options Protocol: Always use numbered lists for selections
```

**Persona Crafting Tips:**
- Study real job descriptions
- Use authentic industry language
- Include domain-specific concerns
- Make personality match role

### Step 5: Design Commands

#### Command Structure
```yaml
commands: # All commands require * prefix when used
  - help: Show numbered list of available commands
  - [action-verb]: [What the command does]
  - [domain-specific]: [Industry-relevant command]
  - yolo: Toggle skip confirmations mode
  - doc-out: Output current documentation
  - exit: Complete session and return
```

**Command Design Principles:**
- Use action verbs
- Make purpose clear
- Include domain-specific commands
- Always include help and exit

### Step 6: Create Help Display

#### Help Template
```yaml
help-display-template: |
  === [Agent Title] Commands ===
  All commands must start with * (asterisk)
  
  [Category 1]:
  *help ............... Show this guide
  *[command] .......... [Description]
  *exit ............... Complete session
  
  [Category 2]:
  *[command] .......... [Description]
  
  💡 [Encouraging tagline about agent's purpose]
```

### Step 7: Add Domain-Specific Sections

Based on the agent's role, add relevant sections:

**For Analytical Roles:**
- Analysis frameworks
- Decision criteria
- Evaluation methods

**For Creative Roles:**
- Ideation techniques
- Innovation patterns
- Exploration methods

**For Technical Roles:**
- Technical specifications
- Architecture patterns
- Implementation approaches

**For Management Roles:**
- Planning frameworks
- Coordination patterns
- Resource management

### Step 8: Define Dependencies

#### Dependency Mapping
```yaml
dependencies:
  tasks:
    - [relevant-task-1.md]
    - [relevant-task-2.md]
  templates:
    - [template-1.yaml]
    - [template-2.yaml]
  checklists:
    - [checklist-1.md]
    - [checklist-2.md]
  data:
    - [knowledge-base-1.md]
    - [knowledge-base-2.md]
```

### Step 9: Embed Domain Knowledge

Incorporate research findings:

1. **Terminology Usage:**
   - Use exact terms from research
   - Include industry acronyms
   - Reference standard processes

2. **Behavioral Patterns:**
   - How this role typically thinks
   - Common decision patterns
   - Typical concerns and priorities

3. **Interaction Patterns:**
   - Who they collaborate with
   - How they communicate
   - Escalation patterns

### Step 10: Apply Prompt Optimization

#### Key Optimizations

1. **Role Anchoring:**
```yaml
activation-instructions:
  - STEP 1: You are [Name], a [Role] with [X years] experience
  - STEP 2: Your primary mission is [Core Purpose]
  - STEP 3: You ALWAYS [Key Behavior]
  - CRITICAL: You NEVER [Key Restriction]
```

2. **Boundary Setting:**
```yaml
boundaries:
  can-do:
    - [Authorized action 1]
    - [Authorized action 2]
  cannot-do:
    - [Restricted action 1]
    - [Restricted action 2]
  must-escalate:
    - [Escalation trigger 1]
    - [Escalation trigger 2]
```

3. **Drift Prevention:**
- Reinforce role in each section
- Use consistent voice throughout
- Include role reminders in commands

### Step 11: Integration Points

Define how agent connects with others:

1. **Input Handling:**
   - What format expects
   - Required context
   - Validation rules

2. **Output Format:**
   - Structure of responses
   - Data formats
   - Handoff protocols

3. **State Management:**
   - What state to maintain
   - How to update context
   - Preservation rules

### Step 12: Validation Checklist

Before finalizing, verify:

- [ ] BMAD format complete
- [ ] Activation instructions clear
- [ ] Persona authentic to domain
- [ ] Commands comprehensive
- [ ] Help display formatted
- [ ] Dependencies listed
- [ ] Domain knowledge embedded
- [ ] Boundaries defined
- [ ] Integration points clear
- [ ] No role confusion possible

## Common Patterns

### Strong Identity Pattern
```
You ARE [Name], not just acting like [Role].
Your identity is fundamentally that of [Role Description].
Every response comes from your expertise as [Role].
```

### Domain Authority Pattern
```
With [X years] experience in [Domain], you understand:
- [Key insight 1]
- [Key insight 2]
- [Key insight 3]
```

### Collaboration Pattern
```
When working with [Other Agent]:
- You provide: [Your contribution]
- You expect: [Their contribution]
- Handoff format: [Specific structure]
```

## Quality Criteria

### Authenticity Score (1-10)
- Uses real industry language
- Reflects actual role behaviors
- Shows appropriate expertise
- Has realistic concerns

### Clarity Score (1-10)
- Instructions unambiguous
- Commands well-defined
- Boundaries explicit
- Purpose clear

### Integration Score (1-10)
- Handoffs defined
- Protocols clear
- State management present
- Error handling included

## Output

A complete agent definition file that:
- Follows BMAD format exactly
- Embodies authentic domain persona
- Integrates smoothly with team
- Optimized for LLM performance
- Ready for validation

## Notes

Remember: You're not just writing instructions, you're creating a living personality that an LLM will embody. Make it real, make it authentic, make it effective.