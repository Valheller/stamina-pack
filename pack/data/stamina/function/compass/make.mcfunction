# Macro (d = n/e/s/w, s = waypoint style, c = colour): one compass marker for this player
$summon minecraft:armor_stand ~ ~ ~ {Tags:["st.card","st.card_$(d)","st.card_new"],Invisible:1b,Marker:1b,NoGravity:1b,Invulnerable:1b,Silent:1b,attributes:[{id:"minecraft:waypoint_transmit_range",base:28d}]}
$waypoint modify @e[type=minecraft:armor_stand,tag=st.card_new,limit=1] style set stamina:$(s)
$waypoint modify @e[type=minecraft:armor_stand,tag=st.card_new,limit=1] color hex $(c)
scoreboard players operation @e[type=minecraft:armor_stand,tag=st.card_new] st.pid = #me st.tmp
tag @e[type=minecraft:armor_stand,tag=st.card_new] add st.card_mine
tag @e[type=minecraft:armor_stand,tag=st.card_new] remove st.card_new