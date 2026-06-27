# iROSLink Docker Bridge

A full ROS2 + Foxglove visualization stack running alongside iROSLink in docker, check detail at 

The container runs **ROS2 Jazzy** with:
- `rmw_zenoh_cpp` — Zenoh transport so the phone and your machine share the same ROS2 network
- `foxglove_bridge` — exposes all ROS2 topics to Foxglove Studio over WebSocket on port 8765
- A Zenoh router listening on port 7447 (phone connects here)

```
iPhone (iROSLink)
    └── Zenoh tcp/<HOST_IP>:7447
            └── Docker container (rmw_zenohd + foxglove_bridge)
                    └── ws://localhost:8765
                            └── Foxglove Studio
```

---

## Prerequisites

- Docker and Docker Compose installed
- iROSLink on an iPhone on the same WiFi network
- Foxglove Studio (browser: [studio.foxglove.dev](https://studio.foxglove.dev) or desktop app)

---

## Quick Start

```bash
docker compose up --build
```

Then:

1. In iROSLink → **Settings → ROS2 Bridge (Zenoh)** → set mode to **Client** → enter `tcp/<YOUR_MACHINE_IP>:7447`
2. Open Foxglove Studio → **Open connection → Foxglove WebSocket** → `ws://localhost:8765`
3. On the phone **Scan** tab, start a session — topics appear in Foxglove


## Keyboard Teleop (optional)

The container also includes `teleop_twist_keyboard`. To drive the robot from your keyboard:

```bash
docker exec -it foxglove-bridge bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```
