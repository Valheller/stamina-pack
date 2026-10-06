# No compass in hand: no waypoints, so no locator bar (the markers stop being refreshed and go, see stamina:tick)
attribute @s minecraft:waypoint_receive_range modifier remove stamina:no_compass
attribute @s minecraft:waypoint_receive_range modifier add stamina:no_compass -1 add_multiplied_total
