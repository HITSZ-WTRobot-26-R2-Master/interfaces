# Build from this package directory:
#   docker build -t r2_master_interface:humble .

ARG ROS_DISTRO=humble
FROM ros:${ROS_DISTRO}-ros-base

ARG ROS_DISTRO
ARG USE_APT_MIRROR=true
ARG UBUNTU_MIRROR=https://mirror.nju.edu.cn/ubuntu/
ARG ROS2_APT_MIRROR=https://mirrors.nju.edu.cn/ros2/ubuntu

ENV ROS_DISTRO=${ROS_DISTRO} \
    WORKSPACE_DIR=/workspace \
    INTERFACES_DIR=/workspace/src/interfaces \
    DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN <<EOF
set -euo pipefail
if [ "${USE_APT_MIRROR}" = "true" ]; then
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
    for ros_source in \
        /etc/apt/sources.list.d/ros2.sources \
        /etc/apt/sources.list.d/ros2.list \
        /etc/apt/sources.list.d/ros2-latest.list \
        /usr/share/ros-apt-source/ros2.sources; do
        if [ -e "${ros_source}" ] || [ -L "${ros_source}" ]; then
            sed -i --follow-symlinks \
                -e "s#http://packages.ros.org/ros2/ubuntu#${ROS2_APT_MIRROR}#g" \
                -e "s#https://packages.ros.org/ros2/ubuntu#${ROS2_APT_MIRROR}#g" \
                -e "s#^Types: deb deb-src\$#Types: deb#g" \
                "${ros_source}"
        fi
    done
fi
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
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/ChassisPoseState.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/ChassisActionState.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/ChassisConnectionState.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/ChassisFeedback.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/PoseCommand.msg" \
    && test -f "${WORKSPACE_DIR}/install/interfaces/share/interfaces/msg/PoseFeedback.msg"

COPY --chmod=755 docker/ros_entrypoint.sh /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
