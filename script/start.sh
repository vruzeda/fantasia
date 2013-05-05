#!/bin/bash
source "./script/pid.sh"

# Initial setup
mkdir -p ./data/mongo
mkdir -p ./data/redis
mkdir -p ./logs

# Starting databases
if [[ -z $(mongo_pid) ]]; then
  $MONGO_PATH --dbpath ./data/mongo > ./logs/mongo.log 2>&1 &
  echo "mongo running (pid: $(mongo_pid))."
else
  echo "mongo already running (pid: $(mongo_pid))."
fi

if [[ -z $(redis_pid) ]]; then
  $REDIS_PATH --dir    ./data/redis > ./logs/redis.log 2>&1 &
  echo "redis running (pid: $(redis_pid))."
else
  echo "redis already running (pid: $(redis_pid))."
fi

# Starting server
if [[ -z $(node_pid) ]]; then
  $NODE_PATH index.js > /dev/null &
  echo "node running (pid: $(node_pid))."
else
  echo "node already running (pid: $(node_pid))."
fi

exit 0