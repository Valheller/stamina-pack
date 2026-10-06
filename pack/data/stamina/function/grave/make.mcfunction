# As the dead player, at the body, the tick after death. While graves are on, keep_inventory is on too
# (stamina:load), so everything they carried is still on them, in its slot. Their gear stays with them: worn
# armor, and tools, weapons and anything else with durability, plus compasses, clocks and spyglasses
# (stamina:grave/keep). Everything else goes into a grave: a headstone that holds the items
# (stamina:grave/build). Touching the grave gives them back, each into the slot it came from where that's free
# (stamina:grave/collect). Curse of Vanishing items are destroyed, kept or not.
data remove storage stamina:grave new
data modify storage stamina:grave new.inv set from entity @s Inventory
data modify storage stamina:grave new.eq set from entity @s equipment
data remove storage stamina:grave new.eq.body
data remove storage stamina:grave new.eq.saddle
data remove storage stamina:grave new.inv[{components:{"minecraft:enchantments":{"minecraft:vanishing_curse":1}}}]
data remove storage stamina:grave new.eq.offhand{components:{"minecraft:enchantments":{"minecraft:vanishing_curse":1}}}
clear @s *[minecraft:enchantments~[{enchantments:"minecraft:vanishing_curse"}]]
#   worn armor stays on
data remove storage stamina:grave new.eq.head
data remove storage stamina:grave new.eq.chest
data remove storage stamina:grave new.eq.legs
data remove storage stamina:grave new.eq.feet
#   gear stays in its slot; everything else leaves the player for the grave
function stamina:grave/keep
#   experience goes in the grave too (keep_inventory would otherwise leave it all on the player)
execute store result storage stamina:grave new.xpl int 1 run xp query @s levels
execute store result storage stamina:grave new.xpp int 1 run xp query @s points
xp set @s 0 points
xp set @s 0 levels
execute store result score #n st.tmp run data get storage stamina:grave new.inv
execute store result score #e st.tmp run data get storage stamina:grave new.eq
scoreboard players operation #n st.tmp += #e st.tmp
execute store result score #e st.tmp run data get storage stamina:grave new.xpl
scoreboard players operation #n st.tmp += #e st.tmp
execute store result score #e st.tmp run data get storage stamina:grave new.xpp
scoreboard players operation #n st.tmp += #e st.tmp
execute if score #n st.tmp matches 0 run return 0

# Settle onto the ground below the body, then find a free block for the grave (climbing out of walls or
# the void). If none is found the belongings are dropped where the body is, as vanilla would.
scoreboard players set #fall st.tmp 0
scoreboard players set #climb st.tmp 0
scoreboard players set #steps st.tmp 0
scoreboard players set #placed st.tmp 0
execute store result score #placed st.tmp align xyz run function stamina:grave/find_ground
execute if score #placed st.tmp matches 1 run return 1
data modify storage stamina:grave work set from storage stamina:grave new
#   (the experience stays with the player)
function stamina:grave/give_xp with storage stamina:grave new
function stamina:grave/spill
