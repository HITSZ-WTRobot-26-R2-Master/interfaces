# Build from this package directory:
#   docker build -t r2_master_interface:humble .

ARG ROS_DISTRO=humble
FROM ros:${ROS_DISTRO}-ros-base

ARG ROS_DISTRO
ARG UBUNTU_MIRROR=https://mirrors.osa.moe/ubuntu/

ENV ROS_DISTRO=${ROS_DISTRO} \
    WORKSPACE_DIR=/workspace \
    INTERFACES_DIR=/workspace/src/interfaces \
    DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN <<EOF
set -euo pipefail
. /etc/os-release
codename="${VERSION_CODENAME}"
rm -f /etc/apt/sources.list.d/ubuntu.sources
cat >/etc/apt/sources.list <<SOURCES
# Source mirror entries are commented out to keep apt update fast.
deb ${UBUNTU_MIRROR} ${codename} main restricted universe multiverse
# deb-src ${UBUNTU_MIRROR} ${codename} main restricted universe multiverse
deb ${UBUNTU_MIRROR} ${codename}-updates main restricted universe multiverse
# deb-src ${UBUNTU_MIRROR} ${codename}-updates main restricted universe multiverse
deb ${UBUNTU_MIRROR} ${codename}-backports main restricted universe multiverse
# deb-src ${UBUNTU_MIRROR} ${codename}-backports main restricted universe multiverse

# deb ${UBUNTU_MIRROR} ${codename}-security main restricted universe multiverse
# deb-src ${UBUNTU_MIRROR} ${codename}-security main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ ${codename}-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ ${codename}-security main restricted universe multiverse

# Prerelease repository, not recommended.
# deb ${UBUNTU_MIRROR} ${codename}-proposed main restricted universe multiverse
# deb-src ${UBUNTU_MIRROR} ${codename}-proposed main restricted universe multiverse
SOURCES
EOF

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3-colcon-common-extensions \
        ros-${ROS_DISTRO}-ament-cmake \
        ros-${ROS_DISTRO}-rosidl-default-generators \
        ros-${ROS_DISTRO}-rosidl-default-runtime \
        ros-${ROS_DISTRO}-std-msgs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${WORKSPACE_DIR}

COPY CMakeLists.txt package.xml src/interfaces/
COPY msg/ src/interfaces/msg/

RUN source "/opt/ros/${ROS_DISTRO}/setup.bash" \
    && colcon build \
        --packages-select interfaces \
        --symlink-install \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/R2Pose.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/SerialFrame.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/SerialCommand.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/ChassisFeedback.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/PoseCommand.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/PoseFeedback.msg"

COPY --chmod=755 docker/ros_entrypoint.sh /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
