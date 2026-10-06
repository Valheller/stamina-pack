# As a player who clicked someone else's locked grave (the HUD holds off for 2 seconds so it can be read)
title @s actionbar [{"text":"This grave belongs to ","color":"gray"},{"nbt":"work.owner","storage":"stamina:grave","color":"white"}]
playsound minecraft:block.stone.hit block @s ~ ~ ~ 1 0.6
scoreboard players set @s st.hudt -30
