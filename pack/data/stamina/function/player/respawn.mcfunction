# Player died: start fresh
scoreboard players set @s st.deaths 0
scoreboard players operation @s stamina = #max st.config
scoreboard players set @s st.delay 0
scoreboard players set @s st.jumps 0
scoreboard players reset @s st.heal
tag @s remove st.healing
tag @s remove st.exhausted
