# Stamina display.
#   #hud_mode 1: icons drawn where the hunger bar was (needs the resource pack), always visible, with the
#                effect timers beside the hotbar
#   #hud_mode 0: text meter on the action bar, shown only while not full

# seg = stamina * 20 / max  (0..20 half-icons / meter segments)
scoreboard players operation @s st.seg = @s stamina
scoreboard players operation @s st.seg *= #20 st.const
scoreboard players operation @s st.seg /= #max st.config

execute if score #hud_mode st.config matches 1 run return run function stamina:player/hud/send

# --- Text meter: shown while not full, then lingers 2 s ---
execute if score @s stamina < #max st.config run scoreboard players set @s st.show 40
execute if entity @s[tag=st.exhausted] run scoreboard players set @s st.show 40
execute unless score @s st.show matches 1.. run return 0
scoreboard players remove @s st.show 1

# pct = stamina * 100 / max
scoreboard players operation @s st.pct = @s stamina
scoreboard players operation @s st.pct *= #100 st.const
scoreboard players operation @s st.pct /= #max st.config

execute if entity @s[tag=st.exhausted] run function stamina:player/display_exhausted
execute unless entity @s[tag=st.exhausted] run function stamina:player/display_bar
