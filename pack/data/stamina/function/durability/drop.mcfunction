# Drop the broken item on @e[tag=st.dur_this] here, ready to be picked straight back up
summon minecraft:item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:0,Tags:["st.dur_drop"]}
data modify entity @e[type=minecraft:item,tag=st.dur_drop,limit=1] Item set from entity @e[type=minecraft:item_display,tag=st.dur_this,limit=1] item
tag @e[type=minecraft:item,tag=st.dur_drop] remove st.dur_drop
