# As the owner of the broken item on @e[tag=st.dur_this]
execute if entity @e[type=minecraft:item_display,tag=st.dur_this,tag=st.dur_mainhand] unless items entity @s weapon.mainhand * store success score #placed st.tmp run item replace entity @s weapon.mainhand from entity @e[type=minecraft:item_display,tag=st.dur_this,limit=1] contents
execute if entity @e[type=minecraft:item_display,tag=st.dur_this,tag=st.dur_offhand] unless items entity @s weapon.offhand * store success score #placed st.tmp run item replace entity @s weapon.offhand from entity @e[type=minecraft:item_display,tag=st.dur_this,limit=1] contents
execute if score #placed st.tmp matches 0 run function stamina:durability/drop
scoreboard players set #placed st.tmp 1
