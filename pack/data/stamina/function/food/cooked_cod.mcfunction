# Cooked Cod: +5 HP, +20% stamina
scoreboard players set @s st.eat.cooked_cod 0
scoreboard players add @s st.heal 5
scoreboard players add @s stamina 200
function stamina:food/eaten
