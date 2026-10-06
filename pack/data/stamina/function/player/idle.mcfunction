# Creative/spectator: keep stats from piling up and keep stamina full. The effect timers (and clock) still
# show, refreshed every 10 ticks like the survival HUD (stamina:player/hud/send).
scoreboard players set @s st.jumps 0
scoreboard players set @s st.deaths 0
scoreboard players operation @s stamina = #max st.config
tag @s remove st.exhausted
execute if score #hud_mode st.config matches 0 run return 0
scoreboard players add @s st.hudt 1
execute unless score @s st.hudt matches 10.. run return 0
scoreboard players set @s st.hudt 0
scoreboard players reset @s st.lseg
function stamina:player/fx/build
execute if data storage stamina:hud rows[0] run function stamina:player/hud/mounted
