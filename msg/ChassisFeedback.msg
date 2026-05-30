std_msgs/Header header

# Raw MCU feedback timestamp, in milliseconds.
uint32 timestamp_ms

# Decoded vehicle pose and chassis height values from the feedback frame.
float32 x
float32 y
float32 yaw_deg
float32 front_height
float32 rear_height

# Raw packed feedback tables from the MCU.
uint16 action_table
uint16 connection_table

# ActionState::table fields.
uint8 step_status
uint8 chassis_mode
bool chassis_curve_finished
uint8 lift_status
uint8 grip_status
bool grip_suction_has_object
uint8 infrared_receiver_state

# Connection::table bits.
bool wheel_0_online
bool wheel_1_online
bool wheel_2_online
bool wheel_3_online
bool lift_0_online
bool lift_1_online
bool lift_2_online
bool lift_3_online
bool grip_arm_online
bool grip_turn_online
bool gyro_yaw_online
bool upper_host_localization_online
bool upper_host_online
