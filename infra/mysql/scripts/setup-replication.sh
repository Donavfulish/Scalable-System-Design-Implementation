#!/usr/bin/env bash
set -euo pipefail

MASTER_HOST="mysql-master"
SLAVE_HOST="mysql-slave"
ADMIN_USER="${MYSQL_ADMIN_USER:-admin_user}"
ADMIN_PASSWORD="${MYSQL_ADMIN_PASSWORD:-admin_pass}"
REPL_USER="${MYSQL_REPL_USER:-repl_user}"
REPL_PASSWORD="${MYSQL_REPL_PASSWORD:-repl_pass}"

echo "[replication-setup] Waiting for MySQL nodes..."
until mysql -h "${MASTER_HOST}" -u"${ADMIN_USER}" -p"${ADMIN_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do sleep 2; done
until mysql -h "${SLAVE_HOST}" -u"${ADMIN_USER}" -p"${ADMIN_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do sleep 2; done

echo "[replication-setup] Reset slave state..."
mysql -h "${SLAVE_HOST}" -u"${ADMIN_USER}" -p"${ADMIN_PASSWORD}" -e "STOP REPLICA; RESET REPLICA ALL;" || true

echo "[replication-setup] Getting master binary log coordinates..."
MASTER_STATUS=$(mysql -h "${MASTER_HOST}" -u"${ADMIN_USER}" -p"${ADMIN_PASSWORD}" -e "SHOW MASTER STATUS\G")
LOG_FILE=$(echo "${MASTER_STATUS}" | awk '/File:/ {print $2}')
LOG_POS=$(echo "${MASTER_STATUS}" | awk '/Position:/ {print $2}')

if [[ -z "${LOG_FILE}" || -z "${LOG_POS}" ]]; then
  echo "[replication-setup] Failed to read master coordinates"
  exit 1
fi

echo "[replication-setup] Configuring slave replication..."
mysql -h "${SLAVE_HOST}" -u"${ADMIN_USER}" -p"${ADMIN_PASSWORD}" -e "
  CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='${MASTER_HOST}',
    SOURCE_USER='${REPL_USER}',
    SOURCE_PASSWORD='${REPL_PASSWORD}',
    SOURCE_LOG_FILE='${LOG_FILE}',
    SOURCE_LOG_POS=${LOG_POS},
    SOURCE_PORT=3306,
    SOURCE_CONNECT_RETRY=5;
  START REPLICA;
  SET GLOBAL read_only = ON;
  SET GLOBAL super_read_only = ON;
"

echo "[replication-setup] Replication status:"
mysql -h "${SLAVE_HOST}" -u"${ADMIN_USER}" -p"${ADMIN_PASSWORD}" -e "SHOW REPLICA STATUS\G"
echo "[replication-setup] Completed."
