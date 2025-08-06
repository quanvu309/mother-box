---
docOutputLocation: mother-box-package/outputs/elicitation-results.md
template: "mother-box-package/templates/elicitation-notes.yaml"
elicit: true
---

# Advanced Elicitation Task

Use sophisticated techniques to extract deep, actionable requirements from users who may not know exactly what they need.

## Process

### Step 1: Establish Rapport and Context

Begin with relationship building:

1. **Introduction and Purpose**
   - "I'm here to help you create the perfect agent team"
   - "There are no wrong answers - we're exploring together"
   - "My goal is to deeply understand your needs"

2. **Set Expectations**
   - This will take 30-60 minutes
   - We'll explore various angles
   - You can change your mind as we go
   - Everything is iterative

### Step 2: Current State Analysis

Understand the present situation:

**Questions to Ask:**
- "Walk me through a typical day in your work"
- "What tasks consume most of your time?"
- "What frustrates you most about current processes?"
- "Where do bottlenecks occur?"
- "What do you wish you had more time for?"

**Listen for:**
- Pain points (even unexpressed ones)
- Repeated patterns
- Emotional responses
- Workarounds they've created

### Step 3: Future State Visioning

Help them imagine the ideal:

**Visioning Techniques:**

1. **Magic Wand Technique**
   - "If you had a magic wand, what would you change?"
   - "In a perfect world, how would this work?"
   - "Imagine all constraints removed - what happens?"

2. **Day in the Life**
   - "Describe your ideal workday 6 months from now"
   - "What would you be doing differently?"
   - "What would no longer be necessary?"

3. **Success Theater**
   - "Paint a picture of wild success"
   - "What would your customers/users say?"
   - "How would you measure triumph?"

### Step 4: Stakeholder Mapping

Understand the ecosystem:

**Exploration Areas:**
- "Who else is affected by these processes?"
- "Who are your internal customers?"
- "Who depends on your outputs?"
- "Whose buy-in do you need?"
- "Who might resist changes?"

**Create Stakeholder Matrix:**
```
Stakeholder | Current Role | Future Role | Impact Level | Concerns
-----------|--------------|-------------|--------------|----------
[Name/Role] | [What now]  | [What then] | High/Med/Low | [Issues]
```

### Step 5: Constraint Discovery

Uncover hidden limitations:

**Gentle Probing:**
- "What rules do you have to follow?"
- "What systems must you work with?"
- "What can't change?"
- "What would your boss/legal/compliance say?"
- "What's your budget reality?"

**Types of Constraints:**
- Technical (systems, integrations)
- Organizational (policies, procedures)
- Regulatory (compliance, standards)
- Resource (budget, time, people)
- Political (stakeholders, culture)

### Step 6: Priority Excavation

Find what really matters:

**Forced Ranking Technique:**
- "If you could only fix ONE thing, what would it be?"
- "What would have the biggest impact?"
- "What would make you a hero?"
- "What keeps your boss up at night?"

**Trade-off Analysis:**
- "Would you rather have X or Y?"
- "Is speed or accuracy more important?"
- "Automation or human control?"
- "Cost savings or revenue growth?"

### Step 7: Scenario Testing

Validate understanding through examples:

**Scenario Construction:**
1. Create 3-5 realistic scenarios based on what you've heard
2. Walk through each: "So if X happened, the agents would..."
3. Watch for reactions: surprise, concern, excitement
4. Adjust based on feedback

**Edge Case Exploration:**
- "What about when things go wrong?"
- "What's the worst case scenario?"
- "What unusual situations occur?"
- "What would break the system?"

### Step 8: Analogical Reasoning

Use comparisons to clarify:

**Analogy Techniques:**
- "Is this more like Uber or more like Amazon?"
- "Think of a company that does this well - who?"
- "If this were a restaurant, what kind?"
- "What existing tool is this most similar to?"

**Pattern Matching:**
- "This sounds like a [pattern] problem"
- "Similar to how [industry] handles [issue]"
- "Like [competitor] but with [difference]"

### Step 9: Requirements Synthesis

Transform insights into requirements:

**Synthesis Framework:**

1. **Functional Requirements**
   - What agents must DO
   - Specific capabilities needed
   - Workflows to support

