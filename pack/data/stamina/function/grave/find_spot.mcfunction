# Walk up until a grave fits. Below the world every block reads as void_air: those steps are free, so a
# void death climbs all the way back to the lowest buildable block. Inside the world give up after 64
# blocks (e.g. died sealed in stone).
execute if function stamina:grave/try_place run return run function stamina:grave/build
execute unless block ~ ~ ~ minecraft:void_air run scoreboard players add #climb st.tmp 1
scoreboard players add #steps st.tmp 1
execute if score #climb st.tmp matches 64.. run return fail
execute if score #steps st.tmp matches 2048.. run return fail
return run execute positioned ~ ~1 ~ run function stamina:grave/find_spot
