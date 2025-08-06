---
docOutputLocation: mother-box-package/outputs/team-blueprint.yaml
template: "mother-box-package/templates/team-blueprint.yaml"
---

# Synthesize Blueprint Task

Combine all research, requirements, and insights into a comprehensive agent team blueprint that ensures nothing falls through the cracks.

## Process

### Step 1: Gather All Inputs

Collect and review all documents:

1. **From Analyst:**
   - Requirements document
   - Discovery session notes
   - Elicitation results
   - User validation feedback
   - Stakeholder map

2. **From Researcher:**
   - Domain knowledge base
   - Role profiles
   - Workflow maps
   - Terminology glossary
   - Best practices guide

3. **From PO:**
   - Success criteria
   - ROI calculations
   - Value propositions
   - Acceptance criteria

4. **From Master:**
   - Quality requirements
   - BMAD standards
   - Methodology constraints

### Step 2: Document Analysis

#### Cross-Reference Matrix
Create a matrix to ensure complete coverage:

```markdown
| Requirement | Research Support | Agent Assignment | Workflow Coverage | Success Metric |
|-------------|-----------------|------------------|-------------------|----------------|
| [Need 1]    | [Research ref]  | [Agent ID]       | [Workflow name]   | [Metric]       |
| [Need 2]    | [Research ref]  | [Agent ID]       | [Workflow name]   | [Metric]       |
```

#### Gap Identification
Look for:
- Requirements without agent coverage
- Research findings not utilized
- Workflows missing actors
- Integration points undefined
- Success metrics without measurement

### Step 3: Agent Team Design

#### Agent Identification Process

1. **Core Agent Determination**
   ```
   For each primary workflow:
   - Who initiates?
   - Who executes?
   - Who validates?
   - Who escalates?
   ```

2. **Supporting Agent Analysis**
   ```
   For each core agent:
   - What do they need from others?
   - What do they provide to others?
   - What decisions need support?
   ```

3. **Specialist Agent Evaluation**
   ```
   For edge cases and exceptions:
   - What expertise is needed?
   - How often required?
   - Can existing agent handle?
   ```

#### Agent Justification Framework
For each proposed agent:
- **Problem Solved**: Specific issue addressed
- **Value Created**: Measurable benefit
- **Unique Capability**: What only they can do
- **Integration Need**: How they fit system
- **Success Metric**: How to measure effectiveness

### Step 4: Interaction Design

#### Communication Matrix
```markdown
| From Agent | To Agent | Message Type | Trigger | Frequency | SLA |
|------------|----------|--------------|---------|-----------|-----|
| [Agent A]  | [Agent B]| [Type]       | [Event] | [Often]   | [Time] |
```

#### Handoff Protocols
For each handoff point:
1. **Context Preservation**
   - What must be passed?
   - What format?
   - What validation?

2. **Error Handling**
   - What if target unavailable?
   - What if data incomplete?
   - What if timeout occurs?

3. **Acknowledgment**
   - Confirmation required?
   - Rollback possible?
   - Audit trail needed?

### Step 5: Workflow Integration

#### Workflow Mapping
For each identified workflow:

```yaml
workflow:
  name: [Workflow Name]
  trigger: [What starts it]
  actors: [List of agents]
  
  steps:
    - step: 1
      actor: [Agent]
      action: [What they do]
      input: [What they need]
      output: [What they produce]
      decision: [If applicable]
      
    - step: 2
      parallel: [If applicable]
      actors: [Multiple agents]
      coordination: [How they sync]
  
  success: [Completion criteria]
  metrics: [How measured]
  sla: [Time expectations]
```

### Step 6: Capability Mapping

#### Requirement-to-Capability Matrix
```markdown
| User Requirement | Agent Capability | Implementation | Validation |
|-----------------|------------------|----------------|------------|
| "Handle refunds" | Process refunds up to $X | Billing Agent command | Test with scenarios |
| "24/7 coverage" | Timezone-aware routing | Orchestrator logic | Verify coverage |
```

#### Capability Gaps
Identify and address:
- Required but missing capabilities
- Nice-to-have enhancements
- Future phase additions
- Technical limitations

### Step 7: Integration Specifications

#### External Systems
For each integration:
```yaml
integration:
  system: [Name]
  type: [API/Webhook/File/etc]
  agents_affected: [List]
  
  data_flow:
    inbound:
      format: [JSON/XML/etc]
      frequency: [Real-time/Batch]
      validation: [Rules]
    
    outbound:
      format: [Structure]
      triggers: [When sent]
      confirmation: [Required?]
  
  error_handling:
    retry: [Strategy]
    fallback: [Alternative]
    alerting: [Who notified]
```

### Step 8: State Management Design

