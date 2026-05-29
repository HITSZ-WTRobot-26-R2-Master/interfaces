uint8 NO_COMMAND=0
uint8 STATUS_OK=0
uint8 STATUS_REJECTED=1
uint8 STATUS_INVALID_COMMAND=2
uint8 STATUS_NO_POSE=3
uint8 STATUS_INVALID_DATA=4

std_msgs/Header header

uint8 command
uint8 status
bool accepted
string message

# Last base odin pose estimate before the active map correction. Master
# control should echo these base_* fields into PoseCommand pose_* for FIX_WORLD.
float32 base_x
float32 base_y
float32 base_z
float32 base_yaw_deg

# Last corrected pose published by pose_node. All yaw fields use degrees.
float32 current_x
float32 current_y
float32 current_z
float32 current_yaw_deg

# Active map correction transform applied after the base odin pose estimate.
float32 correction_x
float32 correction_y
float32 correction_z
float32 correction_yaw_deg
uint32 correction_pair_count
