# Stamina just hit 0: no sprinting (the hunger lock pins food to 6), and slowed until it recovers to #recover
tag @s add st.exhausted
scoreboard players set @s stamina 0
effect give @s slowness 1 0 true
playsound minecraft:entity.horse.breathe player @s ~ ~ ~ 1 0.6
