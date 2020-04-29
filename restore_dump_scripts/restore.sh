#!/bin/bash
RED='\033[1;31m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
BROWN_ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
VALID=true
set -e

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo -e "${RED}Usage:${NC} ${LIGHT_RED}./restore.sh [DATABASE] or ./restore.sh [DATABASE] [FILE]${NC}"
    exit 0
fi

username="postgres"
senha="postgres"
db="default"
port="5432"
host="localhost"
file="dump.dmp"
docker="pgsql"
owner="postgres"

# Senha do root quando executado localmente
# export PGPASSWORD=postgres

echo -e "${YELLOW}Database restore:${NC}"
echo -e "${YELLOW}Default docker:${NC} ${LIGHT_PURPLE}$docker${NC}"
echo -e "${YELLOW}Username:${NC} ${LIGHT_PURPLE}${username}${NC}"
echo -e "${YELLOW}Password:${NC} ${LIGHT_PURPLE}${senha}${NC}"

if [[ -z "$1" ]]; then
    echo -e "${RED}Database default:${NC} ${LIGHT_PURPLE}$db${NC}"
else
    db=$1
    echo -e "${YELLOW}Database:${NC} ${LIGHT_PURPLE}$db${NC}"
fi
if [[ -z "$2" ]]; then
    echo -e "${RED}Default file:${NC} ${LIGHT_PURPLE}$file${NC}"
else
    file=$2
    echo -e "${YELLOW}File:${NC} ${LIGHT_PURPLE}$file${NC}"
fi

# Copiar o arquivo de dump para entro do volume do docker.
echo -e "${YELLOW}Copying file to dump folder...${NC}"
echo -e "${BLUE}If there is an error copying the file, check the permission of the ./data folder${NC}"
cp "$file" ../data/"$file"

echo -e "${YELLOW}Port:${NC} ${LIGHT_PURPLE}${port}${NC}"
echo -e "${YELLOW}Host:${NC} ${LIGHT_PURPLE}${host}${NC}"
# echo -e "${YELLOW}Export PGPASSWORD:${NC} ${LIGHT_PURPLE}${PGPASSWORD}${NC}"
echo -e "${YELLOW}Disconnecting all users and DROP / CREATE from the pack:${NC} ${LIGHT_PURPLE}$db${NC}"

# Apagando os processo e banco de dados para criar um novo.
docker exec -i $docker psql -U postgres <<EOF
update pg_database set datallowconn = 'false' where datname = '$db';
SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$db' AND pid <> pg_backend_pid();
DROP DATABASE IF EXISTS "$db";
CREATE DATABASE "$db" WITH OWNER ${owner} ENCODING 'UTF-8' TEMPLATE template0;
update pg_database set datallowconn = 'true' where datname = '$db';
EOF

# Restaura o dump do banco
echo -e "${YELLOW}Restoring database...${NC}"
docker exec -i $docker psql -q -U $username -d "$db" -f /opt/dump/"$file"
