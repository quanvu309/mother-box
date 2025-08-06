# State Management Utilities

Common patterns and utilities for managing state across Mother Box operations.

## Shared State Object

### Standard Structure
```json
{
  "project": {
    "id": "uuid-string",
    "name": "Project Name",
    "domain": "Industry/Domain",
    "created": "ISO-8601-timestamp",
    "modified": "ISO-8601-timestamp"
  },
  "phase": {
    "current": "understanding|building|delivery",
    "started": "ISO-8601-timestamp",
    "progress": 0-100,
    "substage": "specific-activity"
  },
  "agents": {
    "active": ["agent-id-list"],
    "completed_work": {
      "agent-id": ["task-list"]
    },
    "pending_work": {
      "agent-id": ["task-list"]
    }
  },
  "requirements": {
    "status": "gathering|validated|locked",
    "document_ref": "path/to/requirements.yaml",
    "version": "1.0",
    "changes": []
  },
  "research": {
    "status": "pending|in-progress|complete",
    "coverage": 0-100,
    "domains_researched": ["list"],
    "knowledge_base_ref": "path/to/kb.md"
  },
  "blueprint": {
    "status": "draft|review|approved",
    "version": "1.0",
    "agents_defined": ["list"],
    "document_ref": "path/to/blueprint.yaml"
  },
  "quality": {
    "gates_passed": ["gate-list"],
    "current_scores": {
      "clarity": 0-10,
      "consistency": 0-10,
      "completeness": 0-10,
      "compliance": 0-10
    },
    "issues": [
      {
        "severity": "critical|major|minor",
        "description": "Issue description",
        "owner": "agent-id",
        "status": "open|resolved"
      }
    ]
  },
  "decisions": [
    {
      "timestamp": "ISO-8601",
      "made_by": "agent-id",
      "decision": "Description",
      "rationale": "Why",
      "impact": "What changed"
    }
  ],
  "blockers": [
    {
      "id": "blocker-id",
      "description": "What's blocked",
      "blocking_agent": "agent-id",
      "raised_by": "agent-id",
      "timestamp": "ISO-8601",
      "status": "active|resolved"
    }
  ],
  "context": {
    "user_preferences": {},
    "constraints": {},
    "special_requirements": {},
    "notes": []
  }
}
```

## State Operations

### Initialize State
```javascript
function initializeState(projectName, domain) {
  return {
    project: {
      id: generateUUID(),
      name: projectName,
      domain: domain,
      created: new Date().toISOString(),
      modified: new Date().toISOString()
    },
    phase: {
      current: "understanding",
      started: new Date().toISOString(),
      progress: 0,
      substage: "discovery"
    },
    agents: {
      active: [],
      completed_work: {},
      pending_work: {}
    },
    // ... rest of structure
  };
}
```

### Update State
```javascript
function updateState(state, updates) {
  const newState = {
    ...state,
    ...updates,
    project: {
      ...state.project,
      modified: new Date().toISOString()
    }
  };
  return validateState(newState);
}
```

### State Transitions

#### Phase Transitions
```javascript
function transitionPhase(state, newPhase) {
  // Validate transition is allowed
  const validTransitions = {
    "understanding": ["building"],
    "building": ["delivery"],
    "delivery": []
  };
  
  if (!validTransitions[state.phase.current].includes(newPhase)) {
    throw new Error(`Invalid transition from ${state.phase.current} to ${newPhase}`);
  }
  
  // Check gates
  const requiredGates = getRequiredGates(state.phase.current);
  const passedGates = state.quality.gates_passed;
  
  if (!requiredGates.every(gate => passedGates.includes(gate))) {
    throw new Error("Quality gates not passed");
  }
  
  // Update state
  return updateState(state, {
    phase: {
      current: newPhase,
      started: new Date().toISOString(),
      progress: 0,
      substage: getInitialSubstage(newPhase)
    }
  });
}
```

## Context Preservation

### Save Context
```javascript
function saveContext(state, key, value) {
  return updateState(state, {
    context: {
      ...state.context,
      [key]: value
    }
  });
}
```

### Retrieve Context
```javascript
function getContext(state, key) {
  return state.context[key];
}
```

