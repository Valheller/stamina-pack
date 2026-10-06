# Every 5 ticks (stamina:tick). Recovery compass = mob radar: while someone holds one in either hand, every mob
# within 32 blocks of them (#stamina:radar: hostile, passive and friendly mobs; fish, squid, tadpoles and bats
# are left out) sends a waypoint to the locator bar, marked by kind (stamina:compass/radar_on). Mobs nobody is
# near any more stop sending.
# (Waypoints can't be shown to one player only: a player holding a plain compass right beside a radar holder
# sees the same pings.)
scoreboard players set #radar_tick st.tmp 0
execute as @a[gamemode=!spectator] if items entity @s weapon.* minecraft:recovery_compass at @s run tag @e[type=#stamina:radar,distance=..32] add st.radar_keep
execute as @e[tag=st.radar_keep,tag=!st.radar] run function stamina:compass/radar_on
execute as @e[tag=st.radar,tag=!st.radar_keep] run function stamina:compass/radar_off
tag @e[tag=st.radar_keep] remove st.radar_keep
