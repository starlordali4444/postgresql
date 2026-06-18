#!/bin/bash

set -e

echo "🚀 RetailMart setup starting..."

export PGPASSWORD=postgres

echo "📦 Installing PostgreSQL client..."

sudo apt-get update
sudo apt-get install -y postgresql-client

# Wait for PostgreSQL
echo "⏳ Waiting for PostgreSQL..."

for i in {1..30}; do
    if pg_isready -h postgres -U postgres -q; then
        echo "✅ PostgreSQL is ready!"
        break
    fi
    sleep 2
done

SETUP_SQL="site/datasets/sql/setup_accio_retailmart.sql"

if [ ! -f "$SETUP_SQL" ]; then
    echo "❌ Setup SQL not found!"
    exit 1
fi

# Check if database already loaded
TABLE_EXISTS=$(psql -h postgres -U postgres -d accio_retailmart -tAc "
SELECT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema='core'
);
" || true)

if [ "$TABLE_EXISTS" = "t" ]; then
    echo "✅ RetailMart already loaded. Skipping import."
    exit 0
fi

echo "📊 Loading RetailMart dataset..."
echo "☕ This may take several minutes..."

psql -h postgres -U postgres -d accio_retailmart -f "$SETUP_SQL"

echo ""
echo "🎉 RetailMart loaded successfully!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Database : accio_retailmart"
echo "User     : postgres"
echo "Password : postgres"
echo ""
echo "🌐 pgAdmin Login"
echo "Email    : admin@retailmart.local"
echo "Password : postgres"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"