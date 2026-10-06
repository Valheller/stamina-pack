# As the dead player, at the corner of the grave's block. The grave is made of entities centred in it, all
# tagged st.tomb_part:
#   a marker (st.tomb) holding the belongings in its data (inv: inventory slots, eq: armor and offhand),
#   an interaction box (st.grave_hit) to click (stamina:grave/touch),
#   the gravestone (an item display with the stamina:grave model: headstone, carved cross and mound, on the
#   block pixel grid), and their name under the cross.
# It faces the way the player was facing. Nothing is solid, so nothing can break it.
execute positioned ~0.5 ~ ~0.5 run summon minecraft:marker ~ ~ ~ {Tags:["st.tomb","st.tomb_v2","st.tomb_part","st.tomb_new"]}
execute positioned ~0.5 ~ ~0.5 run summon minecraft:interaction ~ ~ ~ {Tags:["st.grave_hit","st.tomb_part","st.tomb_new"],width:0.8f,height:1.0f,response:1b}
execute positioned ~0.5 ~ ~0.5 run function stamina:grave/stone
data modify entity @e[type=minecraft:marker,tag=st.tomb_new,limit=1] data set from storage stamina:grave new

# Their name, from a player head made for them
execute positioned ~0.5 ~ ~0.5 run summon minecraft:item_display ~ ~ ~ {Tags:["st.tomb_head"]}
loot replace entity @e[type=minecraft:item_display,tag=st.tomb_head,limit=1] contents loot stamina:grave/own_head
data remove storage stamina:grave name
data modify storage stamina:grave name.n set from entity @e[type=minecraft:item_display,tag=st.tomb_head,limit=1] item.components."minecraft:profile".name
kill @e[type=minecraft:item_display,tag=st.tomb_head]
execute if data storage stamina:grave name.n run function stamina:grave/name with storage stamina:grave name
data modify entity @e[type=minecraft:marker,tag=st.tomb_new,limit=1] data.owner set from storage stamina:grave name.n
#   whose it is and when it was dug (owner-only graves: stamina:grave/collect)
data modify entity @e[type=minecraft:marker,tag=st.tomb_new,limit=1] data.uuid set from entity @s UUID
execute store result entity @e[type=minecraft:marker,tag=st.tomb_new,limit=1] data.t long 1 run time query gametime

# Facing: the player's yaw, to the nearest quarter turn
execute store result score #yaw st.tmp run data get entity @s Rotation[0]
scoreboard players add #yaw st.tmp 405
scoreboard players operation #yaw st.tmp /= #90 st.const
scoreboard players operation #yaw st.tmp %= #4 st.const
scoreboard players operation #yaw st.tmp *= #90 st.const
execute as @e[tag=st.tomb_new] store result entity @s Rotation[0] float 1 run scoreboard players get #yaw st.tmp
tag @e[tag=st.tomb_new] remove st.tomb_new

function stamina:grave/waypoint

execute store result storage stamina:grave pos.x int 1 run data get entity @e[type=minecraft:marker,tag=st.tomb,limit=1,sort=nearest] Pos[0]
execute store result storage stamina:grave pos.y int 1 run data get entity @e[type=minecraft:marker,tag=st.tomb,limit=1,sort=nearest] Pos[1]
execute store result storage stamina:grave pos.z int 1 run data get entity @e[type=minecraft:marker,tag=st.tomb,limit=1,sort=nearest] Pos[2]
tellraw @s [{"text":"Your belongings were laid to rest in a grave at ","color":"gray"},{"nbt":"pos.x","storage":"stamina:grave","color":"white"},{"text":" "},{"nbt":"pos.y","storage":"stamina:grave","color":"white"},{"text":" "},{"nbt":"pos.z","storage":"stamina:grave","color":"white"},{"text":". Hold a compass to see it on your locator bar."}]
playsound minecraft:block.rooted_dirt.place block @a ~ ~ ~ 1 0.6
particle minecraft:soul ~0.5 ~1 ~0.5 0.3 0.3 0.3 0.02 12
return 1
