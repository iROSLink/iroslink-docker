#!/bin/bash
set -e
source /opt/ros/jazzy/setup.bash

# Kill any stale ROS processes and daemon (may have started with a different RMW)
pkill -9 -f ros 2>/dev/null || true
ros2 daemon stop 2>/dev/null || true

# Start zenoh router in background
ros2 run rmw_zenoh_cpp rmw_zenohd &
ZENOHD_PID=$!

# Wait for router to be ready on port 7447
echo "Waiting for rmw_zenohd..."
until nc -z localhost 7447 2>/dev/null; do
    sleep 0.5
done
echo "rmw_zenohd ready."

# Forward signals to children on exit
trap "kill $ZENOHD_PID 2>/dev/null" EXIT

exec "$@"
