#!/bin/bash

# Script to push Mother Box to GitHub

echo "================================================"
echo "Push Mother Box Package to GitHub"
echo "================================================"
echo ""

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: Not in a git repository!"
    echo "Please run this script from the mother-box-package directory."
    exit 1
fi

echo "This script will help you push the Mother Box package to GitHub."
echo ""
echo "STEP 1: First, create a new repository on GitHub:"
echo "-----------------------------------------------"
echo "1. Go to https://github.com/new"
echo "2. Repository name: mother-box-package"
echo "3. Description: AI Agent Team Creation System using BMAD methodology"
echo "4. Set as Public or Private (your choice)"
echo "5. DO NOT initialize with README, .gitignore, or license"
echo "6. Click 'Create repository'"
echo ""
read -p "Press Enter when you've created the repository on GitHub..."

echo ""
echo "STEP 2: Enter your GitHub username:"
read -p "GitHub username: " GITHUB_USERNAME

echo ""
echo "STEP 3: Choose your repository visibility:"
echo "1) Public repository"
echo "2) Private repository"
read -p "Enter choice (1 or 2): " REPO_VISIBILITY

if [ "$REPO_VISIBILITY" == "1" ]; then
    REPO_URL="https://github.com/${GITHUB_USERNAME}/mother-box-package.git"
else
    REPO_URL="git@github.com:${GITHUB_USERNAME}/mother-box-package.git"
fi

echo ""
echo "STEP 4: Adding GitHub as remote origin..."
echo "Repository URL: $REPO_URL"

# Remove existing origin if it exists
git remote remove origin 2>/dev/null || true

# Add new origin
git remote add origin "$REPO_URL"

echo "✓ Remote origin added"

echo ""
echo "STEP 5: Pushing to GitHub..."

# Push to GitHub
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "✅ SUCCESS! Mother Box has been pushed to GitHub!"
    echo "================================================"
    echo ""
    echo "Your repository is now available at:"
    echo "https://github.com/${GITHUB_USERNAME}/mother-box-package"
    echo ""
    echo "Next steps:"
    echo "1. Visit your repository on GitHub"
    echo "2. Add topics: ai, agents, automation, bmad"
    echo "3. Update the About section"
    echo "4. Consider adding GitHub Actions for CI/CD"
    echo "5. Enable GitHub Pages for documentation (optional)"
    echo ""
else
    echo ""
    echo "❌ Push failed. Common issues and solutions:"
    echo ""
    echo "1. Authentication failed:"
    echo "   - For HTTPS: You may need a Personal Access Token"
    echo "     Go to: GitHub Settings > Developer settings > Personal access tokens"
    echo "   - For SSH: Make sure your SSH key is added to GitHub"
    echo "     Check: ssh -T git@github.com"
    echo ""
    echo "2. Repository doesn't exist:"
    echo "   - Make sure you created the repository on GitHub first"
    echo ""
    echo "3. Branch name mismatch:"
    echo "   - Try: git branch -M main"
    echo "   - Then: git push -u origin main"
    echo ""
    echo "Manual commands to try:"
    echo "  git remote set-url origin $REPO_URL"
    echo "  git push -u origin main"
fi