uint8 NO_COMMAND=0
uint8 RESET_ODIN_FROM_CAR_POSE=1
uint8 FIX_WORLD=2

std_msgs/Header header

# RESET_ODIN_FROM_CAR_POSE:
#   pose_* is the current known car pose in the real/world frame.
# FIX_WORLD:
#   pose_* is the base pose estimate from /pose/feedback base_* fields, and
#   real_* is the externally measured current car pose. All yaw fields use
#   degrees.
uint8 command

float32 pose_x
float32 pose_y
float32 pose_z
float32 pose_yaw_deg

float32 real_x
float32 real_y
float32 real_z
float32 real_yaw_deg
