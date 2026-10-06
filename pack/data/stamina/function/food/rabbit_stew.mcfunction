# Rabbit Stew: +10 HP, +40% stamina
scoreboard players set @s st.eat.rabbit_stew 0
scoreboard players add @s st.heal 10
scoreboard players add @s stamina 400
function stamina:food/eaten
