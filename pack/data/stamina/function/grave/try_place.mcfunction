# A grave fits in a replaceable block (air, water, lava, grass, snow...) inside the world that doesn't
# already hold a grave. Plants and fire there are cleared away.
execute if block ~ ~ ~ minecraft:void_air run return fail
execute unless block ~ ~ ~ #minecraft:replaceable run return fail
execute positioned ~0.5 ~ ~0.5 if entity @e[type=minecraft:marker,tag=st.tomb,distance=..0.5] run return fail
execute if block ~ ~ ~ #stamina:grave_fall unless block ~ ~ ~ #minecraft:air run setblock ~ ~ ~ minecraft:air
return 1
