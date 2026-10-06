# Step down through open air (not water, lava or the void) so the grave rests on the ground, at most 32
# blocks; then look for a free block from there (stamina:grave/find_spot)
execute if score #fall st.tmp matches ..31 if block ~ ~ ~ #stamina:grave_fall if block ~ ~-1 ~ #stamina:grave_fall run return run function stamina:grave/find_ground_step
return run function stamina:grave/find_spot
