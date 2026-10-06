# #dur ticks -> args.m1 m2 s1 s2 (mm:ss, rounded up to whole seconds; tens of minutes padded when 0)
scoreboard players operation #s st.tmp = #dur st.tmp
scoreboard players add #s st.tmp 19
scoreboard players operation #s st.tmp /= #20 st.const
scoreboard players operation #m st.tmp = #s st.tmp
scoreboard players operation #m st.tmp /= #60 st.const
scoreboard players operation #s st.tmp %= #60 st.const
scoreboard players operation #m1 st.tmp = #m st.tmp
scoreboard players operation #m1 st.tmp /= #10 st.const
scoreboard players operation #m st.tmp %= #10 st.const
scoreboard players operation #s1 st.tmp = #s st.tmp
scoreboard players operation #s1 st.tmp /= #10 st.const
scoreboard players operation #s st.tmp %= #10 st.const
execute store result storage stamina:fx args.m1 int 1 run scoreboard players get #m1 st.tmp
execute if score #m1 st.tmp matches 0 run function stamina:player/fx/pad_minutes
execute store result storage stamina:fx args.m2 int 1 run scoreboard players get #m st.tmp
execute store result storage stamina:fx args.s1 int 1 run scoreboard players get #s1 st.tmp
execute store result storage stamina:fx args.s2 int 1 run scoreboard players get #s st.tmp
