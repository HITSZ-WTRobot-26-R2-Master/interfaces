# Repository Guidelines

## Project Structure & Module Organization

This repository is the ROS 2 interface package named `interfaces`. All custom
ROS message definitions for the master workspace live in `msg/`; downstream
packages must consume those shared messages instead of adding package-local
`.msg` files. Package metadata lives in `package.xml` and `CMakeLists.txt`.
The package is built into the shared container base image
`r2_master_interface`.

## Container Build and Validation

- Build the base image from this package directory:
  `docker build -t r2_master_interface:humble .`
- The Dockerfile must use the official ROS Docker image namespace by default,
  currently `ros:humble-ros-base`. Do not default this image to the local
  custom `ros2:humble` base.
- The container workspace root is `/workspace`, and this package is copied to
  `/workspace/src/interfaces`.
- The host machine does not have ROS2 installed. Validate with Docker, not
  host-side `ros2` or `colcon` commands.
- A quick container check after building is:
  `docker run --rm r2_master_interface:humble bash -lc 'ros2 interface show interfaces/msg/SerialFrame && ros2 interface show interfaces/msg/ChassisFeedback && ros2 interface show interfaces/msg/PoseCommand && ros2 interface show interfaces/msg/PoseFeedback'`.

## Naming and Downstream Compatibility

The package was renamed from `serial_interfaces` to `interfaces`. Downstream
packages that still import or depend on `serial_interfaces` are intentionally
not guaranteed to work until a follow-up migration updates their imports,
`package.xml` dependencies, CMake `find_package(...)`, and generated include
paths.

## Coding Style

Keep message definitions small and stable. When changing a `.msg` field, search
for all publishers/subscribers first and document downstream breakage if the
consumers are out of scope for the current task. When adding a new message,
register it in `CMakeLists.txt` and update container validation checks.
