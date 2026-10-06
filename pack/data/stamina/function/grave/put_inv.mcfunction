# The grave's inventory items, one at a time, each back into its own slot (container.<Slot>)
data modify storage stamina:grave cur set from storage stamina:grave work.inv[0]
function stamina:grave/put_slot with storage stamina:grave cur
data remove storage stamina:grave work.inv[0]
execute if data storage stamina:grave work.inv[0] run function stamina:grave/put_inv
