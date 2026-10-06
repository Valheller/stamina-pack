# Everything in storage stamina:grave work (inv and eq) dropped here as items: when no grave could be
# placed, and on uninstall
execute if data storage stamina:grave work.eq.head run data modify storage stamina:grave cur set from storage stamina:grave work.eq.head
execute if data storage stamina:grave work.eq.head run function stamina:grave/drop
execute if data storage stamina:grave work.eq.chest run data modify storage stamina:grave cur set from storage stamina:grave work.eq.chest
execute if data storage stamina:grave work.eq.chest run function stamina:grave/drop
execute if data storage stamina:grave work.eq.legs run data modify storage stamina:grave cur set from storage stamina:grave work.eq.legs
execute if data storage stamina:grave work.eq.legs run function stamina:grave/drop
execute if data storage stamina:grave work.eq.feet run data modify storage stamina:grave cur set from storage stamina:grave work.eq.feet
execute if data storage stamina:grave work.eq.feet run function stamina:grave/drop
execute if data storage stamina:grave work.eq.offhand run data modify storage stamina:grave cur set from storage stamina:grave work.eq.offhand
execute if data storage stamina:grave work.eq.offhand run function stamina:grave/drop
data remove storage stamina:grave work.eq
execute if data storage stamina:grave work.inv[0] run function stamina:grave/spill_inv
