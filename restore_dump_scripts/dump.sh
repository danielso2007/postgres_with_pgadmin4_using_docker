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

if [[ -z "$1" ]]; then
    echo -e "${RED}Usage:${NC} ${LIGHT_RED}./dump.sh [DATABASE] or ./dump.sh [DATABASE] [FILE]${NC}"
    exit 0
fi

username="postgres"
senha="postgres"
db="default"
port="5432"
host="localhost"
prefixfile="dump-"
default_local="/opt/dump/"
file="${prefixfile}$(date +%Y%m%d-%H%M%S).dmp"

docker="pgsql"
owner="postgres"

# Senha do root quando executado localmente
# export PGPASSWORD=postgres

echo -e "${YELLOW}Username:${NC} ${LIGHT_PURPLE}${username}${NC}"
echo -e "${YELLOW}Password:${NC} ${LIGHT_PURPLE}${senha}${NC}"

if [[ -z "$1" ]]; then
    echo -e "${RED}Database default:${NC} ${LIGHT_PURPLE}${db}${NC}"
else
    db=$1
    echo -e "${YELLOW}Database:${NC} ${LIGHT_PURPLE}${db}${NC}"
fi

if [[ -z "$2" ]]; then
    echo -e "${RED}Default file:${NC} ${LIGHT_PURPLE}${file}${NC}"
else
    file="$2-$(date +%Y%m%d-%H%M%S).dmp"
    echo -e "${YELLOW}File:${NC} ${LIGHT_PURPLE}${file}${NC}"
fi

echo -e "${YELLOW}Port:${NC} ${LIGHT_PURPLE}${port}${NC}"
echo -e "${YELLOW}Host:${NC} ${LIGHT_PURPLE}${host}${NC}"

# echo -e "${YELLOW}Export PGPASSWORD:${NC} ${LIGHT_PURPLE}${PGPASSWORD}${NC}"

echo -e "${YELLOW}Creating dump: ${file}${NC}"
docker exec -i $docker pg_dump -U $username $db >${file}
echo -e "${YELLOW}End of dump.${NC}"

echo -e "${YELLOW}Compressing dump...${NC}"
tar -zcvf ${file}.gz ${file}
echo -e "${YELLOW}End.${NC}"

ls -l
