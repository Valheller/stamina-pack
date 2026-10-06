# Advancement reward: the player clicked a grave (either button). Find the one they clicked (its
# interaction remembers them as target or attacker) and give its belongings to them (stamina:grave/collect).
advancement revoke @s only stamina:grave/open
advancement revoke @s only stamina:grave/hit
tag @s add st.opener
scoreboard players set @e[type=minecraft:interaction,tag=st.grave_hit,distance=..8] st.tmp 0
execute as @e[type=minecraft:interaction,tag=st.grave_hit,distance=..8] store success score @s st.tmp on target if entity @s[tag=st.opener]
execute as @e[type=minecraft:interaction,tag=st.grave_hit,distance=..8,scores={st.tmp=0}] store success score @s st.tmp on attacker if entity @s[tag=st.opener]
tag @s remove st.opener
execute at @e[type=minecraft:interaction,tag=st.grave_hit,distance=..8,scores={st.tmp=1},limit=1,sort=nearest] run function stamina:grave/collect
