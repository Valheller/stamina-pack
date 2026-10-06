# Run before removing the datapack: /function stamina:uninstall
# Graves give up their belongings where they stand, compass markers go, and everything the pack changed on
# players is put back. Then disable the pack: /datapack disable "file/stamina_pack.zip"
execute as @e[type=minecraft:marker,tag=st.tomb] at @s run function stamina:grave/spill_here
kill @e[type=minecraft:armor_stand,tag=st.grave_wp]
kill @e[type=minecraft:armor_stand,tag=st.card]
execute as @e[tag=st.radar] run function stamina:compass/radar_off
execute as @a run attribute @s minecraft:waypoint_receive_range modifier remove stamina:no_compass
effect clear @a[tag=st.healing] minecraft:regeneration
effect clear @a minecraft:hunger
effect clear @a minecraft:saturation
tag @a remove st.healing
tag @a remove st.exhausted
execute if data storage stamina:flags {keep_inv:1b} run gamerule minecraft:keep_inventory false
data remove storage stamina:flags keep_inv
title @a actionbar ""
function stamina:food/teardown
scoreboard objectives remove stamina
scoreboard objectives remove st.config
scoreboard objectives remove st.const
scoreboard objectives remove st.tmp
scoreboard objectives remove st.drain
scoreboard objectives remove st.delay
scoreboard objectives remove st.regen
scoreboard objectives remove st.show
scoreboard objectives remove st.pct
scoreboard objectives remove st.seg
scoreboard objectives remove st.ftarget
scoreboard objectives remove st.heal
scoreboard objectives remove st.pid
scoreboard objectives remove st.hudt
scoreboard objectives remove st.lseg
scoreboard objectives remove st.lexh
scoreboard objectives remove st.food
scoreboard objectives remove st.jumps
scoreboard objectives remove st.deaths
data remove storage stamina:hud rows
data remove storage stamina:hud icons
tellraw @a [{"text":"[Stamina] ","color":"gold"},{"text":"Uninstalled. Now run: /datapack disable \"file/stamina_pack.zip\"","color":"gray"}]
