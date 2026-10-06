# Pins the vanilla food level so it never matters:
#   - below 18, so vanilla natural regeneration never triggers (food is the only way to heal)
#   - above 6 normally, so sprinting works; exactly 6 while exhausted, so vanilla blocks sprinting
#   - never full, so every food can always be eaten
# Hunger (amp 199) burns off excess food quickly; Saturation (1 tick) tops it back up.
scoreboard players operation @s st.ftarget = #food_normal st.config
execute if entity @s[tag=st.exhausted] run scoreboard players operation @s st.ftarget = #food_exhausted st.config
execute if score @s st.food > @s st.ftarget run effect give @s hunger 1 199 true
execute if score @s st.food <= @s st.ftarget run effect clear @s hunger
execute if score @s st.food < @s st.ftarget run effect give @s saturation 1 0 true
execute if score @s st.food >= @s st.ftarget run effect clear @s saturation
