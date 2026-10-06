# As an item_display holding an item that broke last tick, at the start of this tick: give it back to its
# owner (back into the hand it was in if that's still empty, otherwise at their feet). Runs before graves,
# so if the owner has just died it's dropped here with their other items and goes into the grave.
tag @s add st.dur_this
scoreboard players operation #pid st.tmp = @s st.pid
scoreboard players set #placed st.tmp 0
execute as @a if score @s st.pid = #pid st.tmp unless score @s st.deaths matches 1.. at @s run function stamina:durability/return
execute if score #placed st.tmp matches 0 run function stamina:durability/drop
kill @s
