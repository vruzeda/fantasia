#!/bin/bash
source "./script/pid.sh"

# Stopping server
if [[ -n $(node_pid)  ]]; then
  kill $(node_pid)
  echo "node stopped."
else
  echo "node already stopped."
fi

# Stopping databases
if [[ -n $(redis_pid) ]]; then
  kill $(redis_pid)
  echo "redis stopped."
else
  echo "redis already stopped."
fi

if [[ -n $(mongo_pid) ]]; then
  kill $(mongo_pid)
  echo "mongo stopped."
else
  echo "mongo already stopped."
fi