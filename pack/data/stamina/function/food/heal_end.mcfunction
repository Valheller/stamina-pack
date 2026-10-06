# Healing done: the burst of Regeneration comes off, and any Regeneration it covered (kept as its hidden
# effect) goes back on for the time it had left
scoreboard players reset @s st.heal
tag @s remove st.healing
data remove storage stamina:heal hid
data modify storage stamina:heal hid set from entity @s active_effects[{id:"minecraft:regeneration",amplifier:9b}].hidden_effect
effect clear @s minecraft:regeneration
execute if data storage stamina:heal hid run function stamina:food/heal_restore
