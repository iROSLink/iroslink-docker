# iROSLink Docker Bridge

The fastest way to get a full ROS2 + Foxglove visualization stack running alongside iROSLink — no ROS2 installation required on your machine.

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

---

## If You Already Have ROS2 Jazzy

Skip Docker entirely. Run these two commands in separate terminals:

**Terminal 1 — Zenoh router**
```bash
export RMW_IMPLEMENTATION=rmw_zenoh_cpp
ros2 run rmw_zenoh_cpp rmw_zenohd
```

**Terminal 2 — Foxglove bridge**
```bash
export RMW_IMPLEMENTATION=rmw_zenoh_cpp
ros2 launch foxglove_bridge foxglove_bridge_launch.xml address:=0.0.0.0 port:=8765
```

Then follow the same steps: set the phone to Client mode pointing at your machine's IP, connect Foxglove Studio to `ws://localhost:8765`.

!!! note "Package requirements"
    You need `ros-jazzy-rmw-zenoh-cpp` and `ros-jazzy-foxglove-bridge` installed:
    ```bash
    sudo apt install ros-jazzy-rmw-zenoh-cpp ros-jazzy-foxglove-bridge
    ```

---

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 7447 | TCP + UDP | Zenoh router (phone connects here) |
| 8765 | TCP | Foxglove WebSocket (Foxglove Studio connects here) |

---

## Keyboard Teleop (optional)

The container also includes `teleop_twist_keyboard`. To drive the robot from your keyboard:

```bash
docker exec -it foxglove-bridge bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```

---

## Troubleshooting

**Phone connects but no topics in Foxglove**
Verify the phone IP is set correctly in iROSLink and that port 7447 is not blocked by your firewall. On macOS you may need to allow incoming connections for Docker.

**`ros2 topic list` shows nothing on the host**
The container uses its own Zenoh router. If you want to bridge into a host ROS2 environment, configure the router to connect upstream in `config/zenoh_router.json5`.
