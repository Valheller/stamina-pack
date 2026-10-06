# GENERATED. As the item_display holding a broken item that has been repaired: make it whole again.
data modify storage stamina:dur it set from entity @s item
data modify storage stamina:dur s set from storage stamina:dur it.components."minecraft:custom_data".st_broken
data remove storage stamina:dur it.components."minecraft:custom_data".st_broken
execute store result score #n st.tmp run data get storage stamina:dur it.components."minecraft:custom_data"
execute if score #n st.tmp matches 0 run data remove storage stamina:dur it.components."minecraft:custom_data"
execute if data storage stamina:dur s.inert run function stamina:durability/uninert
data remove storage stamina:dur it.components."!minecraft:attribute_modifiers"
data remove storage stamina:dur it.components."!minecraft:tool"
data remove storage stamina:dur it.components."!minecraft:weapon"
data remove storage stamina:dur it.components."!minecraft:kinetic_weapon"
data remove storage stamina:dur it.components."!minecraft:piercing_weapon"
data remove storage stamina:dur it.components."!minecraft:block_transformer"
data remove storage stamina:dur it.components."!minecraft:blocks_attacks"
data remove storage stamina:dur it.components."!minecraft:equippable"
data remove storage stamina:dur it.components."!minecraft:glider"
data remove storage stamina:dur it.components."minecraft:attribute_modifiers"
data modify storage stamina:dur it.components."minecraft:attribute_modifiers" set from storage stamina:dur s."minecraft:attribute_modifiers"
data remove storage stamina:dur it.components."minecraft:tool"
data modify storage stamina:dur it.components."minecraft:tool" set from storage stamina:dur s."minecraft:tool"
data remove storage stamina:dur it.components."minecraft:weapon"
data modify storage stamina:dur it.components."minecraft:weapon" set from storage stamina:dur s."minecraft:weapon"
data remove storage stamina:dur it.components."minecraft:kinetic_weapon"
data modify storage stamina:dur it.components."minecraft:kinetic_weapon" set from storage stamina:dur s."minecraft:kinetic_weapon"
data remove storage stamina:dur it.components."minecraft:piercing_weapon"
data modify storage stamina:dur it.components."minecraft:piercing_weapon" set from storage stamina:dur s."minecraft:piercing_weapon"
data remove storage stamina:dur it.components."minecraft:block_transformer"
data modify storage stamina:dur it.components."minecraft:block_transformer" set from storage stamina:dur s."minecraft:block_transformer"
data remove storage stamina:dur it.components."minecraft:blocks_attacks"
data modify storage stamina:dur it.components."minecraft:blocks_attacks" set from storage stamina:dur s."minecraft:blocks_attacks"
data remove storage stamina:dur it.components."minecraft:equippable"
data modify storage stamina:dur it.components."minecraft:equippable" set from storage stamina:dur s."minecraft:equippable"
data remove storage stamina:dur it.components."minecraft:glider"
data modify storage stamina:dur it.components."minecraft:glider" set from storage stamina:dur s."minecraft:glider"
data remove storage stamina:dur it.components."minecraft:lore"
data modify storage stamina:dur it.components."minecraft:lore" set from storage stamina:dur s."minecraft:lore"
data remove storage stamina:dur it.components."minecraft:item_model"
data modify storage stamina:dur it.components."minecraft:item_model" set from storage stamina:dur s."minecraft:item_model"
#   merged, in case it was enchanted while broken
execute if data storage stamina:dur s."minecraft:enchantments" unless data storage stamina:dur it.components."minecraft:enchantments" run data modify storage stamina:dur it.components."minecraft:enchantments" set value {}
data modify storage stamina:dur it.components."minecraft:enchantments" merge from storage stamina:dur s."minecraft:enchantments"
data modify entity @s item set from storage stamina:dur it
