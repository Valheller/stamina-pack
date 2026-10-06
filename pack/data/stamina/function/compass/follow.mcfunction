# As/at a player holding a compass (stamina:compass/check), every tick. The locator bar works as a compass: four
# invisible armor stands follow 24 blocks north, east, south and west of each player, transmitting
# waypoints styled as N, E, S and W (resource pack). Their range is 28 blocks (24 plus slack for fast flight), so only players near them
# see them. Other players and graves show on the same bar.
execute unless score @s st.pid matches 1.. store result score @s st.pid run scoreboard players add #pid st.pid 1
scoreboard players operation #me st.tmp = @s st.pid
execute as @e[type=minecraft:armor_stand,tag=st.card] if score @s st.pid = #me st.tmp run tag @s add st.card_mine
execute unless entity @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_n] run function stamina:compass/make {d:"n",s:"north",c:"FF5555"}
execute unless entity @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_e] run function stamina:compass/make {d:"e",s:"east",c:"FFFFFF"}
execute unless entity @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_s] run function stamina:compass/make {d:"s",s:"south",c:"FFFFFF"}
execute unless entity @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_w] run function stamina:compass/make {d:"w",s:"west",c:"FFFFFF"}
tp @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_n] ~ ~ ~-24
tp @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_e] ~24 ~ ~
tp @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_s] ~ ~ ~24
tp @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_w] ~-24 ~ ~
#   once a second, their looks restated and spare copies cleared (stamina:compass/refresh)
execute if score #card_tick st.tmp matches 0 run function stamina:compass/refresh
tag @e[type=minecraft:armor_stand,tag=st.card_mine] add st.card_keep
tag @e[type=minecraft:armor_stand,tag=st.card_mine] remove st.card_mine