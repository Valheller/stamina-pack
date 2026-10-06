data modify storage stamina:grave cur set from storage stamina:grave work.inv[0]
function stamina:grave/drop
data remove storage stamina:grave work.inv[0]
execute if data storage stamina:grave work.inv[0] run function stamina:grave/spill_inv