## Progress Tracking

### Update Progress
```javascript
function updateProgress(state, progress, substage) {
  return updateState(state, {
    phase: {
      ...state.phase,
      progress: Math.min(100, Math.max(0, progress)),
      substage: substage || state.phase.substage
    }
  });
}
```

### Calculate Overall Progress
```javascript
function calculateOverallProgress(state) {
  const phaseWeights = {
    "understanding": 0.3,
    "building": 0.6,
    "delivery": 0.1
  };
  
  const phaseProgress = {
    "understanding": state.phase.current === "understanding" ? state.phase.progress : 
                     ["building", "delivery"].includes(state.phase.current) ? 100 : 0,
    "building": state.phase.current === "building" ? state.phase.progress :
                state.phase.current === "delivery" ? 100 : 0,
    "delivery": state.phase.current === "delivery" ? state.phase.progress : 0
  };
  
  return Object.keys(phaseWeights).reduce((total, phase) => {
    return total + (phaseProgress[phase] * phaseWeights[phase]);
  }, 0);
}
```

## Work Management

### Assign Work
```javascript
function assignWork(state, agentId, tasks) {
  const pending = state.agents.pending_work[agentId] || [];
  return updateState(state, {
    agents: {
      ...state.agents,
      pending_work: {
        ...state.agents.pending_work,
        [agentId]: [...pending, ...tasks]
      },
      active: state.agents.active.includes(agentId) ? 
              state.agents.active : 
              [...state.agents.active, agentId]
    }
  });
}
```

### Complete Work
```javascript
function completeWork(state, agentId, task) {
  const pending = (state.agents.pending_work[agentId] || [])
    .filter(t => t !== task);
  const completed = state.agents.completed_work[agentId] || [];
  
  return updateState(state, {
    agents: {
      ...state.agents,
      pending_work: {
        ...state.agents.pending_work,
        [agentId]: pending
      },
      completed_work: {
        ...state.agents.completed_work,
        [agentId]: [...completed, task]
      },
      active: pending.length > 0 ? 
              state.agents.active : 
              state.agents.active.filter(id => id !== agentId)
    }
  });
}
```

## Decision Tracking

### Record Decision
```javascript
function recordDecision(state, agentId, decision, rationale, impact) {
  const newDecision = {
    timestamp: new Date().toISOString(),
    made_by: agentId,
    decision: decision,
    rationale: rationale,
    impact: impact
  };
  
  return updateState(state, {
    decisions: [...state.decisions, newDecision]
  });
}
```

## Blocker Management

### Add Blocker
```javascript
function addBlocker(state, description, blockingAgent, raisedBy) {
  const blocker = {
    id: generateUUID(),
    description: description,
    blocking_agent: blockingAgent,
    raised_by: raisedBy,
    timestamp: new Date().toISOString(),
    status: "active"
  };
  
  return updateState(state, {
    blockers: [...state.blockers, blocker]
  });
}
```

### Resolve Blocker
```javascript
function resolveBlocker(state, blockerId) {
  return updateState(state, {
    blockers: state.blockers.map(b => 
      b.id === blockerId ? {...b, status: "resolved"} : b
    )
  });
}
```

## Quality Management

### Update Quality Scores
```javascript
function updateQualityScores(state, scores) {
  return updateState(state, {
    quality: {
      ...state.quality,
      current_scores: {
        ...state.quality.current_scores,
        ...scores
      }
    }
  });
}
```

### Pass Quality Gate
```javascript
function passQualityGate(state, gateName) {
  if (state.quality.gates_passed.includes(gateName)) {
    return state; // Already passed
  }
  
  return updateState(state, {
    quality: {
      ...state.quality,
      gates_passed: [...state.quality.gates_passed, gateName]
    }
  });
}
```

## State Validation

