# As a player, every tick (stamina:player/display, stamina:player/idle). The HUD is a title sent to them, so
# it's only sent when it would look different - stamina moved a step, exhaustion started or ended - or every
# 10 ticks for the timers and the clock (an action bar stays up for 3 seconds, so it never fades). With many
# players this keeps it to about two packets a second each, not twenty.
scoreboard players add @s st.hudt 1
execute unless score @s st.seg = @s st.lseg run scoreboard players set @s st.hudt 10
scoreboard players set #exh st.tmp 0
execute if entity @s[tag=st.exhausted] run scoreboard players set #exh st.tmp 1
execute unless score @s st.lexh = #exh st.tmp run scoreboard players set @s st.hudt 10
execute unless score @s st.hudt matches 10.. run return 0
scoreboard players set @s st.hudt 0
scoreboard players operation @s st.lseg = @s st.seg
scoreboard players operation @s st.lexh = #exh st.tmp
function stamina:player/hud/draw
