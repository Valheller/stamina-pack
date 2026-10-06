# At the centre of a grave: take it away, with its compass waypoint. The chunk stops being kept loaded,
# unless another grave is in it.
kill @e[tag=st.tomb_part,distance=..0.1]
execute positioned ~ ~1 ~ run kill @e[type=minecraft:armor_stand,tag=st.grave_wp,distance=..0.8]
forceload remove ~ ~
execute at @e[type=minecraft:marker,tag=st.tomb,distance=..48] run forceload add ~ ~
