# As a player who just ate (stamina:food/<id>, generated): the stamina they got stays within the bar, and the
# healing they got (st.heal) starts unless it's already under way (stamina:food/heal_tick)
execute if score @s stamina > #max st.config run scoreboard players operation @s stamina = #max st.config
execute if score @s st.heal matches 1.. unless entity @s[tag=st.healing] run function stamina:food/heal_start
particle minecraft:heart ~ ~2.1 ~ 0.3 0.1 0.3 0 2
