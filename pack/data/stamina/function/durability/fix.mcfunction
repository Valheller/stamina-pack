# Macro (slot), as a player whose broken item in $(slot) has been repaired: rebuild it whole on a hidden
# item_display, then put it back in the same slot
summon minecraft:item_display ~ ~ ~ {Tags:["st.dur_fix"],transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f],scale:[0f,0f,0f]}}
$item replace entity @e[type=minecraft:item_display,tag=st.dur_fix,limit=1] contents from entity @s $(slot)
execute as @e[type=minecraft:item_display,tag=st.dur_fix] run function stamina:durability/mend
$item replace entity @s $(slot) from entity @e[type=minecraft:item_display,tag=st.dur_fix,limit=1] contents
kill @e[type=minecraft:item_display,tag=st.dur_fix]
