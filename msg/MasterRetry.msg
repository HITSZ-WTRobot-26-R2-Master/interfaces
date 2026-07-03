uint8 STAGE_TAKE_SPEAR=1
uint8 STAGE_MERLIN=2
uint8 STAGE_COMBAT=3

uint8 COMBAT_SOURCE_HAS_SCROLL=1
uint8 COMBAT_SOURCE_TAKE_SCROLL_1=2
uint8 COMBAT_SOURCE_TAKE_SCROLL_2=3

uint8 COMBAT_PLACE_MIDDLE=1
uint8 COMBAT_PLACE_TOP=2

uint8 stage
uint8 spear_index
bool previous_spear_needs_dock
uint8 r2_taken_count
uint8[] taken_r2_blocks
uint8 combat_source
uint8 combat_place_layer
