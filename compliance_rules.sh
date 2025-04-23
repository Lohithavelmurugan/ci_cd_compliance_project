#!/bin/bash

echo "Running Institutional Compliance Check..."

# 1. Check for hardcoded secrets (excluding .env, .git, .cache, this script itself)
if grep -r --binary-files=without-match --exclude-dir={.git,.cache} --exclude={.env,compliance_rules.sh} -i 'password\|apikey\|token' .; then
  echo "❌ Hardcoded secret found."
  exit 1
fi

# 2. Check for exposed port 22
if grep -q 'EXPOSE 22' Dockerfile; then
  echo "❌ Port 22 should not be exposed."
  exit 1
fi

# 3. Check for .env being tracked by Git
if git ls-files | grep -q '^.env$'; then
  echo "❌ .env file is tracked. Should be in .gitignore."
  exit 1
fi

# 4. Check for logging usage in app.py
if ! grep -q 'import logging' app.py; then
  echo "❌ Logging not found in app."
  exit 1
fi

# 5. Check for privacy policy
if [ ! -f PRIVACY.md ]; then
  echo "❌ PRIVACY.md not found."
  exit 1
fi

echo "✅ Institutional Compliance Passed"
exit 0
