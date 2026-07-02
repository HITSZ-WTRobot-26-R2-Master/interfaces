cmake_minimum_required(VERSION 3.8)
project(interfaces)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/SerialFrame.msg"
  "msg/SerialCommand.msg"
  "msg/ChassisPoseState.msg"
  "msg/ChassisActionState.msg"
  "msg/ChassisConnectionState.msg"
  "msg/ChassisFeedback.msg"
  "msg/R2Pose.msg"
  "msg/PoseCommand.msg"
  "msg/PoseFeedback.msg"
  "msg/BlockStates.msg"
  "msg/MasterRetry.msg"
  "msg/SpearheadMapTarget.msg"
  "msg/SpearheadMapTargetArray.msg"
  DEPENDENCIES std_msgs
)

ament_package()
