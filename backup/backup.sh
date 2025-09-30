#!/bin/bush
if [[ $# -lt 0 || $# -gt 2 ]]; then
    echo "Write bash ./backup.sh sourcedir backupdir"
    exit 1
fi

if [[ -d "$1" ]]; then
  SOURCE_DIR=$1
elif [[ "$1" == "default" ]]; then
  SOURCE_DIR=$HOME/Documents/devops/devops-portfolio/source/test1  
else
  echo "Write right path from witch directory to make backup or default"
  exit 1
fi

if [[ -d "$2" ]]; then
  BACKUP_DIR=$2
elif [[ "$2" == "default" ]]; then
  BACKUP_DIR=$HOME/Documents/devops/devops-portfolio/backup
else
  echo "Write path to witch directory to save or default"
  exit 1
fi

LOG_FILE="$BACKUP_DIR/logfile.log"
log(){
    echo "[$(date '+%Y-%m-%d %H:%M:S')] $1" | tee -a "$LOG_FILE"
}

if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR: Directory $SOURCE_DIR doesn’t exist!"
    exit 1
fi

log "The start of process"
tar -czvf "$BACKUP_DIR/$(date +%Y%m%d-%H%M%S).tar.gz" -C "$SOURCE_DIR" .
find $BACKUP_DIR -type f -name "*.tar.gz" | sort | head -n -5 | xargs rm
