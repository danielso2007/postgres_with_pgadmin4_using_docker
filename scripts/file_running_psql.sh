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

echo -e "${YELLOW}Usage:${NC} ${YELLOW}./file_running_psql.sh [DATABASE] [FILE.SQL].${NC}"

if [[ -z "$1" ]]; then
echo -e "${RED}Inform the database.${NC}"
exit 0
fi

if [[ -z "$2" ]]; then
echo -e "${RED}Enter the sql file.${NC}"
exit 0
fi

cp $2 ../data/$2

echo -e "${YELLOW}Running script...${NC}"
docker exec -it pgsql psql -U postgres -f /opt/dump/$2 $1