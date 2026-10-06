# Per-player stamina logic (survival/adventure). Context: as/at player

execute unless score @s stamina matches -2147483648.. run function stamina:player/init
execute if score @s st.deaths matches 1.. run function stamina:player/respawn

# --- Drain: sprinting and jumping (nothing else costs stamina) ---
scoreboard players set @s st.drain 0
execute if predicate stamina:sprinting run scoreboard players operation @s st.drain += #sprint_cost st.config
execute if score @s st.jumps matches 1.. run function stamina:player/drain_jumps
scoreboard players operation @s stamina -= @s st.drain

# --- Regen (only after #regen_delay ticks without drain) ---
execute if score @s st.drain matches 1.. run scoreboard players operation @s st.delay = #regen_delay st.config
execute if score @s st.drain matches 0 if score @s st.delay matches 1.. run scoreboard players remove @s st.delay 1
execute if score @s st.drain matches 0 if score @s st.delay matches ..0 run function stamina:player/regen

# --- Clamp ---
execute if score @s stamina matches ..-1 run scoreboard players set @s stamina 0
execute if score @s stamina > #max st.config run scoreboard players operation @s stamina = #max st.config

# --- Exhaustion ---
execute if score @s stamina matches ..0 unless entity @s[tag=st.exhausted] run function stamina:player/exhaust
execute if entity @s[tag=st.exhausted] if score @s stamina >= #recover st.config run function stamina:player/recover
execute if entity @s[tag=st.exhausted] run effect give @s slowness 1 0 true

function stamina:player/hunger_lock
function stamina:player/display