2. **Non-Functional Requirements**
   - Performance expectations
   - Reliability needs
   - Usability requirements

3. **Integration Requirements**
   - Systems to connect with
   - Data to exchange
   - Protocols to follow

4. **Success Metrics**
   - Quantitative measures
   - Qualitative indicators
   - Timeline expectations

### Step 10: Confirmation Loop

Validate extraction results:

**Playback Technique:**
"Let me make sure I understand correctly..."

1. **Structured Summary**
   - Problem statement
   - Key stakeholders
   - Core requirements
   - Success criteria
   - Constraints

2. **Verification Questions**
   - "Did I capture this accurately?"
   - "What did I miss?"
   - "What should I emphasize more?"
   - "Any concerns about this direction?"

## Elicitation Techniques Toolbox

### The Apprentice
Act like you're learning their job:
- "Teach me how you do this"
- "What would I need to know?"
- "Common mistakes newcomers make?"

### The Five Whys
Drill down to root causes:
- Initial problem → Why? → Answer
- That answer → Why? → Deeper answer
- Continue until root cause exposed

### The Journalist
Use who, what, when, where, why, how:
- WHO is involved?
- WHAT happens?
- WHEN does it occur?
- WHERE does it happen?
- WHY is it important?
- HOW is it done?

### The Time Traveler
Explore temporal dimensions:
- "How was this done 5 years ago?"
- "How has it evolved?"
- "Where is it heading?"
- "What's the vision for 5 years out?"

### The Devil's Advocate
Challenge assumptions:
- "What if we didn't do this at all?"
- "Why not the opposite approach?"
- "What if we're solving the wrong problem?"

### The Ethnographer
Observe and understand culture:
- "What's the unwritten process?"
- "What really happens vs. official process?"
- "What are the workarounds?"

## Red Flags to Watch For

### Vague Language
- "Various tasks" → Which specific tasks?
- "Improve efficiency" → By how much?
- "Better communication" → What's broken now?
- "Modernize" → What specific changes?

### Solution Fixation
- User insists on specific solution
- Won't discuss underlying problem
- "Just build what I asked for"
- May indicate wrong problem focus

### Scope Creep Signals
- "Oh, and it should also..."
- "While we're at it..."
- "It would be nice if..."
- Document but defer to later phases

### Resistance Indicators
- Reluctance to share details
- "It's complicated"
- Defensive responses
- May need trust building

## Documentation Format

### Elicitation Session Notes

```markdown
# Elicitation Session - [Date]

## Participant
- Name: [Name]
- Role: [Title]
- Organization: [Company]

## Current State
### Pain Points
1. [Specific pain point with impact]

### Time Sinks
1. [Task] - [Hours/week]

### Inefficiencies
1. [Process] - [Problem]

## Desired Future State
### Vision
[Their description of ideal state]

### Success Looks Like
- [Specific outcome 1]
- [Specific outcome 2]

## Requirements Discovered
### Must Have
1. [Critical requirement]

### Should Have
1. [Important requirement]

### Nice to Have
1. [Optional requirement]

## Constraints
### Technical
- [Constraint]

### Organizational
- [Constraint]

### Regulatory
- [Constraint]

## Success Metrics
### Quantitative
- [Metric]: [Target]

### Qualitative
- [Indicator]

## Stakeholder Map
[Table of stakeholders]

## Next Steps
1. [Action item]

## Open Questions
1. [Needs clarification]

## Analyst Notes
[Private observations and insights]
```

## Success Indicators

You've succeeded when:
- User has "aha!" moments
- Hidden requirements surface
- Real problems emerge (not symptoms)
- Priorities become clear
- Success metrics are specific
- User feels heard and understood
- You could explain their needs to someone else

## Remember

Elicitation is an art. It requires:
- **Patience**: Let them think and speak
- **Curiosity**: genuine interest in their world
- **Empathy**: Understand their perspective
- **Flexibility**: Adapt techniques to the person
- **Persistence**: Gently probe beneath surface
- **Synthesis**: Connect dots they don't see

The goal isn't to get answers to your questions, but to understand their reality so deeply that you can create agents that feel like they were designed specifically for them - because they were.