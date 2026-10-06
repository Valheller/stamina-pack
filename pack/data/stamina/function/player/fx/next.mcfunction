# Pop the first effect off the list, render it, repeat while rows remain
data modify storage stamina:fx e set from storage stamina:fx list[0]
data remove storage stamina:fx list[0]
function stamina:player/fx/entry
execute if score #row st.tmp matches ..5 if data storage stamina:fx list[0] run function stamina:player/fx/next
