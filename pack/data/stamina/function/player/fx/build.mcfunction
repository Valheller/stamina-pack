# Builds storage stamina:hud rows = one text component per active effect (icon + time left),
# which the HUD title appends after the stamina bar. Up to 6 rows, stacked up from the hotbar's right side.
data modify storage stamina:hud rows set value []
execute if items entity @s weapon.* minecraft:clock run function stamina:player/clock
data remove storage stamina:fx list
data modify storage stamina:fx list set from entity @s active_effects
scoreboard players set #row st.tmp 0
execute if data storage stamina:fx list[0] run function stamina:player/fx/next
