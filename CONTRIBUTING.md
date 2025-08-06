# Contributing to Mother Box

Thank you for your interest in contributing to Mother Box! This document provides guidelines and information for contributors.

## 🚀 Quick Start

1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/mother-box-package.git
   cd mother-box-package
   ```

2. **Set Up Development Environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements-dev.txt
   ```

3. **Make Your Changes**
   - Create a new branch: `git checkout -b feature/your-feature-name`
   - Make your changes
   - Add tests if applicable
   - Update documentation

4. **Test Your Changes**
   ```bash
   python -m pytest tests/
   ./scripts/validate.sh
   ```

5. **Submit a Pull Request**
   - Push your branch: `git push origin feature/your-feature-name`
   - Create a pull request on GitHub
   - Provide a clear description of your changes

## 🎯 Areas for Contribution

### High Priority
- **New Industry Knowledge Maps** - Add domain expertise for new industries
- **Agent Team Templates** - Pre-built templates for common use cases
- **Integration Connectors** - Connect to popular business tools
- **Performance Optimizations** - Improve speed and efficiency
- **Documentation Improvements** - Better guides and examples

### Medium Priority
- **Language Translations** - Support for non-English domains
- **Advanced Workflows** - Complex orchestration patterns
- **Testing Coverage** - Unit and integration tests
- **Security Enhancements** - Additional hardening measures

### Beginner Friendly
- **Example Agent Teams** - Sample outputs and use cases
- **Tutorial Content** - Step-by-step guides
- **Bug Fixes** - Small fixes and improvements
- **Documentation Updates** - Typos, clarifications

## 📋 Contribution Types

### 🧠 Agent Team Templates
Add new pre-built agent teams for specific industries or use cases.

**Structure:**
```yaml
team:
  name: "Your Team Name"
  domain: "Industry/Use Case"
  size: 4-8
  architecture: "Pattern type"

agents:
  - name: "Agent Name"
    role: "Specific role"
    personality: "Authentic traits"
    capabilities: ["List of skills"]
```

**Location:** `templates/team-templates/`

### 🗺️ Industry Knowledge Maps
Contribute domain expertise for new industries.

**Required Sections:**
- Domain overview and complexity factors
- Key stakeholders and their pain points
- Core processes and workflows
- Technology ecosystem
- Regulatory landscape
- Domain terminology

**Location:** `data/industry-knowledge-maps.yaml`

### 🔧 Integration Connectors
Build connections to popular business tools.

**Requirements:**
- Authentication handling
- Error handling and retries
- Rate limiting respect
- Comprehensive documentation
- Test coverage

**Location:** `integrations/`

### 📚 Documentation
Improve guides, tutorials, and API documentation.

**Types:**
- User guides and tutorials
- API documentation
- Architecture explanations
- Best practices
- Troubleshooting guides

## 🛡️ Quality Standards

### Code Quality
- **Python Code:** Follow PEP 8, use type hints, include docstrings
- **YAML Files:** Consistent formatting, proper validation
- **Documentation:** Clear, comprehensive, with examples

### Testing Requirements
- **Unit Tests:** For all new functions and classes
- **Integration Tests:** For new workflows and integrations
- **Documentation Tests:** Ensure examples work
- **Performance Tests:** For optimization contributions

### Security Requirements
- **No Secrets:** Never commit API keys or credentials
- **Input Validation:** Validate all external inputs
- **Error Handling:** Graceful handling of edge cases
- **Audit Logging:** Log security-relevant events

## 🎨 Style Guidelines

### YAML Style
```yaml
# Use 2-space indentation
# Be consistent with naming conventions
# Include comments for complex sections
example_section:
  required_field: "value"
  optional_field: "value"  # Explanation if needed
  
  subsection:
    - item: "First item"
      description: "What this does"
    
    - item: "Second item"
      description: "What this does"
```

### Agent Definition Style
```yaml
# Follow BMAD methodology
# Include rich personality details
# Provide specific capabilities
# Use authentic domain language

agent_name:
  personality:
    traits: "Specific, authentic characteristics"
    background: "Realistic professional history"
    communication: "How they actually talk"
  
  capabilities:
    - "Specific, actionable skill"
    - "Another specific capability"
  
  commands:
    - "*command-name [parameter] - Clear description"
```

### Documentation Style
- **Headers:** Use descriptive, action-oriented titles
- **Examples:** Include working code examples
- **Links:** Use relative links for internal content
- **Images:** Include alt text and captions
- **Code Blocks:** Specify language for syntax highlighting

## 🔍 Review Process

### Automated Checks
All pull requests run automated checks for:
- Code formatting and style
- Test coverage
- Security vulnerabilities
- Documentation build
- Performance regression

### Manual Review
Maintainers will review:
- **Code Quality:** Architecture, maintainability, performance
- **Functionality:** Does it work as intended?
- **Documentation:** Is it clear and complete?
- **Testing:** Are there adequate tests?
- **Security:** Any security implications?

### Review Timeline
- **Small Changes:** 1-3 days
- **Medium Changes:** 3-7 days  
- **Large Changes:** 1-2 weeks

## 🐛 Reporting Bugs

### Before Reporting
1. Check existing issues
2. Try to reproduce with latest version
3. Gather relevant information

### Bug Report Template
```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: 
- Python Version:
- Mother Box Version:
- Other relevant info:

**Additional Context**
Logs, screenshots, etc.
```

## 💡 Feature Requests

### Feature Request Template
```markdown
**Problem Statement**
What problem does this solve?

**Proposed Solution**
How would you like it to work?

**Alternatives Considered**
Other approaches you considered

**Additional Context**
Use cases, examples, etc.
```

## 🏆 Recognition

### Contributor Levels
- **Contributor:** Made at least one accepted contribution
- **Regular Contributor:** 5+ contributions over 6 months
- **Core Contributor:** 20+ contributions, trusted with larger changes
- **Maintainer:** Long-term contributor with commit access

### Recognition
- Contributors listed in README and documentation
- Special badges for significant contributions
- Invitation to contributor meetings and discussions
- Swag and recognition for major contributions

## 📞 Getting Help

### Communication Channels
- **GitHub Discussions:** General questions and ideas
- **Discord:** Real-time chat and collaboration
- **Email:** maintainers@mother-box.ai for private matters

### Mentorship
New contributors can request mentorship for:
- Understanding the codebase
- Learning BMAD methodology
- Guidance on contribution process
- Technical assistance

## 🎉 Thank You!

Every contribution, no matter how small, makes Mother Box better. We appreciate:

- **Bug Reports:** Help us identify and fix issues
- **Feature Requests:** Help us understand user needs
- **Code Contributions:** Direct improvements to the system
- **Documentation:** Help others understand and use Mother Box
- **Community Support:** Help other users in discussions

Together, we're building the future of AI-powered business automation!

---

*By contributing to Mother Box, you agree that your contributions will be licensed under the MIT License.*