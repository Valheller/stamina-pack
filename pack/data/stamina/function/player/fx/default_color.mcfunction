data modify storage stamina:fx args.color set value "white"
execute if score #dur st.tmp matches ..200 unless score #dur st.tmp matches -1 run data modify storage stamina:fx args.color set value "red"
