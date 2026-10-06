# One effect (storage stamina:fx e) -> one HUD row

# Skip the pack's internal hunger-lock effects, hidden-icon effects, and anything about to expire
# (this also hides the 1-second Slowness/Mining Fatigue refreshed while exhausted)
execute if data storage stamina:fx e{id:"minecraft:hunger"} run return 0
execute if data storage stamina:fx e{id:"minecraft:saturation"} run return 0
execute if data storage stamina:fx e{show_icon:0b} run return 0
execute store result score #dur st.tmp run data get storage stamina:fx e.duration
execute if score #dur st.tmp matches 0..20 run return 0

# Icon (unknown effects are skipped)
data remove storage stamina:fx args
function stamina:player/fx/lookup with storage stamina:fx e
execute unless data storage stamina:fx args.icon run return 0
data modify storage stamina:fx args.icolor set value "white"

function stamina:player/fx/emit
