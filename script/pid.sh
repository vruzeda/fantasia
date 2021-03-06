#!/bin/bash
function parse_pid_for() {
  ps -u $(whoami) -o pid,args= | grep -v "grep" | grep "$@" | sed "s/^ *\([^ ]*\).*/\1/g"
}

function mongo_pid() {
  parse_pid_for "$MONGO_PATH/mongod"
}

function redis_pid() {
  parse_pid_for "$REDIS_PATH/redis-server"
}

function node_pid() {
  parse_pid_for "$NODE_PATH/nodemon"
}
