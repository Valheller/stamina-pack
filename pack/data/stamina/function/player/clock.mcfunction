# As a player holding a clock in either hand (stamina:player/fx/build): the time of day as 24-hour HH:MM, shown
# just left of the hotbar (stamina:player/clock_row). Day tick 0 is 06:00, each hour 1000 ticks. Outside the
# Overworld it reads --:--, as a clock spins there.
execute unless dimension minecraft:overworld run return run function stamina:player/clock_row {h1:"-",h2:"-",m1:"-",m2:"-"}
execute store result score #t st.tmp run time query minecraft:day
scoreboard players operation #t st.tmp %= #24000 st.const
#   hours: 06 at tick 0, wrapping past 23
scoreboard players operation #h st.tmp = #t st.tmp
scoreboard players operation #h st.tmp /= #1000 st.const
scoreboard players add #h st.tmp 6
scoreboard players operation #h st.tmp %= #24 st.const
#   minutes: 1000 ticks an hour
scoreboard players operation #m st.tmp = #t st.tmp
scoreboard players operation #m st.tmp %= #1000 st.const
scoreboard players operation #m st.tmp *= #60 st.const
scoreboard players operation #m st.tmp /= #1000 st.const
#   one digit each
scoreboard players operation #d st.tmp = #h st.tmp
execute store result storage stamina:clock args.h1 int 1 run scoreboard players operation #d st.tmp /= #10 st.const
execute store result storage stamina:clock args.h2 int 1 run scoreboard players operation #h st.tmp %= #10 st.const
scoreboard players operation #d st.tmp = #m st.tmp
execute store result storage stamina:clock args.m1 int 1 run scoreboard players operation #d st.tmp /= #10 st.const
execute store result storage stamina:clock args.m2 int 1 run scoreboard players operation #m st.tmp %= #10 st.const
function stamina:player/clock_row with storage stamina:clock args
