# Contributing to Mother Box

Thank you for your interest in contributing to Mother Box! We welcome contributions from the community and are grateful for any help you can provide.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:
- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Accept feedback gracefully
- Put the project's best interests first

## How to Contribute

### 1. Reporting Issues

If you find a bug or have a feature request:
1. Check existing issues to avoid duplicates
2. Create a new issue using the appropriate template
3. Provide as much detail as possible
4. Include steps to reproduce (for bugs)
5. Add relevant labels

### 2. Suggesting Enhancements

We love new ideas! To suggest an enhancement:
1. Open a discussion in the Ideas category
2. Describe the problem you're trying to solve
3. Explain your proposed solution
4. Be open to feedback and alternative approaches

### 3. Contributing Code

#### First Time Contributors
- Look for issues labeled `good-first-issue`
- Read through the documentation
- Set up your development environment
- Ask questions if you need help!

#### Development Process
1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/mother-box-package.git
   cd mother-box-package
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-number
   ```

3. **Set Up Development Environment**
   ```bash
   ./scripts/install.sh
   source venv/bin/activate
   ```

4. **Make Your Changes**
   - Follow the existing code style
   - Add tests for new functionality
   - Update documentation as needed
   - Keep commits focused and atomic

5. **Test Your Changes**
   ```bash
   # Run all tests
   python -m pytest tests/

   # Run specific tests
   python -m pytest tests/unit/test_your_feature.py

   # Check code style
   flake8 .
   black --check .
   ```

6. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "feat: add new feature X

   - Detailed description of what changed
   - Why this change was necessary
   - Any breaking changes or side effects

   Closes #123"
   ```

7. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Use a clear, descriptive title
   - Reference any related issues
   - Describe what changes you made and why
   - Include screenshots for UI changes
   - Ensure all checks pass

### 4. Contributing Documentation

Good documentation is crucial! You can help by:
- Fixing typos and grammar
- Improving clarity and examples
- Adding missing documentation
- Translating documentation

### 5. Contributing Research & Domain Knowledge

Mother Box thrives on domain expertise:
- Add new industry knowledge maps
- Improve research methodologies
- Contribute interview templates
- Share domain-specific insights

## Coding Standards

### Python Code Style
- Follow PEP 8
- Use type hints where appropriate
- Maximum line length: 100 characters
- Use descriptive variable names
- Add docstrings to all functions and classes

Example:
```python
def create_agent(
    name: str,
    role: str,
    capabilities: List[str],
    personality: Optional[Dict[str, Any]] = None
) -> Agent:
    """
    Create a new agent with specified characteristics.
    
    Args:
        name: The agent's unique identifier
        role: The agent's primary role
        capabilities: List of agent capabilities
        personality: Optional personality traits
        
    Returns:
        Agent: The newly created agent instance
        
    Raises:
        ValueError: If name is empty or role is invalid
    """
    # Implementation here
```

### YAML Style
- Use 2 spaces for indentation
- Keep lines under 120 characters
- Use meaningful keys
- Add comments for complex structures

### Commit Messages
Follow the Conventional Commits specification:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

## Testing Guidelines

### Writing Tests
- Write tests for all new functionality
- Aim for >80% code coverage
- Use descriptive test names
- Include both positive and negative test cases

Example:
```python
def test_agent_creation_with_valid_data():
    """Test that an agent is created successfully with valid data."""
    agent = create_agent(
        name="test-agent",
        role="tester",
        capabilities=["testing", "validation"]
    )
    assert agent.name == "test-agent"
    assert agent.role == "tester"
    assert "testing" in agent.capabilities

def test_agent_creation_with_empty_name_raises_error():
    """Test that creating an agent with empty name raises ValueError."""
    with pytest.raises(ValueError, match="Name cannot be empty"):
        create_agent(name="", role="tester", capabilities=[])
```

## Areas for Contribution

### High Priority
- [ ] Multi-language support (i18n)
- [ ] Additional industry knowledge maps
- [ ] Performance optimizations
- [ ] Security enhancements
- [ ] Integration connectors

### Good First Issues
- [ ] Documentation improvements
- [ ] Adding unit tests
- [ ] Bug fixes
- [ ] Code cleanup
- [ ] Example templates

### Advanced Contributions
- [ ] New agent architectures
- [ ] Advanced workflow patterns
- [ ] Machine learning enhancements
- [ ] Real-time collaboration features

## Review Process

### What to Expect
1. **Initial Review** (1-2 days)
   - A maintainer will review your PR
   - They may request changes or ask questions
   - Be patient and responsive

2. **Testing & Validation**
   - Automated tests must pass
   - Code coverage checked
   - Security scanning performed

3. **Final Review**
   - Architecture and design review
   - Documentation check
   - Performance impact assessment

4. **Merge**
   - Once approved, your PR will be merged
   - You'll be added to our contributors list!

## Recognition

We value all contributions! Contributors are recognized in:
- The CONTRIBUTORS.md file
- Release notes
- Our documentation
- Annual contributor spotlight

## Questions?

If you have questions:
1. Check the documentation
2. Search existing issues and discussions
3. Ask in our Discord community
4. Create a discussion thread
5. Email us at contributors@mother-box.ai

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make Mother Box better! 🚀