# Cooked Rabbit: +5 HP, +25% stamina
scoreboard players set @s st.eat.cooked_rabbit 0
scoreboard players add @s st.heal 5
scoreboard players add @s stamina 250
function stamina:food/eaten
