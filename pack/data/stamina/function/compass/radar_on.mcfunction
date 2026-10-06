# A mob near a radar holder starts sending a waypoint (range 48, so it stays on the bar up to the 32 blocks it's
# tracked at), marked by kind: hostile = red skull, friendly (villagers, golems, allays, and any tamed animal) =
# aqua heart, other animals = green diamond
tag @s add st.radar
attribute @s minecraft:waypoint_transmit_range base set 48
execute if entity @s[type=#stamina:hostile] run return run function stamina:compass/radar_style {s:"hostile",c:"FF5555"}
execute if entity @s[type=#stamina:friendly] run return run function stamina:compass/radar_style {s:"friendly",c:"55FFFF"}
execute if data entity @s Owner run return run function stamina:compass/radar_style {s:"friendly",c:"55FFFF"}
function stamina:compass/radar_style {s:"passive",c:"55FF55"}
