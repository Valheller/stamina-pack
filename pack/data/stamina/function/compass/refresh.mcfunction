# As/at a player, once a second (stamina:compass/follow): their four markers get their look again, and any spare
# copies (left in a chunk that unloaded and came back) are removed. A marker sometimes showed up as a plain dot
# in a random colour (the game's default look) instead of its letter; restating the style and colour every
# second sends it to the client again and puts that right within a second.
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_n] at @s unless entity @s[tag=st.card_first] run function stamina:compass/dedupe {d:"n"}
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_e] at @s unless entity @s[tag=st.card_first] run function stamina:compass/dedupe {d:"e"}
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_s] at @s unless entity @s[tag=st.card_first] run function stamina:compass/dedupe {d:"s"}
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_w] at @s unless entity @s[tag=st.card_first] run function stamina:compass/dedupe {d:"w"}
tag @e[type=minecraft:armor_stand,tag=st.card_first] remove st.card_first
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_n] run waypoint modify @s style set stamina:north
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_e] run waypoint modify @s style set stamina:east
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_s] run waypoint modify @s style set stamina:south
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_w] run waypoint modify @s style set stamina:west
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_n] run waypoint modify @s color hex FF5555
execute as @e[type=minecraft:armor_stand,tag=st.card_mine,tag=!st.card_n] run waypoint modify @s color hex FFFFFF
