# As/at each player, every tick. The locator bar only works while a compass (or recovery compass) is held in
# either hand: then the player receives waypoints (other players, graves, and their own N/E/S/W markers from
# stamina:compass/follow); otherwise a modifier takes their waypoint receive range to 0, so the bar goes and the
# experience bar shows instead. The modifier is only changed when holding starts or stops (judged by the
# range itself, so it's right again after a respawn).
scoreboard players set #cmp st.tmp 0
execute if items entity @s weapon.* #stamina:compasses run scoreboard players set #cmp st.tmp 1
execute store result score #rr st.tmp run attribute @s minecraft:waypoint_receive_range get
execute if score #cmp st.tmp matches 1 if score #rr st.tmp matches 0 run attribute @s minecraft:waypoint_receive_range modifier remove stamina:no_compass
execute if score #cmp st.tmp matches 0 unless score #rr st.tmp matches 0 run function stamina:compass/off
execute if score #cmp st.tmp matches 1 run function stamina:compass/follow
