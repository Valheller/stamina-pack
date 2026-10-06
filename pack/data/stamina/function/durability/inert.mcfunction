# GENERATED. Macro (mat, key). The broken form of an item whose use is hard-coded: an inert poisonous potato
# that looks and is named like the original, still shows its durability, and repairs in an anvil with $(mat).
data modify storage stamina:dur s."minecraft:item_name" set from storage stamina:dur it.components."minecraft:item_name"
data remove storage stamina:dur it.components."minecraft:item_name"
data modify storage stamina:dur s."minecraft:max_damage" set from storage stamina:dur it.components."minecraft:max_damage"
data remove storage stamina:dur it.components."minecraft:max_damage"
data modify storage stamina:dur s."minecraft:max_stack_size" set from storage stamina:dur it.components."minecraft:max_stack_size"
data remove storage stamina:dur it.components."minecraft:max_stack_size"
data modify storage stamina:dur s."minecraft:repairable" set from storage stamina:dur it.components."minecraft:repairable"
data remove storage stamina:dur it.components."minecraft:repairable"
data modify storage stamina:dur s.inert set value 1b
data modify storage stamina:dur it.id set value "minecraft:poisonous_potato"
data modify storage stamina:dur it.components."minecraft:max_damage" set from storage stamina:dur it.components."minecraft:damage"
data modify storage stamina:dur it.components."minecraft:max_stack_size" set value 1
$data modify storage stamina:dur it.components."minecraft:item_name" set value {translate:"$(key)"}
$data modify storage stamina:dur it.components."minecraft:repairable" set value {items:"$(mat)"}
data modify storage stamina:dur it.components."!minecraft:food" set value {}
data modify storage stamina:dur it.components."!minecraft:consumable" set value {}
data modify storage stamina:dur it.components."!minecraft:compostable" set value {}
