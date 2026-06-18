#!/bin/bash
export PGCLIENTENCODING=UTF8   # ensure psql uses UTF-8 (loads RetailMart data without errors)
# ---------------------------------------------------------------
# Complete Dev Environment Installer for macOS
# Installs: PostgreSQL, pgAdmin 4, VS Code, Git
# Creates: postgres superuser + accio practice DB
# Author: Sayyed Siraj Ali
# ---------------------------------------------------------------

set -e

# -- Defaults - override by env vars before running -------------
#   PG_USER=postgres   PG_PASSWORD=postgres   BATCH=26   bash install_mac.sh
PG_USER="${PG_USER:-postgres}"
PG_PASSWORD="${PG_PASSWORD:-postgres}"
BATCH="${BATCH:-26}"
PRACTICE_DB="accio_${BATCH}"

echo ""
echo " AccioJob SQL - macOS Setup Installer"
echo "========================================="
echo "  User:        $PG_USER"
echo "  Password:    $PG_PASSWORD"
echo "  Practice DB: $PRACTICE_DB"
echo "========================================="
echo ""

# -- Step 1: Homebrew ---------------------------------------------
if ! command -v brew &>/dev/null; then
  echo " Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo " Homebrew already installed."
fi

echo " Updating Homebrew..."
brew update

# -- Step 2: PostgreSQL (latest) ----------------------------------
if command -v psql &>/dev/null; then
  echo " PostgreSQL already installed: $(psql --version)"
else
  echo " Installing PostgreSQL (latest)..."
  brew install postgresql
fi

# Ensure the service is running (idempotent - safe even if already started)
echo " Starting PostgreSQL service..."
brew services start postgresql >/dev/null 2>&1 || true

# Wait up to 30 seconds for postgres to accept connections
echo " Waiting for PostgreSQL to accept connections..."
for i in {1..30}; do
  if psql -d postgres -c "SELECT 1" >/dev/null 2>&1; then
    echo " PostgreSQL is up."
    break
  fi
  sleep 1
  if [ "$i" -eq 30 ]; then
    echo " PostgreSQL did not start in 30 seconds. Run: brew services list"
    exit 1
  fi
done

# -- Step 3: Create $PG_USER role + practice DB -------------------
echo ""
echo " Setting up '$PG_USER' superuser and '$PRACTICE_DB' practice DB..."

# Role: create if missing, update password unconditionally
psql -d postgres -v ON_ERROR_STOP=1 <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$PG_USER') THEN
    CREATE ROLE "$PG_USER" WITH LOGIN SUPERUSER PASSWORD '$PG_PASSWORD';
  ELSE
    ALTER ROLE "$PG_USER" WITH LOGIN SUPERUSER PASSWORD '$PG_PASSWORD';
  END IF;
END
\$\$;
SQL
echo "   Role '$PG_USER' ready (password set)."

# Practice DB: create if missing (owned by $PG_USER)
DB_EXISTS=$(psql -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$PRACTICE_DB'")
if [ "$DB_EXISTS" != "1" ]; then
  psql -d postgres -c "CREATE DATABASE \"$PRACTICE_DB\" OWNER \"$PG_USER\";"
  echo "   Database '$PRACTICE_DB' created."
else
  echo "   Database '$PRACTICE_DB' already exists."
fi

# -- Step 4: pgAdmin 4 -------------------------------------------
if [ -d "/Applications/pgAdmin 4.app" ]; then
  echo " pgAdmin 4 already installed."
else
  echo " Installing pgAdmin 4..."
  brew install --cask pgadmin4
fi

# -- Step 5: VS Code ---------------------------------------------
if command -v code &>/dev/null; then
  echo " VS Code already installed: $(code --version | head -1)"
else
  echo " Installing VS Code..."
  brew install --cask visual-studio-code

  # Register 'code' command in PATH
  VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  if [ -f "$VSCODE_BIN" ]; then
    echo " Registering 'code' command in PATH..."
    sudo ln -sf "$VSCODE_BIN" /usr/local/bin/code 2>/dev/null || {
      # If /usr/local/bin doesn't work, add to PATH via .zshrc
      echo "export PATH=\"\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin\"" >> ~/.zshrc
    }
  fi
fi

# -- Step 6: Git --------------------------------------------------
if command -v git &>/dev/null; then
  echo " Git already installed: $(git --version)"
else
  echo " Installing Git..."
  brew install git

  # Ensure brew-installed git is found
  eval "$(brew shellenv 2>/dev/null)"
  hash -r 2>/dev/null
fi

# -- Summary ------------------------------------------------------
echo ""
echo "========================================="
echo " Installation Complete! Here's your setup:"
echo "========================================="
echo ""

# PostgreSQL
psql_ver=$(psql --version 2>/dev/null || echo "not found")
echo "   PostgreSQL : $psql_ver"

# pgAdmin 4
if [ -d "/Applications/pgAdmin 4.app" ]; then
  echo "    pgAdmin 4  : Installed (/Applications)"
else
  echo "    pgAdmin 4  : Not found"
fi

# VS Code
code_ver=$(code --version 2>/dev/null | head -1 || echo "not found")
echo "   VS Code    : $code_ver"

# Git
git_ver=$(git --version 2>/dev/null || echo "not found")
echo "   Git        : $git_ver"

echo ""
echo " Database Connection Details:"
echo "   Host     : localhost"
echo "   Port     : 5432"
echo "   User     : $PG_USER"
echo "   Password : $PG_PASSWORD"
echo "   Database : $PRACTICE_DB"
echo ""
echo "   Test connection:  psql -h localhost -U $PG_USER -d $PRACTICE_DB"
echo ""
echo " Next Steps:"
echo "   1. Restart Terminal (so PATH updates take effect)"
echo "   2. Open pgAdmin 4 -> Create Server -> use the credentials above"
echo "   3. Open VS Code -> Install SQLTools + SQLTools PostgreSQL extensions"
echo "   4. Import RetailMart: psql -U $PG_USER -d $PRACTICE_DB -f setup_accio_retailmart.sql"
echo ""
