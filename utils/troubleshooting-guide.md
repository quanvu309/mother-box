# Mother Box Troubleshooting Guide

Comprehensive guide for resolving common issues during agent team creation.

## Quick Diagnosis

### Symptoms → Likely Cause → Solution

| Symptom | Likely Cause | Quick Solution |
|---------|--------------|----------------|
| User can't articulate needs | Vague requirements | Use advanced elicitation techniques |
| Research taking too long | Domain too broad | Focus on specific sub-domain first |
| Agents feel generic | Insufficient research | Deepen domain investigation |
| Integration failing | Protocol mismatch | Review architect's design |
| Quality gates failing | Standards not met | Review Master's feedback |
| User unhappy with agents | Misunderstood requirements | Return to discovery phase |

## Phase-Specific Issues

### Understanding Phase Problems

#### Problem: User Doesn't Know What They Need
**Symptoms:**
- Vague statements like "I need automation"
- Can't specify problems clearly
- Keeps changing requirements

**Root Causes:**
- User thinking in solutions, not problems
- Lack of domain expertise
- Unclear business goals

**Solutions:**
1. Use the "Day in the Life" technique
2. Focus on pain points, not solutions
3. Use analogies and comparisons
4. Break down into smaller, specific scenarios
5. Involve multiple stakeholders

**Example Recovery:**
```
Analyst: "Instead of what you need, let's talk about what frustrates you most in your daily work."
User: "Well, I spend hours answering the same questions..."
Analyst: "Tell me about these questions - what are the top 5?"
[Now we have specific, actionable information]
```

#### Problem: Scope Keeps Expanding
**Symptoms:**
- New requirements appearing daily
- "While we're at it..." statements
- Timeline becoming unrealistic

**Root Causes:**
- Excitement about possibilities
- Discovering new opportunities
- Multiple stakeholders with different needs

**Solutions:**
1. Document all requests but categorize:
   - Phase 1 (MVP)
   - Phase 2 (Enhancement)
   - Future Consideration
2. Use PO to define value priorities
3. Set clear phase boundaries
4. Create roadmap for future phases

**Scope Control Script:**
```
Orchestrator: "This is valuable input. Let's capture it for Phase 2 so we can deliver Phase 1 successfully first."
```

#### Problem: Domain Too Complex
**Symptoms:**
- Research revealing overwhelming complexity
- Many regulatory requirements
- Highly specialized terminology
- Multiple conflicting standards

**Root Causes:**
- Highly regulated industry
- Mature domain with legacy
- Multiple sub-specialties

**Solutions:**
1. Focus on one sub-domain initially
2. Engage domain expert consultation
3. Extend research phase
4. Create phased approach
5. Document assumptions clearly

**Complexity Management:**
```
Researcher: "Healthcare billing has 15 sub-domains. Let's focus on outpatient billing first, then expand."
```

### Building Phase Problems

#### Problem: Agents Sound Robotic
**Symptoms:**
- Formal, stilted language
- No personality
- Generic responses
- Lack authenticity

**Root Causes:**
- Insufficient persona development
- Missing domain research
- Weak voice crafting
- No real-world examples

**Solutions:**
1. Review actual job postings for language
2. Study community forums for voice
3. Add specific experiences to persona
4. Include domain-specific concerns
5. Use Prompt Specialist optimization

**Voice Improvement Example:**
```yaml
# Before (Robotic):
persona:
  style: "Professional and helpful"

# After (Authentic):
persona:
  style: "Pragmatic, slightly skeptical, detail-oriented, uses construction metaphors, direct communicator"
  background: "15 years in field, seen every problem twice"
  pet_peeves: "Incomplete specifications, safety shortcuts"
  favorite_phrase: "Measure twice, cut once"
```

#### Problem: Integration Points Failing
**Symptoms:**
- Agents can't communicate
- Data not passing correctly
- Handoffs dropping information
- State not preserved

**Root Causes:**
- Mismatched protocols
- Undefined data formats
- Missing error handling
- Async timing issues

**Solutions:**
1. Create explicit protocol definitions
2. Define standard message format
3. Add acknowledgment requirements
4. Implement retry logic
5. Add validation at each point

**Integration Fix Pattern:**
```yaml
# Define explicit protocol
handoff_protocol:
  from: agent_a
  to: agent_b
  message_format:
    header:
      from: "agent_id"
      to: "agent_id"
      timestamp: "ISO-8601"
      correlation_id: "UUID"
    body:
      context: "Full context object"
      request: "Specific request"
      format: "Expected response format"
    validation:
      required_fields: ["header", "body.context", "body.request"]
      timeout: "30 seconds"
      retry: "3 attempts with exponential backoff"
```

#### Problem: Quality Scores Low
**Symptoms:**
- Master rejecting work
- Validator finding issues
- Scores below 8/10
- Repeated revisions needed

**Root Causes:**
- Rushing through creation
- Skipping validation steps
- Not following BMAD patterns
- Insufficient review cycles

**Solutions:**
1. Review BMAD patterns document
2. Use checklists before submission
3. Peer review between creators
4. Incremental validation
5. Study successful examples

**Quality Improvement Process:**
```
1. Self-review with checklist
2. Peer review by another agent
3. Validator preliminary check
4. Master formal review
5. Revise based on specific feedback
6. Re-validate changed sections only
```

## Communication Issues

### Problem: Agents Not Responding
**Symptoms:**
- No response to activation
- Commands not recognized
- Stuck in wrong state

**Root Causes:**
- Incorrect activation sequence
- Missing dependencies
- State corruption
- Context lost

**Solutions:**
1. Restart with clean state
2. Verify all dependencies loaded
3. Check activation instructions
4. Use roll-call to verify
5. Clear context and restart

