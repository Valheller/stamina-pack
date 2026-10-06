# drain += jumps * #jump_cost
scoreboard players operation #tmp st.tmp = @s st.jumps
scoreboard players operation #tmp st.tmp *= #jump_cost st.config
scoreboard players operation @s st.drain += #tmp st.tmp
scoreboard players set @s st.jumps 0
