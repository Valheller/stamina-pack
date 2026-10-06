# Runs on world load and /reload

scoreboard objectives add stamina dummy
scoreboard objectives add st.config dummy
scoreboard objectives add st.const dummy
scoreboard objectives add st.tmp dummy
scoreboard objectives add st.drain dummy
scoreboard objectives add st.delay dummy
scoreboard objectives add st.regen dummy
scoreboard objectives add st.show dummy
scoreboard objectives add st.pct dummy
scoreboard objectives add st.seg dummy
scoreboard objectives add st.ftarget dummy
#   health still to come from food (1 per tick: stamina:food/heal_tick)
scoreboard objectives add st.heal dummy
#   player number, so each player's compass markers know whose they are
scoreboard objectives add st.pid dummy
#   HUD sends (stamina:player/hud/send): ticks since the last, and the stamina step and exhaustion it showed
scoreboard objectives add st.hudt dummy
scoreboard objectives add st.lseg dummy
scoreboard objectives add st.lexh dummy

# Vanilla stat trackers
scoreboard objectives add st.food food
scoreboard objectives add st.jumps minecraft.custom:minecraft.jump
scoreboard objectives add st.deaths deathCount
# One "item used" objective per food (generated)
function stamina:food/setup

# Constants
scoreboard players set #2 st.const 2
scoreboard players set #4 st.const 4
scoreboard players set #10 st.const 10
scoreboard players set #20 st.const 20
scoreboard players set #60 st.const 60
scoreboard players set #90 st.const 90
scoreboard players set #100 st.const 100
scoreboard players set #24 st.const 24
scoreboard players set #1000 st.const 1000
scoreboard players set #1200 st.const 1200
scoreboard players set #24000 st.const 24000

# Effect icon glyphs for the HUD timers (generated)
function stamina:player/fx/icons

function stamina:config

# The locator bar is the compass (stamina:compass/*)
gamerule minecraft:locator_bar true
# Graves: belongings stay on the dead player for a tick, in their slots, so stamina:grave/make can move them
# into the grave. With graves turned off, keep_inventory goes back off (only if this pack turned it on).
execute if score #graves st.config matches 1 run gamerule minecraft:keep_inventory true
execute if score #graves st.config matches 1 run data modify storage stamina:flags keep_inv set value 1b
execute if score #graves st.config matches 0 if data storage stamina:flags {keep_inv:1b} run gamerule minecraft:keep_inventory false
execute if score #graves st.config matches 0 run data remove storage stamina:flags keep_inv

tellraw @a [{"text":""},{"text":"[Stamina] ","color":"gold"},{"text":"Loaded. Hunger is now stamina; food heals.","color":"gray"}]