#### Shared State Definition
```yaml
shared_state:
  project_context:
    - field: current_phase
      type: string
      updated_by: [orchestrator]
      read_by: [all]
    
    - field: active_ticket
      type: object
      updated_by: [triage_agent]
      read_by: [all_service_agents]
  
  persistence:
    method: [Approach]
    retention: [Duration]
    backup: [Strategy]
```

### Step 9: Success Validation

#### Success Criteria Mapping
```markdown
| Success Metric | Measured By | Target | Agent Responsible |
|---------------|-------------|--------|-------------------|
| Response Time | Timestamp diff | <2min | Triage Agent |
| Resolution Rate | Tickets closed | >80% | Service Agents |
| Satisfaction | Survey score | >4.5 | All Agents |
```

#### Value Validation
- Each agent justified by value
- ROI calculations validated
- Benefits clearly mapped
- Costs accurately estimated

### Step 10: Risk Assessment

#### Risk Matrix
```markdown
| Risk | Probability | Impact | Mitigation | Owner |
|------|------------|--------|------------|-------|
| Integration fails | Medium | High | Fallback process | Architect |
| Scope creep | High | Medium | Phase gates | PM |
| User adoption | Low | High | Training plan | Analyst |
```

### Step 11: Blueprint Synthesis

#### Executive Summary
Write 1-page summary covering:
- Problem being solved
- Solution approach
- Agent team composition
- Key workflows
- Success metrics
- Timeline
- Risks and mitigations

#### Detailed Sections

1. **Team Composition**
   - Agent list with roles
   - Justification for each
   - Reporting structure
   - Decision authority

2. **Interaction Model**
   - Communication patterns
   - Handoff protocols
   - State management
   - Error handling

3. **Workflow Definitions**
   - Complete workflows
   - Decision trees
   - Exception handling
   - SLAs

4. **Integration Specifications**
   - External systems
   - Data flows
   - Protocols
   - Security

5. **Success Framework**
   - Metrics and targets
   - Measurement methods
   - Reporting cadence
   - Improvement process

### Step 12: Validation Checklist

Before finalizing blueprint:

#### Completeness Check
- [ ] All requirements addressed
- [ ] All agents justified
- [ ] All workflows defined
- [ ] All integrations specified
- [ ] All metrics measurable

#### Consistency Check
- [ ] No contradictions
- [ ] Terminology uniform
- [ ] Patterns consistent
- [ ] Standards followed

#### Feasibility Check
- [ ] Technically possible
- [ ] Timeline realistic
- [ ] Resources adequate
- [ ] Risks manageable

#### Quality Check
- [ ] Master standards met
- [ ] PO value confirmed
- [ ] Architect design sound
- [ ] Analyst requirements matched

## Synthesis Patterns

### Pattern: Hub and Spoke
```
Central orchestrator coordinates specialized agents
Use when: Clear hierarchy needed
Example: Customer service with triage center
```

### Pattern: Pipeline
```
Sequential processing through agent chain
Use when: Linear workflow with stages
Example: Document processing pipeline
```

### Pattern: Mesh
```
Agents interact peer-to-peer as needed
Use when: Complex, dynamic interactions
Example: Collaborative research team
```

### Pattern: Layered
```
Agents organized in capability layers
Use when: Clear separation of concerns
Example: L1/L2/L3 support structure
```

## Common Synthesis Challenges

### Challenge: Overlapping Responsibilities
**Solution**: Create clear RACI matrix
- Responsible: Who does the work
- Accountable: Who owns outcome
- Consulted: Who provides input
- Informed: Who needs updates

### Challenge: Too Many Agents
**Solution**: Consolidation analysis
- Can roles be combined?
- Is specialization necessary?
- What's the maintenance cost?
- Can we phase rollout?

### Challenge: Missing Capabilities
**Solution**: Gap filling strategies
- Add to existing agent
- Create new specialist
- Document for Phase 2
- Accept limitation

### Challenge: Complex Interactions
**Solution**: Simplification techniques
- Reduce handoff points
- Clarify protocols
- Add orchestration
- Define clear boundaries

## Quality Criteria

### Blueprint Excellence
- **Comprehensive**: Nothing missed
- **Clear**: Unambiguous specifications
- **Actionable**: Can build from it
- **Validated**: All stakeholders agree
- **Valuable**: ROI demonstrated

### Red Flags
- Vague descriptions
- Missing workflows
- Undefined integrations
- Unclear success metrics
- No error handling

## Output

A complete blueprint that:
1. Addresses every requirement
2. Utilizes all research
3. Defines clear specifications
4. Enables successful building
5. Ensures value delivery

## Remember

The PM's blueprint is the single source of truth for the Building Phase. It must be:
- **Complete**: Every detail captured
- **Clear**: No ambiguity
- **Connected**: All pieces fit
- **Confirmed**: Stakeholders aligned

This blueprint determines success or failure of the entire project. Take the time to get it right.