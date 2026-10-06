# The Regeneration a food heal covered (storage stamina:heal hid) goes back on: seconds left rounded up
# (infinite stays infinite), same level
execute store result score #s st.tmp run data get storage stamina:heal hid.duration
scoreboard players add #s st.tmp 19
scoreboard players operation #s st.tmp /= #20 st.const
execute store result storage stamina:heal args.s int 1 run scoreboard players get #s st.tmp
execute if score #s st.tmp matches ..0 run data modify storage stamina:heal args.s set value "infinite"
execute store result storage stamina:heal args.a int 1 run data get storage stamina:heal hid.amplifier
function stamina:food/heal_give with storage stamina:heal args
