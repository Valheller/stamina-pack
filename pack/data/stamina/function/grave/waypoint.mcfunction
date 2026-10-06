# At a new grave: a waypoint (a tombstone) on the locator bar of anyone holding a compass, and the chunk kept loaded so the
# waypoint stays on the bar from any distance until the grave is emptied (stamina:grave/clear)
summon minecraft:armor_stand ~0.5 ~1 ~0.5 {Tags:["st.grave_wp","st.grave_wp_new"],Invisible:1b,Marker:1b,NoGravity:1b,Invulnerable:1b,Silent:1b,attributes:[{id:"minecraft:waypoint_transmit_range",base:60000000d}]}
waypoint modify @e[type=minecraft:armor_stand,tag=st.grave_wp_new,limit=1] style set stamina:grave
waypoint modify @e[type=minecraft:armor_stand,tag=st.grave_wp_new,limit=1] color hex D8D8D8
tag @e[type=minecraft:armor_stand,tag=st.grave_wp_new] remove st.grave_wp_new
forceload add ~ ~