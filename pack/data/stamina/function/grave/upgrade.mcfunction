# As/at a grave from before the gravestone model (no st.tomb_v2; stamina:tick, once a second): its stretched
# block displays and old "R.I.P." text give way to the new stone (stamina:grave/stone), facing the same way
tag @s add st.tomb_v2
kill @e[type=minecraft:block_display,tag=st.tomb_part,distance=..0.1]
kill @e[type=minecraft:text_display,tag=st.tomb_part,distance=..0.1]
function stamina:grave/stone
execute as @e[tag=st.tomb_new,distance=..0.1] run data modify entity @s Rotation set from entity @e[type=minecraft:marker,tag=st.tomb,distance=..0.1,limit=1] Rotation
data remove storage stamina:grave name
data modify storage stamina:grave name.n set from entity @s data.owner
execute if data storage stamina:grave name.n run function stamina:grave/name with storage stamina:grave name
tag @e[tag=st.tomb_new] remove st.tomb_new
