# Cooked Porkchop: +8 HP, +30% stamina
scoreboard players set @s st.eat.cooked_porkchop 0
scoreboard players add @s st.heal 8
scoreboard players add @s stamina 300
function stamina:food/eaten
