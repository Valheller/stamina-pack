# Food heals directly: Regeneration X heals 1 HP every tick it's on, and it comes off again as soon as st.heal
# HP are back (stamina:food/heal_tick), so the amount is exact. (No command heals outright, and Instant Health
# only heals in steps of 4.) A Regeneration the player already had, such as a golden apple's, is kept
# underneath and goes back on afterwards (stamina:food/heal_end).
tag @s add st.healing
effect give @s minecraft:regeneration 1 9 true
