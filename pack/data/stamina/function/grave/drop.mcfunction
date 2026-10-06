# The item in storage stamina:grave cur, dropped here as an item entity that can be picked up at once
summon minecraft:item ~ ~0.2 ~ {Tags:["st.grave_drop"],PickupDelay:0s,Item:{id:"minecraft:stone"}}
data remove storage stamina:grave cur.Slot
data modify entity @e[type=minecraft:item,tag=st.grave_drop,limit=1] Item set from storage stamina:grave cur
tag @e[type=minecraft:item,tag=st.grave_drop] remove st.grave_drop
