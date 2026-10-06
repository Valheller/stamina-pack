# Macro (slot, tag, inert, mat, key, model), as the player, while the game is still breaking the item in $(slot).
# Copy it onto a hidden item_display and rebuild it there as broken. The game then empties the slot as
# usual; next tick stamina:durability/place gives the broken item back. The display carries the owner's
# st.pid and a tag saying where the item goes.
execute unless score @s st.pid matches 1.. store result score @s st.pid run scoreboard players add #pid st.pid 1
$data modify storage stamina:dur a set value {inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
summon minecraft:item_display ~ ~ ~ {Tags:["st.dur","st.dur_new"],transformation:{left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],translation:[0f,0f,0f],scale:[0f,0f,0f]}}
$item replace entity @e[type=minecraft:item_display,tag=st.dur_new,limit=1] contents from entity @s $(slot)
$tag @e[type=minecraft:item_display,tag=st.dur_new] add $(tag)
scoreboard players operation @e[type=minecraft:item_display,tag=st.dur_new] st.pid = @s st.pid
execute as @e[type=minecraft:item_display,tag=st.dur_new] run function stamina:durability/wreck
tag @e[type=minecraft:item_display,tag=st.dur_new] remove st.dur_new
