# GENERATED. As the item_display holding a copy of an item that just ran out of durability: rebuild it as
# broken. Uses storage stamina:dur a (inert, mat, key) from stamina:durability/break.
#   already broken (shouldn't happen): only make sure the display holds its own copy of the item
execute if items entity @s contents *[minecraft:custom_data~{st_broken:{}}] run return run data modify entity @s item.count set value 1
#   durability 0, set aside everything that makes it work, and switch those off
item modify entity @s contents stamina:durability/empty
data modify storage stamina:dur it set from entity @s item
data modify storage stamina:dur s set value {}
data modify storage stamina:dur s.id set from storage stamina:dur it.id
data modify storage stamina:dur s."minecraft:enchantments" set from storage stamina:dur it.components."minecraft:enchantments"
data remove storage stamina:dur it.components."minecraft:enchantments"
data modify storage stamina:dur s."minecraft:attribute_modifiers" set from storage stamina:dur it.components."minecraft:attribute_modifiers"
data remove storage stamina:dur it.components."minecraft:attribute_modifiers"
data modify storage stamina:dur s."minecraft:tool" set from storage stamina:dur it.components."minecraft:tool"
data remove storage stamina:dur it.components."minecraft:tool"
data modify storage stamina:dur s."minecraft:weapon" set from storage stamina:dur it.components."minecraft:weapon"
data remove storage stamina:dur it.components."minecraft:weapon"
data modify storage stamina:dur s."minecraft:kinetic_weapon" set from storage stamina:dur it.components."minecraft:kinetic_weapon"
data remove storage stamina:dur it.components."minecraft:kinetic_weapon"
data modify storage stamina:dur s."minecraft:piercing_weapon" set from storage stamina:dur it.components."minecraft:piercing_weapon"
data remove storage stamina:dur it.components."minecraft:piercing_weapon"
data modify storage stamina:dur s."minecraft:block_transformer" set from storage stamina:dur it.components."minecraft:block_transformer"
data remove storage stamina:dur it.components."minecraft:block_transformer"
data modify storage stamina:dur s."minecraft:blocks_attacks" set from storage stamina:dur it.components."minecraft:blocks_attacks"
data remove storage stamina:dur it.components."minecraft:blocks_attacks"
data modify storage stamina:dur s."minecraft:equippable" set from storage stamina:dur it.components."minecraft:equippable"
data remove storage stamina:dur it.components."minecraft:equippable"
data modify storage stamina:dur s."minecraft:glider" set from storage stamina:dur it.components."minecraft:glider"
data remove storage stamina:dur it.components."minecraft:glider"
data modify storage stamina:dur s."minecraft:lore" set from storage stamina:dur it.components."minecraft:lore"
data remove storage stamina:dur it.components."minecraft:lore"
data modify storage stamina:dur s."minecraft:item_model" set from storage stamina:dur it.components."minecraft:item_model"
data remove storage stamina:dur it.components."minecraft:item_model"
data modify storage stamina:dur it.components."!minecraft:attribute_modifiers" set value {}
data modify storage stamina:dur it.components."!minecraft:tool" set value {}
data modify storage stamina:dur it.components."!minecraft:weapon" set value {}
data modify storage stamina:dur it.components."!minecraft:kinetic_weapon" set value {}
data modify storage stamina:dur it.components."!minecraft:piercing_weapon" set value {}
data modify storage stamina:dur it.components."!minecraft:block_transformer" set value {}
data modify storage stamina:dur it.components."!minecraft:blocks_attacks" set value {}
data modify storage stamina:dur it.components."!minecraft:equippable" set value {}
data modify storage stamina:dur it.components."!minecraft:glider" set value {}
execute if data storage stamina:dur a{inert:1} run function stamina:durability/inert with storage stamina:dur a
#   cracked look (stamina_resourcepack: assets/stamina/items/broken)
data modify storage stamina:dur it.components."minecraft:item_model" set from storage stamina:dur a.model
data modify storage stamina:dur it.components."minecraft:lore" set value [{text:"Broken",color:"red",italic:false},{text:"Repair it to use it again",color:"gray",italic:false}]
execute if data storage stamina:dur s."minecraft:enchantments" run data modify storage stamina:dur it.components."minecraft:lore" append value {text:"Its enchantments return once repaired",color:"dark_purple",italic:false}
data modify storage stamina:dur it.components."minecraft:custom_data".st_broken set from storage stamina:dur s
data modify entity @s item set from storage stamina:dur it