### Validate State Structure
```javascript
function validateState(state) {
  const requiredFields = [
    'project.id',
    'project.name',
    'phase.current',
    'agents',
    'quality'
  ];
  
  for (const field of requiredFields) {
    if (!getNestedValue(state, field)) {
      throw new Error(`Missing required field: ${field}`);
    }
  }
  
  // Validate phase
  if (!['understanding', 'building', 'delivery'].includes(state.phase.current)) {
    throw new Error(`Invalid phase: ${state.phase.current}`);
  }
  
  // Validate progress
  if (state.phase.progress < 0 || state.phase.progress > 100) {
    throw new Error(`Invalid progress: ${state.phase.progress}`);
  }
  
  return state;
}
```

## State Persistence

### Save State
```javascript
function saveState(state, filePath) {
  const stateJson = JSON.stringify(state, null, 2);
  // Write to file system
  writeFile(filePath, stateJson);
  return filePath;
}
```

### Load State
```javascript
function loadState(filePath) {
  const stateJson = readFile(filePath);
  const state = JSON.parse(stateJson);
  return validateState(state);
}
```

## State Recovery

### Create Checkpoint
```javascript
function createCheckpoint(state) {
  const checkpoint = {
    ...state,
    checkpoint: {
      created: new Date().toISOString(),
      phase: state.phase.current,
      progress: state.phase.progress
    }
  };
  
  const checkpointPath = `checkpoints/${state.project.id}-${Date.now()}.json`;
  saveState(checkpoint, checkpointPath);
  return checkpointPath;
}
```

### Restore from Checkpoint
```javascript
function restoreCheckpoint(checkpointPath) {
  const checkpoint = loadState(checkpointPath);
  delete checkpoint.checkpoint; // Remove checkpoint metadata
  return checkpoint;
}
```

## Utility Functions

### Generate UUID
```javascript
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}
```

### Get Nested Value
```javascript
function getNestedValue(obj, path) {
  return path.split('.').reduce((current, key) => 
    current && current[key], obj);
}
```

### Format State for Display
```javascript
function formatStateForDisplay(state) {
  return {
    "Project": state.project.name,
    "Domain": state.project.domain,
    "Phase": state.phase.current,
    "Progress": `${state.phase.progress}%`,
    "Active Agents": state.agents.active.join(", "),
    "Quality Score": calculateAverageQuality(state),
    "Blockers": state.blockers.filter(b => b.status === "active").length,
    "Gates Passed": state.quality.gates_passed.length
  };
}
```

### Calculate Average Quality
```javascript
function calculateAverageQuality(state) {
  const scores = state.quality.current_scores;
  const values = Object.values(scores);
  if (values.length === 0) return 0;
  const sum = values.reduce((a, b) => a + b, 0);
  return (sum / values.length).toFixed(1);
}
```

## Usage Examples

### Example 1: Starting a Project
```javascript
let state = initializeState("E-commerce Agent Team", "Retail");
state = assignWork(state, "mb-analyst", ["discovery-session"]);
state = assignWork(state, "mb-researcher", ["domain-research"]);
state = updateProgress(state, 10, "discovery-active");
```

### Example 2: Transitioning Phases
```javascript
// Complete Understanding Phase
state = passQualityGate(state, "requirements-complete");
state = passQualityGate(state, "research-validated");
state = passQualityGate(state, "user-approval");
state = updateProgress(state, 100, "understanding-complete");

// Transition to Building
state = transitionPhase(state, "building");
state = assignWork(state, "mb-architect", ["design-system"]);
state = assignWork(state, "mb-creator", ["write-agents"]);
```

### Example 3: Handling Blockers
```javascript
// Raise a blocker
state = addBlocker(
  state,
  "Domain complexity requires expert consultation",
  "mb-researcher",
  "mb-analyst"
);

// Later, resolve it
state = resolveBlocker(state, "blocker-id");
state = recordDecision(
  state,
  "mb-orchestrator",
  "Engaged domain expert for consultation",
  "Complexity exceeded initial assessment",
  "Extended research phase by 4 hours"
);
```

## Best Practices

1. **Always Validate**: Run validateState after every update
2. **Create Checkpoints**: Before major transitions
3. **Track Decisions**: Document why, not just what
4. **Clean Up State**: Remove resolved blockers periodically
5. **Version Control**: Track state versions for recovery

This utility provides a robust foundation for state management across Mother Box operations, ensuring consistency, traceability, and recoverability throughout the agent team creation process.