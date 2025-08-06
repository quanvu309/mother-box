# BMAD Compliance Checklist

Use this checklist to ensure all Mother Box outputs comply with BMAD methodology standards.

## Agent File Compliance

### Structure Requirements
- [ ] File starts with agent name as H1 header
- [ ] Contains ACTIVATION-NOTICE paragraph
- [ ] Contains CRITICAL paragraph with activation instructions
- [ ] Has "COMPLETE AGENT DEFINITION FOLLOWS" section
- [ ] YAML block properly formatted with triple backticks

### YAML Configuration Block
- [ ] IDE-FILE-RESOLUTION section present and correct
- [ ] REQUEST-RESOLUTION section defines flexible matching
- [ ] activation-instructions complete with all steps
- [ ] agent section with all required fields:
  - [ ] name (full name)
  - [ ] id (unique identifier)
  - [ ] title (professional title)
  - [ ] icon (emoji)
  - [ ] whenToUse (clear use cases)
  - [ ] customization (null or specific)

### Persona Definition
- [ ] role field defines primary role
- [ ] style describes communication approach
- [ ] identity establishes core character
- [ ] focus lists main areas
- [ ] core_principles has 10 clear principles
- [ ] Last principle is "Numbered Options Protocol"

### Commands Section
- [ ] All commands listed with descriptions
- [ ] Commands use verb format
- [ ] Include 'help' command
- [ ] Include 'exit' command
- [ ] Include 'yolo' toggle
- [ ] Include 'doc-out' for output
- [ ] Comment states "All commands require * prefix"

### Help Display Template
- [ ] Formatted help text provided
- [ ] Commands grouped logically
- [ ] Shows * prefix requirement
- [ ] Includes brief descriptions
- [ ] Has encouraging tagline

### Dependencies
- [ ] tasks list with .md files
- [ ] templates list with .yaml files
- [ ] checklists list with .md files
- [ ] data list with .md files
- [ ] All paths relative to package root

## Task File Compliance

### Structure Requirements
- [ ] YAML frontmatter with docOutputLocation
- [ ] Template reference if applicable
- [ ] Clear H1 title
- [ ] Process section with numbered steps
- [ ] Key principles section

### Content Requirements
- [ ] Step-by-step instructions
- [ ] Clear inputs and outputs
- [ ] Error handling procedures
- [ ] Elicitation points marked
- [ ] Examples provided where helpful

## Template Compliance

### YAML Structure
- [ ] Valid YAML syntax
- [ ] Document metadata section
- [ ] Field definitions with:
  - [ ] label
  - [ ] type
  - [ ] required flag
  - [ ] validation rules
  - [ ] examples where appropriate

### Field Types
- [ ] Use standard types (text, number, select, list, boolean)
- [ ] Provide options for select fields
- [ ] Include validation rules
- [ ] Set required fields appropriately

## Quality Standards

### Clarity Score (1-10)
- [ ] Instructions are unambiguous (8+)
- [ ] Role definitions are clear (8+)
- [ ] Outputs are well-defined (8+)
- [ ] No vague language (8+)

### Consistency Score (1-10)
- [ ] Voice matches the role (8+)
- [ ] Terminology is uniform (8+)
- [ ] Patterns are consistent (8+)
- [ ] No contradictions (8+)

### Completeness Score (1-10)
- [ ] All sections present (8+)
- [ ] Edge cases covered (8+)
- [ ] Error handling included (8+)
- [ ] Dependencies listed (8+)

### Compliance Score (1-10)
- [ ] BMAD format followed (9+)
- [ ] Standards met (9+)
- [ ] Best practices applied (8+)
- [ ] Patterns utilized (8+)

## Integration Readiness

### Communication Patterns
- [ ] Message formats defined
- [ ] Handoff protocols clear
- [ ] State management specified
- [ ] Error responses defined

### Boundaries
- [ ] Agent limitations explicit
- [ ] Escalation triggers defined
- [ ] Scope clearly bounded
- [ ] Dependencies identified

## LLM Optimization

### Prompt Engineering
- [ ] Activation instructions clear
- [ ] Role reinforcement throughout
- [ ] Commands have clear triggers
- [ ] Context preservation enabled

### Behavioral Controls
- [ ] MUST/MUST NOT statements
- [ ] ALWAYS/NEVER rules
- [ ] Fallback behaviors defined
- [ ] Confusion handlers present

## Final Validation

### Package Structure
- [ ] All required directories present
- [ ] File naming conventions followed
- [ ] Cross-references valid
- [ ] No broken dependencies

### Documentation
- [ ] User guide present and complete
- [ ] Install manifest accurate
- [ ] Core config properly configured
- [ ] All agents documented

### Testing Readiness
- [ ] Test scenarios provided
- [ ] Sample dialogues included
- [ ] Edge cases documented
- [ ] Validation criteria clear

## Approval

### Sign-offs Required
- [ ] Master review completed
- [ ] Quality gates passed
- [ ] Integration tested
- [ ] User validation confirmed

### Final Score
- Overall Compliance: ___/10
- Ready for Delivery: [ ] Yes [ ] No
- Issues to Address: ________________

## Notes
_Document any deviations from standards and justifications:_

---

**Reviewed by:** _____________
**Date:** _____________
**Status:** [ ] Passed [ ] Failed [ ] Conditional Pass