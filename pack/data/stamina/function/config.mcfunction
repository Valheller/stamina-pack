# ===== Stamina Pack tuning =====
# Edit these values, then run /reload. Stamina is on a 0..#max scale. (20 ticks = 1 second)

# Display: 1 = stamina icons where the hunger bar was (needs stamina_pack.zip enabled as a resource pack too)
#          0 = text meter on the action bar (for players without the resource pack)
scoreboard players set #hud_mode st.config 1

# Graves: 1 = on death your belongings are buried in a grave at the death spot, and go back into their own
#         slots when you click it (turns the keep_inventory gamerule on); 0 = vanilla drops
scoreboard players set #graves st.config 1
#   multiplayer: 1 = only the player who died can open their grave; 0 = anyone can
scoreboard players set #grave_lock st.config 1
#   ...and after this many minutes unclaimed, anyone can (0 = never). Each grave keeps its chunk loaded until
#   it is opened, so on a busy server a time limit stops forgotten graves piling up.
scoreboard players set #grave_unlock st.config 0

# Durability: 1 = an item that runs out of durability becomes Broken (useless until repaired) instead of
#             being destroyed; 0 = vanilla
scoreboard players set #durability st.config 1

# Maximum stamina
scoreboard players set #max st.config 1000

# Costs
#   sprinting (and sprint-swimming), per tick  -> 4/tick = 12.5 s of sprinting from full
scoreboard players set #sprint_cost st.config 4
#   per jump
scoreboard players set #jump_cost st.config 15

# Recovery
#   ticks without any drain before regen starts
scoreboard players set #regen_delay st.config 20
#   regen per tick
scoreboard players set #regen st.config 8
#   extra regen per tick while sneaking (catching your breath)
scoreboard players set #regen_sneak st.config 6

# Exhaustion: hitting 0 blocks sprinting and slows you until stamina recovers to this value
scoreboard players set #recover st.config 200

# Internal hunger lock. The vanilla food bar is pinned to these values:
#   10 -> can sprint, no natural regeneration (needs 18+)
#    6 -> vanilla blocks sprinting (used while exhausted)
scoreboard players set #food_normal st.config 10
scoreboard players set #food_exhausted st.config 6
