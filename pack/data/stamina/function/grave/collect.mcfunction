# As the player who clicked, at the centre of the grave: everything goes back to them. Armor and the
# offhand item go back on, inventory items into the slot they came from; whatever finds its slot taken
# drops at their feet, ready to be picked up. Then the grave is gone.
execute unless entity @e[type=minecraft:marker,tag=st.tomb,distance=..0.1] run return fail
data modify storage stamina:grave work set from entity @e[type=minecraft:marker,tag=st.tomb,distance=..0.1,limit=1] data
#   only its owner may open it (#grave_lock), unless it has stood unclaimed for #grave_unlock minutes
execute if score #grave_lock st.config matches 1 unless function stamina:grave/may_open run return run function stamina:grave/not_yours
summon minecraft:item_display ~ ~ ~ {Tags:["st.grave_helper"]}
execute if data storage stamina:grave work.eq.head run function stamina:grave/put_eq {k:"head",s:"armor.head"}
execute if data storage stamina:grave work.eq.chest run function stamina:grave/put_eq {k:"chest",s:"armor.chest"}
execute if data storage stamina:grave work.eq.legs run function stamina:grave/put_eq {k:"legs",s:"armor.legs"}
execute if data storage stamina:grave work.eq.feet run function stamina:grave/put_eq {k:"feet",s:"armor.feet"}
execute if data storage stamina:grave work.eq.offhand run function stamina:grave/put_eq {k:"offhand",s:"weapon.offhand"}
execute if data storage stamina:grave work.inv[0] run function stamina:grave/put_inv
execute if data storage stamina:grave work.xpl run function stamina:grave/give_xp with storage stamina:grave work
kill @e[type=minecraft:item_display,tag=st.grave_helper]

execute if data storage stamina:grave work.owner run tellraw @s [{"text":"You gather up what ","color":"gray"},{"nbt":"work.owner","storage":"stamina:grave","color":"white"},{"text":" left behind."}]
playsound minecraft:block.rooted_dirt.break block @a ~ ~ ~ 1 0.7
playsound minecraft:item.armor.equip_generic player @s ~ ~ ~ 1 0.8
particle minecraft:soul ~ ~0.6 ~ 0.3 0.4 0.3 0.03 16
particle minecraft:block{block_state:"minecraft:coarse_dirt"} ~ ~0.3 ~ 0.3 0.2 0.3 0 20
function stamina:grave/remove
