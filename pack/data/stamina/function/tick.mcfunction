# Runs every tick

# Durability: hand back items that broke last tick (before graves, so a dying player's go in the grave), and
# make repaired broken items whole again (stamina:durability/*)
execute as @e[type=minecraft:item_display,tag=st.dur] at @s run function stamina:durability/place
execute as @a if items entity @s container.* *[minecraft:custom_data~{st_broken:{}},minecraft:damage~{durability:{min:1}}] at @s run function stamina:durability/repaired
execute as @a if items entity @s weapon.offhand *[minecraft:custom_data~{st_broken:{}},minecraft:damage~{durability:{min:1}}] at @s run function stamina:durability/repaired

# Graves: must run before player/tick, which resets the death counter
execute if score #graves st.config matches 1 as @a[scores={st.deaths=1..}] at @s run function stamina:grave/make

# Food: healing already under way goes on (before new food, so a heal starts and counts in the same tick),
# then food eaten since last tick heals and restores stamina
execute as @a[tag=st.healing] run function stamina:food/heal_tick
execute as @a[gamemode=!spectator] at @s run function stamina:food/check

execute as @a[gamemode=!creative,gamemode=!spectator] at @s run function stamina:player/tick
execute as @a[gamemode=creative] run function stamina:player/idle
execute as @a[gamemode=spectator] run function stamina:player/idle

# Compass: holding one shows the locator bar, with N/E/S/W markers that follow you (stamina:compass/*);
# markers nobody refreshed go
scoreboard players add #card_tick st.tmp 1
execute if score #card_tick st.tmp matches 20.. run scoreboard players set #card_tick st.tmp 0
execute as @a at @s run function stamina:compass/check
kill @e[type=minecraft:armor_stand,tag=st.card,tag=!st.card_keep]
tag @e[type=minecraft:armor_stand,tag=st.card_keep] remove st.card_keep
# Recovery compasses: mob radar, every 5 ticks (stamina:compass/radar)
scoreboard players add #radar_tick st.tmp 1
execute if score #radar_tick st.tmp matches 5.. run function stamina:compass/radar
# Grave markers (tombstones) get their look restated once a second
execute if score #card_tick st.tmp matches 0 as @e[type=minecraft:armor_stand,tag=st.grave_wp] run waypoint modify @s style set stamina:grave
#   graves from before the gravestone model get it
execute if score #card_tick st.tmp matches 0 as @e[type=minecraft:marker,tag=st.tomb,tag=!st.tomb_v2] at @s run function stamina:grave/upgrade
