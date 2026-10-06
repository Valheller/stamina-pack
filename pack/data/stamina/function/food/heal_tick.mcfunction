# As a player being healed by food, every tick before their own tick (where the Regeneration heals): one HP came
# back last tick. Stop once it's all back, or they're at full health.
scoreboard players remove @s st.heal 1
execute store result score #hp st.tmp run data get entity @s Health 100
execute store result score #mhp st.tmp run attribute @s minecraft:max_health get 100
execute if score #hp st.tmp >= #mhp st.tmp run scoreboard players set @s st.heal 0
execute if score @s st.heal matches ..0 run return run function stamina:food/heal_end
effect give @s minecraft:regeneration 1 9 true
