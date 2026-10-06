# Macro (s: a player slot). As the player, at the grave: the item in storage stamina:grave cur goes into
# that slot if it's empty (by way of the helper display's contents slot), otherwise it drops at the player.
data remove storage stamina:grave cur.Slot
data modify entity @e[type=minecraft:item_display,tag=st.grave_helper,limit=1] item set from storage stamina:grave cur
$execute unless items entity @s $(s) * run return run item replace entity @s $(s) from entity @e[type=minecraft:item_display,tag=st.grave_helper,limit=1] contents
execute at @s run function stamina:grave/drop
