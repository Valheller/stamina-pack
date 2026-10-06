# Dried Kelp: +1 HP, +5% stamina
scoreboard players set @s st.eat.dried_kelp 0
scoreboard players add @s st.heal 1
scoreboard players add @s stamina 50
function stamina:food/eaten
