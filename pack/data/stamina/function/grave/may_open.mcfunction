# As a player clicking a grave (its data in storage stamina:grave work), with graves locked to their owner
# (#grave_lock): 1 if they may open it - it's theirs, it's from before graves had owners, or it has stood
# unclaimed for #grave_unlock minutes (0 = never)
execute unless data storage stamina:grave work.uuid run return 1
data modify storage stamina:grave chk set from storage stamina:grave work.uuid
execute store success score #diff st.tmp run data modify storage stamina:grave chk set from entity @s UUID
execute if score #diff st.tmp matches 0 run return 1
execute unless score #grave_unlock st.config matches 1.. run return fail
execute unless data storage stamina:grave work.t run return fail
execute store result score #age st.tmp run time query gametime
execute store result score #t st.tmp run data get storage stamina:grave work.t
scoreboard players operation #age st.tmp -= #t st.tmp
scoreboard players operation #t st.tmp = #grave_unlock st.config
scoreboard players operation #t st.tmp *= #1200 st.const
execute if score #age st.tmp >= #t st.tmp run return 1
return fail