**Recovery Sequence:**
```bash
*agent mb-orchestrator
*roll-call  # Verify all agents
*status     # Check current state
*save-state # Save if needed
*exit       # Clean exit
# Restart fresh
*agent mb-orchestrator
*load-state # If needed
```

### Problem: Handoffs Dropping
**Symptoms:**
- Information lost between agents
- Agents repeating work
- Context not preserved
- Decisions forgotten

**Root Causes:**
- No state management
- Informal handoffs
- Missing context object
- No handoff protocol

**Solutions:**
1. Implement formal handoff protocol
2. Use structured context object
3. Add handoff acknowledgment
4. Log all handoffs
5. Add handoff validation

## User Validation Issues

### Problem: User Rejects Agents
**Symptoms:**
- "This isn't what I wanted"
- "They don't understand our domain"
- "Too complicated/too simple"

**Root Causes:**
- Requirements misunderstood
- Insufficient validation loops
- Domain research gaps
- Expectation mismatch

**Solutions:**
1. Return to Understanding Phase
2. Conduct detailed gap analysis
3. Show specific examples early
4. Validate incrementally
5. Adjust based on feedback

**Recovery Approach:**
```
Analyst: "Let's look at specific examples of what's not working:"
1. Show agent performing task
2. Identify specific disconnects
3. Trace back to requirement
4. Adjust understanding
5. Validate adjustment
6. Update only affected agents
```

## Performance Issues

### Problem: Agents Too Slow
**Symptoms:**
- Response times exceeding targets
- Timeouts occurring
- Users complaining about speed

**Root Causes:**
- Too much context processing
- Inefficient prompt structure
- Sequential instead of parallel
- Over-complex decision trees

**Solutions:**
1. Optimize prompt structure
2. Implement parallel processing
3. Cache frequent operations
4. Simplify decision logic
5. Pre-process where possible

**Performance Optimization:**
```yaml
# Before: Sequential
workflow:
  - Step 1: Agent A (30s)
  - Step 2: Agent B (30s)  
  - Step 3: Agent C (30s)
  Total: 90s

# After: Parallel where possible
workflow:
  - Parallel:
    - Agent A (30s)
    - Agent B (30s)
  - Then: Agent C (30s)
  Total: 60s
```

## Edge Case Handling

### Problem: Unusual Situations Break Agents
**Symptoms:**
- Agents confused by edge cases
- Hallucination on unusual inputs
- Inconsistent handling
- No fallback behavior

**Root Causes:**
- Edge cases not identified
- No error handling defined
- Assumptions too rigid
- Missing uncertainty handling

**Solutions:**
1. Document all edge cases found
2. Add explicit edge handling
3. Implement uncertainty protocol
4. Define fallback behaviors
5. Add human escalation

**Edge Case Pattern:**
```yaml
edge_case_handling:
  when_uncertain:
    confidence_threshold: 0.8
    below_threshold_action: "Request clarification"
    
  unrecognized_input:
    action: "I don't recognize this pattern. Let me get help."
    escalate_to: "human or senior_agent"
    
  system_error:
    retry_attempts: 3
    fallback: "Manual processing required"
    notification: "Alert supervisor"
```

## Recovery Procedures

### General Recovery Process
1. **Identify** specific issue
2. **Isolate** affected component
3. **Document** current state
4. **Rollback** if necessary
5. **Fix** root cause
6. **Test** fix in isolation
7. **Integrate** carefully
8. **Validate** full system
9. **Document** lesson learned

### Emergency Procedures

#### Complete System Failure
```
1. Save current state immediately
2. Document what was happening
3. Identify last known good state
4. Rollback to checkpoint
5. Replay from checkpoint
6. Skip problematic operation
7. Continue with workaround
8. Fix root cause separately
```

#### User Crisis
```
1. Acknowledge immediately
2. Set realistic expectations
3. Provide workaround if possible
4. Escalate to human if needed
5. Document for prevention
6. Follow up with resolution
```

## Prevention Strategies

### Proactive Quality Checks
- Review at 25%, 50%, 75% complete
- Peer review before formal validation
- Test with examples early
- Validate assumptions quickly
- Get user feedback incrementally

### Documentation Practices
- Document all decisions
- Record assumptions
- Note edge cases discovered
- Track what worked/didn't
- Build pattern library

### Communication Protocols
- Daily status updates
- Blocker alerts immediately
- Risk flags early
- Success celebrations
- Lesson sharing

## Common Anti-Patterns to Avoid

1. **Skipping Discovery**: Never assume you understand without validation
2. **Shallow Research**: Surface-level domain knowledge creates generic agents
3. **Big Bang Delivery**: Show nothing until end risks major rework
4. **Ignoring Feedback**: User concerns are valid, investigate fully
5. **Quality Shortcuts**: Technical debt in agents multiplies quickly
6. **Solo Work**: Collaboration catches issues early

## Escalation Matrix

| Issue Level | Examples | First Response | Escalation Path |
|------------|----------|----------------|-----------------|
| Minor | Typos, small adjustments | Fix immediately | None needed |
| Major | Wrong understanding, missing capability | Analyst clarifies | PM → Orchestrator |
| Critical | Fundamental mismatch, technical blocker | Stop work | Orchestrator → Master → Human |
| Crisis | User extremely unhappy, deadline risk | All hands | Human intervention immediate |

## Remember

Most issues stem from:
1. **Communication gaps** - Solve with clarity
2. **Assumption errors** - Solve with validation  
3. **Complexity overwhelm** - Solve with decomposition
4. **Quality shortcuts** - Solve with discipline

When in doubt:
- Ask for clarification
- Validate with examples
- Test incrementally
- Document everything
- Learn from issues

The goal is not to avoid all problems but to detect and resolve them quickly while learning for next time.