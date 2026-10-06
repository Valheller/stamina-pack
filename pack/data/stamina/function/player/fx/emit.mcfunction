# Append one row. Needs #dur st.tmp (ticks left, -1 = infinite) and args.icon / args.icolor.
# args.color may be preset by the caller; otherwise white, turning red in the last 10 seconds.
# There are only 6 row fonts (stamina:fx0..fx5): any further rows are dropped.
execute if score #row st.tmp matches 6.. run return 0

# Time left as mm:ss; infinite or 100+ minutes shows --:--
execute unless data storage stamina:fx args.color run function stamina:player/fx/default_color
execute if score #dur st.tmp matches -1 run function stamina:player/fx/time_long
execute if score #dur st.tmp matches 119981.. run function stamina:player/fx/time_long
execute unless data storage stamina:fx args.m2 run function stamina:player/fx/time

execute store result storage stamina:fx args.row int 1 run scoreboard players get #row st.tmp
function stamina:player/fx/row with storage stamina:fx args
scoreboard players add #row st.tmp 1
