# Macro (id, inert, mat, key, model), as the player whose $(id) just ran out of durability: find the slot it's in.
# Held items go back in the hand they were in; worn armor falls off, since broken armor can't be worn.
$execute if items entity @s weapon.mainhand $(id) run return run function stamina:durability/break {slot:"weapon.mainhand",tag:"st.dur_mainhand",inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
$execute if items entity @s weapon.offhand $(id) run return run function stamina:durability/break {slot:"weapon.offhand",tag:"st.dur_offhand",inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
$execute if items entity @s armor.head $(id) run return run function stamina:durability/break {slot:"armor.head",tag:"st.dur_worn",inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
$execute if items entity @s armor.chest $(id) run return run function stamina:durability/break {slot:"armor.chest",tag:"st.dur_worn",inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
$execute if items entity @s armor.legs $(id) run return run function stamina:durability/break {slot:"armor.legs",tag:"st.dur_worn",inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
$execute if items entity @s armor.feet $(id) run return run function stamina:durability/break {slot:"armor.feet",tag:"st.dur_worn",inert:$(inert),mat:"$(mat)",key:"$(key)",model:"$(model)"}
