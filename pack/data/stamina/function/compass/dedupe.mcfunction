# Macro (d). As the first of a player's markers for one direction: it stays; any others for that direction go
tag @s add st.card_first
$kill @e[type=minecraft:armor_stand,tag=st.card_mine,tag=st.card_$(d),tag=!st.card_first]
