# Macro (k: equipment key in the grave's data, s: the player's slot)
$data modify storage stamina:grave cur set from storage stamina:grave work.eq.$(k)
$function stamina:grave/put {s:"$(s)"}
