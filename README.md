R2 Master Interfaces
====================

This package defines the shared ROS2 message interfaces for the R2 master
container workspace. All custom ROS messages for downstream master packages
live here so each node consumes a single shared contract. It replaces the
earlier `serial_interfaces` package name with the generic ROS package name
`interfaces`.

Container Layout
----------------

The container workspace root is `/workspace`, and package sources are expected
under `/workspace/src/<package>`. This package is copied to:

```text
/workspace/src/interfaces
```

Build the base image from this package directory:

```bash
docker build -t r2_master_interface:humble .
```

The Dockerfile defaults to the official ROS Docker image
`ros:humble-ros-base`. Do not use the local custom `ros2:humble` image as the
base for this package.

The ROS distro can be adjusted while still using the official ROS image
namespace:

```bash
docker build \
  --build-arg ROS_DISTRO=humble \
  -t r2_master_interface:humble .
```

The image builds only the `interfaces` package and installs the overlay under
`/workspace/install`. Downstream node images can derive from this image and
source `/workspace/install/setup.bash` before building their own packages.

Validation
----------

The host machine does not provide a ROS2 environment. Validate this package via
Docker, not host-side `ros2` or `colcon` commands:

```bash
docker build -t r2_master_interface:humble .
docker run --rm r2_master_interface:humble \
  bash -lc 'ros2 interface show interfaces/msg/SerialFrame && ros2 interface show interfaces/msg/ChassisFeedback && ros2 interface show interfaces/msg/PoseCommand && ros2 interface show interfaces/msg/PoseFeedback'
```

Downstream Migration Note
-------------------------

Downstream packages that still depend on `serial_interfaces` must be migrated
later to import and depend on `interfaces`. This base-image task does not
guarantee downstream package compatibility.
