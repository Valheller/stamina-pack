# Recovery this tick: #regen, more while sneaking
scoreboard players operation @s st.regen = #regen st.config
execute if predicate stamina:sneaking run scoreboard players operation @s st.regen += #regen_sneak st.config
scoreboard players operation @s stamina += @s st.regen
