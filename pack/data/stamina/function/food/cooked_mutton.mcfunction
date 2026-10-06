# Cooked Mutton: +6 HP, +25% stamina
scoreboard players set @s st.eat.cooked_mutton 0
scoreboard players add @s st.heal 6
scoreboard players add @s stamina 250
function stamina:food/eaten
