# Effect timer rows (appended to the HUD title via storage stamina:hud rows)
function stamina:player/fx/build

# Riding something with health (a horse...): vanilla draws its hearts where the stamina icons go, so the icons
# are left out while mounted (the effect timer rows still show)
#   (reset first: with no vehicle the check below doesn't run at all, and the last value would stick)
scoreboard players set #mtd st.tmp 0
execute store success score #mtd st.tmp on vehicle if data entity @s Health
execute if score #mtd st.tmp matches 1 run return run function stamina:player/hud/mounted

# Icon tint: red while exhausted, gold otherwise
execute if entity @s[tag=st.exhausted] run return run function stamina:player/hud/exhausted
function stamina:player/hud/normal
