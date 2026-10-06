# Stamina Pack: regenerates the data-driven parts of the pack, then zips it as stamina_pack.zip.
# Run from anywhere:  powershell -ExecutionPolicy Bypass -File tools\build.ps1
# The pack is one folder (pack\) holding both data\ (datapack) and assets\ (resource pack); the same zip works
# dropped into a world's datapacks folder or the resourcepacks folder. Hand-written files (tick, load, config,
# player logic, graves, compass, durability helpers) are never touched.
# Needs the 26.3 client jar (vanilla tags, item list and sprites are read from it; nothing is copied whole).
# Non-ASCII characters are built from char codes because Windows PowerShell 5.1 reads scripts as ANSI.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing, System.IO.Compression, System.IO.Compression.FileSystem

$proj = Split-Path $PSScriptRoot -Parent
$pack = Join-Path $proj 'pack'
$fn = Join-Path $pack 'data\stamina\function'
$enc = New-Object System.Text.UTF8Encoding $false

$vanillaJar = Join-Path $env:APPDATA '.minecraft\versions\26.3\26.3.jar'
if (-not (Test-Path $vanillaJar)) { throw "The 26.3 client jar is needed: $vanillaJar" }
$vj = [IO.Compression.ZipFile]::OpenRead($vanillaJar)
$vItems = @{}; foreach ($en in $vj.Entries) { if ($en.FullName -match '^assets/minecraft/items/([a-z0-9_]+)\.json$') { $vItems[$Matches[1]] = 1 } }
function Vanilla-Png($path) {
  $ms = New-Object IO.MemoryStream
  $s = $vj.GetEntry($path).Open(); $s.CopyTo($ms); $s.Close()
  New-Object System.Drawing.Bitmap ([System.Drawing.Image]::FromStream($ms))
}

function WriteFile($path, $text) {
  New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
  [IO.File]::WriteAllText($path, $text, $enc)
}
function W($rel, $lines) { WriteFile (Join-Path $fn $rel) (($lines -join "`n") + "`n") }
function J($path, $obj) { WriteFile $path (($obj | ConvertTo-Json -Depth 30) + "`n") }
function SavePng($bmp, $path) {
  New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
}
$u = [string][char]92 + 'u'   # JSON \u escapes are assembled from parts

# ============================================================ Foods
# Each food heals hp HP (1 HP = half a heart) and restores st % of the stamina bar. No effects are added;
# vanilla's own (a golden apple's, a pufferfish's poison, chorus fruit's teleport...) still happen.
# Not listed on purpose (poisonous, no healing): poisonous_potato, spider_eye, pufferfish.
$foods = @(
  @{id='apple';                  n='Apple';                  hp=4;  st=15},
  @{id='golden_apple';           n='Golden Apple';           hp=8;  st=50},
  @{id='enchanted_golden_apple'; n='Enchanted Golden Apple'; hp=20; st=100},
  @{id='golden_carrot';          n='Golden Carrot';          hp=6;  st=40},
  @{id='carrot';                 n='Carrot';                 hp=3;  st=10},
  @{id='bread';                  n='Bread';                  hp=5;  st=25},
  @{id='baked_potato';           n='Baked Potato';           hp=5;  st=25},
  @{id='potato';                 n='Potato';                 hp=1;  st=5},
  @{id='beetroot';               n='Beetroot';               hp=1;  st=10},
  @{id='beetroot_soup';          n='Beetroot Soup';          hp=6;  st=30},
  @{id='mushroom_stew';          n='Mushroom Stew';          hp=6;  st=30},
  @{id='rabbit_stew';            n='Rabbit Stew';            hp=10; st=40},
  @{id='suspicious_stew';        n='Suspicious Stew';        hp=6;  st=30},
  @{id='cooked_beef';            n='Steak';                  hp=8;  st=30},
  @{id='beef';                   n='Raw Beef';               hp=3;  st=5},
  @{id='cooked_porkchop';        n='Cooked Porkchop';        hp=8;  st=30},
  @{id='porkchop';               n='Raw Porkchop';           hp=3;  st=5},
  @{id='cooked_mutton';          n='Cooked Mutton';          hp=6;  st=25},
  @{id='mutton';                 n='Raw Mutton';             hp=2;  st=5},
  @{id='cooked_chicken';         n='Cooked Chicken';         hp=6;  st=25},
  @{id='chicken';                n='Raw Chicken';            hp=2;  st=5},
  @{id='cooked_rabbit';          n='Cooked Rabbit';          hp=5;  st=25},
  @{id='rabbit';                 n='Raw Rabbit';             hp=3;  st=5},
  @{id='cooked_cod';             n='Cooked Cod';             hp=5;  st=20},
  @{id='cod';                    n='Raw Cod';                hp=2;  st=5},
  @{id='cooked_salmon';          n='Cooked Salmon';          hp=6;  st=25},
  @{id='salmon';                 n='Raw Salmon';             hp=2;  st=5},
  @{id='tropical_fish';          n='Tropical Fish';          hp=1;  st=5},
  @{id='melon_slice';            n='Melon Slice';            hp=2;  st=15},
  @{id='sweet_berries';          n='Sweet Berries';          hp=2;  st=10},
  @{id='glow_berries';           n='Glow Berries';           hp=2;  st=10},
  @{id='cookie';                 n='Cookie';                 hp=2;  st=20},
  @{id='pumpkin_pie';            n='Pumpkin Pie';            hp=8;  st=30},
  @{id='honey_bottle';           n='Honey Bottle';           hp=4;  st=40},
  @{id='dried_kelp';             n='Dried Kelp';             hp=1;  st=5},
  @{id='rotten_flesh';           n='Rotten Flesh';           hp=2;  st=0},
  @{id='chorus_fruit';           n='Chorus Fruit';           hp=2;  st=10},
  @{id='cake'; key='block.minecraft.cake'; crit='minecraft.custom:minecraft.eat_cake_slice'; n='Cake'; hp=2; st=20}
)

$setup = @('# GENERATED: one objective per food, counting times eaten')
$teardown = @('# GENERATED')
$check = @('# GENERATED: food eaten since last tick. Context: as/at player')
$lang = @()
$SECT = $u + '00a7'; $HEART = $u + '2764'; $BOLT = $u + '26a1'; $HALFC = $u + '00bd'
foreach ($f in $foods) {
  $obj = "st.eat.$($f.id)"
  $crit = if ($f.crit) { $f.crit } else { "minecraft.used:minecraft.$($f.id)" }
  $setup += "scoreboard objectives add $obj $crit"
  $teardown += "scoreboard objectives remove $obj"
  $check += "execute if score @s $obj matches 1.. run function stamina:food/$($f.id)"
  $body = @("# $($f.n)$(if ($f.id -eq 'cake') { ' (a slice)' }): +$($f.hp) HP, +$($f.st)% stamina", "scoreboard players set @s $obj 0")
  if ($f.hp -gt 0) { $body += "scoreboard players add @s st.heal $($f.hp)" }
  if ($f.st -gt 0) { $body += "scoreboard players add @s stamina $($f.st * 10)" }
  W "food\$($f.id).mcfunction" ($body + 'function stamina:food/eaten')
  # Name with what it gives: "Steak  +4(heart) +30%(bolt)"
  $hearts = [string][Math]::Floor($f.hp / 2)
  if ($f.hp % 2) { $hearts = if ($f.hp -eq 1) { $HALFC } else { $hearts + $HALFC } }
  $label = "$($f.n)  $($SECT)c+$hearts$HEART"
  if ($f.st -gt 0) { $label += " $($SECT)e+$($f.st)%$BOLT" }
  $key = if ($f.key) { $f.key } else { "item.minecraft.$($f.id)" }
  $lang += "  `"$key`": `"$label`""
}
W 'food\setup.mcfunction' $setup
W 'food\teardown.mcfunction' $teardown
W 'food\check.mcfunction' $check
WriteFile (Join-Path $pack 'assets\minecraft\lang\en_us.json') ("{`n" + ($lang -join ",`n") + "`n}`n")

# ============================================================ Graves: what stays with the player
# Item NBT doesn't list default components, so durability can't be read from the stored inventory; each slot is
# checked live instead. Kept: anything with durability (tools, weapons, armor, shields, bows, elytra...) and
# #stamina:kept_on_death (compasses, clocks, spyglasses).
$keep = @('# GENERATED. As the dead player (stamina:grave/make): each slot holding gear keeps it (and it stays out of the',
  '# grave); every other slot is emptied (its item is already in storage stamina:grave new)')
$slots = @(0..35 | ForEach-Object { @{ s = "container.$_"; d = "new.inv[{Slot:$($_)b}]" } }) + @(@{ s = 'weapon.offhand'; d = 'new.eq.offhand' })
foreach ($x in $slots) {
  $keep += "execute if items entity @s $($x.s) *[minecraft:max_damage] run data remove storage stamina:grave $($x.d)"
  $keep += "execute if items entity @s $($x.s) #stamina:kept_on_death run data remove storage stamina:grave $($x.d)"
  $keep += "execute unless items entity @s $($x.s) *[minecraft:max_damage] unless items entity @s $($x.s) #stamina:kept_on_death run item replace entity @s $($x.s) with minecraft:air"
}
W 'grave\keep.mcfunction' $keep

# ============================================================ Durability: broken, not destroyed
# An item that runs out of durability becomes Broken instead of vanishing. It keeps everything (name,
# enchantments, trims) but does nothing until repaired, and its enchantments lie dormant meanwhile.
# How: stamina:durability/break has one criterion per damageable item (durability reaching 0). Its reward
# runs before the game deletes the item, so it copies the item onto a hidden item_display and rebuilds it
# there as broken; the next tick hands it back (stamina:durability/place). Most items are switched off by
# stripping their function components (tool, weapon, equippable, blocks_attacks...). Items whose use is
# hard-coded (bows, fishing rods, shears...) are swapped for an inert stand-in that looks the same.
# Once anything repairs it (anvil, crafting, grindstone), stamina:durability/repaired makes it whole again.
# Repairs are vanilla's: an anvil with the item's material (or a second one), the crafting grid, a grindstone.
function Vanilla-Tag($name) {
  $t = (New-Object IO.StreamReader($vj.GetEntry("data/minecraft/tags/item/$name.json").Open())).ReadToEnd() | ConvertFrom-Json
  @($t.values | Where-Object { $_ -is [string] -and $_ -notlike '#*' } | ForEach-Object { $_ -replace '^minecraft:', '' })
}
$toolMat = @{ wooden = 'wooden'; stone = 'stone'; copper = 'copper'; iron = 'iron'; golden = 'gold'; diamond = 'diamond'; netherite = 'netherite' }
$armorMat = @{ leather = 'leather'; chainmail = 'chain'; copper = 'copper'; iron = 'iron'; golden = 'gold'; diamond = 'diamond'; netherite = 'netherite' }
$toolKinds = 'sword', 'spear', 'shovel', 'hoe', 'pickaxe', 'axe'
$armorKinds = 'helmet', 'chestplate', 'leggings', 'boots'
# mat: what repairs the inert stand-in in an anvil (other items keep their own repairable component)
$durItems = @()
foreach ($tag in 'swords', 'spears', 'shovels', 'hoes', 'pickaxes', 'axes') {
  foreach ($id in Vanilla-Tag $tag) {
    $tier = $id.Split('_')[0]; $kind = $id.Split('_')[-1]
    if (-not $toolMat[$tier] -or $toolKinds -notcontains $kind) { continue }
    $durItems += [ordered]@{ id = $id; mat = "#minecraft:$($toolMat[$tier])_tool_materials" }
  }
}
foreach ($tag in 'head_armor', 'chest_armor', 'leg_armor', 'foot_armor') {
  foreach ($id in Vanilla-Tag $tag) {
    $tier = $id.Split('_')[0]; $kind = $id.Split('_')[-1]
    if ($id -eq 'turtle_helmet') { $durItems += [ordered]@{ id = $id; mat = '#minecraft:repairs_turtle_helmet' }; continue }
    if (-not $armorMat[$tier] -or $armorKinds -notcontains $kind) { continue }
    $durItems += [ordered]@{ id = $id; mat = "#minecraft:repairs_$($armorMat[$tier])_armor" }
  }
}
# The rest. inert = use is hard-coded, so the broken form is a stand-in item (repairable in an anvil)
$durItems += @(
  [ordered]@{ id = 'shield'; mat = '#minecraft:wooden_tool_materials' }
  [ordered]@{ id = 'elytra'; mat = 'minecraft:phantom_membrane' }
  [ordered]@{ id = 'trident'; mat = 'minecraft:prismarine_shard' }
  [ordered]@{ id = 'mace'; mat = 'minecraft:breeze_rod'; inert = 1 }
  [ordered]@{ id = 'bow'; mat = 'minecraft:string'; inert = 1 }
  [ordered]@{ id = 'crossbow'; mat = 'minecraft:string'; inert = 1 }
  [ordered]@{ id = 'fishing_rod'; mat = 'minecraft:string'; inert = 1 }
  [ordered]@{ id = 'flint_and_steel'; mat = 'minecraft:flint'; inert = 1 }
  [ordered]@{ id = 'shears'; mat = 'minecraft:iron_ingot'; inert = 1 }
  [ordered]@{ id = 'brush'; mat = 'minecraft:copper_ingot'; inert = 1 }
  [ordered]@{ id = 'carrot_on_a_stick'; mat = 'minecraft:carrot'; inert = 1 }
  [ordered]@{ id = 'warped_fungus_on_a_stick'; mat = 'minecraft:warped_fungus'; inert = 1 }
)
$durItems = @($durItems | Where-Object { $vItems[$_.id] })

$crit = [ordered]@{}
$broke = @(
  '# GENERATED. Reward of stamina:durability/break: an item just ran out of durability and the game is about',
  '# to delete it. Work out which item it was (by criterion) and where it is, and save it as broken.',
  'execute unless score #durability st.config matches 1 run return run advancement revoke @s only stamina:durability/break'
)
foreach ($d in $durItems) {
  $crit[$d.id] = [ordered]@{ trigger = 'minecraft:item_durability_changed'
    conditions = [ordered]@{ item = [ordered]@{ items = "minecraft:$($d.id)" }; durability = [ordered]@{ max = 0 } } }
  $inert = if ($d.inert) { 1 } else { 0 }
  $broke += "execute if entity @s[advancements={stamina:durability/break={$($d.id)=true}}] run function stamina:durability/find {id:`"minecraft:$($d.id)`",inert:$inert,mat:`"$($d.mat)`",key:`"item.minecraft.$($d.id)`",model:`"stamina:broken/$($d.id)`"}"
}
$broke += 'advancement revoke @s only stamina:durability/break'
W 'durability\broke.mcfunction' $broke
J (Join-Path $pack 'data\stamina\advancement\durability\break.json') ([ordered]@{
  criteria = $crit; requirements = @(, [string[]]@($durItems | ForEach-Object { $_.id }))
  rewards = [ordered]@{ function = 'stamina:durability/broke' } })
J (Join-Path $pack 'data\stamina\item_modifier\durability\empty.json') ([ordered]@{ type = 'minecraft:set_damage'; damage = 0.0 })

# Components set aside while broken (restored on repair), components switched off while broken,
# and the extra ones the inert stand-in replaces
$stashKeys = @('enchantments', 'attribute_modifiers', 'tool', 'weapon', 'kinetic_weapon', 'piercing_weapon', 'block_transformer', 'blocks_attacks', 'equippable', 'glider', 'lore', 'item_model')
$offKeys = @('attribute_modifiers', 'tool', 'weapon', 'kinetic_weapon', 'piercing_weapon', 'block_transformer', 'blocks_attacks', 'equippable', 'glider')
$inertKeys = @('item_name', 'max_damage', 'max_stack_size', 'repairable')
$inertOff = @('food', 'consumable', 'compostable')
$S = 'storage stamina:dur'
function Stash($k) { "data modify $S s.`"minecraft:$k`" set from $S it.components.`"minecraft:$k`"", "data remove $S it.components.`"minecraft:$k`"" }
function Unstash($k) { "data remove $S it.components.`"minecraft:$k`"", "data modify $S it.components.`"minecraft:$k`" set from $S s.`"minecraft:$k`"" }

$w = @(
  '# GENERATED. As the item_display holding a copy of an item that just ran out of durability: rebuild it as',
  '# broken. Uses storage stamina:dur a (inert, mat, key) from stamina:durability/break.',
  '#   already broken (shouldn''t happen): only make sure the display holds its own copy of the item',
  'execute if items entity @s contents *[minecraft:custom_data~{st_broken:{}}] run return run data modify entity @s item.count set value 1',
  '#   durability 0, set aside everything that makes it work, and switch those off',
  'item modify entity @s contents stamina:durability/empty',
  "data modify $S it set from entity @s item",
  "data modify $S s set value {}",
  "data modify $S s.id set from $S it.id"
)
foreach ($k in $stashKeys) { $w += Stash $k }
foreach ($k in $offKeys) { $w += "data modify $S it.components.`"!minecraft:$k`" set value {}" }
$w += "execute if data $S a{inert:1} run function stamina:durability/inert with $S a"
$w += '#   cracked look (stamina_resourcepack: assets/stamina/items/broken)'
$w += "data modify $S it.components.`"minecraft:item_model`" set from $S a.model"
$w += "data modify $S it.components.`"minecraft:lore`" set value [{text:`"Broken`",color:`"red`",italic:false},{text:`"Repair it to use it again`",color:`"gray`",italic:false}]"
$w += "execute if data $S s.`"minecraft:enchantments`" run data modify $S it.components.`"minecraft:lore`" append value {text:`"Its enchantments return once repaired`",color:`"dark_purple`",italic:false}"
$w += "data modify $S it.components.`"minecraft:custom_data`".st_broken set from $S s"
$w += "data modify entity @s item set from $S it"
W 'durability\wreck.mcfunction' $w

$w = @(
  '# GENERATED. Macro (mat, key). The broken form of an item whose use is hard-coded: an inert poisonous potato',
  '# that looks and is named like the original, still shows its durability, and repairs in an anvil with $(mat).'
)
foreach ($k in $inertKeys) { $w += Stash $k }
$w += "data modify $S s.inert set value 1b"
$w += "data modify $S it.id set value `"minecraft:poisonous_potato`""
$w += "data modify $S it.components.`"minecraft:max_damage`" set from $S it.components.`"minecraft:damage`""
$w += "data modify $S it.components.`"minecraft:max_stack_size`" set value 1"
$w += "`$data modify $S it.components.`"minecraft:item_name`" set value {translate:`"`$(key)`"}"
$w += "`$data modify $S it.components.`"minecraft:repairable`" set value {items:`"`$(mat)`"}"
foreach ($k in $inertOff) { $w += "data modify $S it.components.`"!minecraft:$k`" set value {}" }
W 'durability\inert.mcfunction' $w

$w = @(
  '# GENERATED. As the item_display holding a broken item that has been repaired: make it whole again.',
  "data modify $S it set from entity @s item",
  "data modify $S s set from $S it.components.`"minecraft:custom_data`".st_broken",
  "data remove $S it.components.`"minecraft:custom_data`".st_broken",
  "execute store result score #n st.tmp run data get $S it.components.`"minecraft:custom_data`"",
  "execute if score #n st.tmp matches 0 run data remove $S it.components.`"minecraft:custom_data`"",
  "execute if data $S s.inert run function stamina:durability/uninert"
)
foreach ($k in $offKeys) { $w += "data remove $S it.components.`"!minecraft:$k`"" }
foreach ($k in $stashKeys) { if ($k -ne 'enchantments') { $w += Unstash $k } }
$w += '#   merged, in case it was enchanted while broken'
$w += "execute if data $S s.`"minecraft:enchantments`" unless data $S it.components.`"minecraft:enchantments`" run data modify $S it.components.`"minecraft:enchantments`" set value {}"
$w += "data modify $S it.components.`"minecraft:enchantments`" merge from $S s.`"minecraft:enchantments`""
$w += "data modify entity @s item set from $S it"
W 'durability\mend.mcfunction' $w

$w = @('# GENERATED. Back from the inert stand-in to the real item', "data modify $S it.id set from $S s.id")
foreach ($k in $inertKeys) { $w += Unstash $k }
foreach ($k in $inertOff) { $w += "data remove $S it.components.`"!minecraft:$k`"" }
W 'durability\uninert.mcfunction' $w

$fixed = '*[minecraft:custom_data~{st_broken:{}},minecraft:damage~{durability:{min:1}}]'
$w = @('# GENERATED. As a player carrying a broken item that has been repaired (durability above 0): find it and fix it')
foreach ($i in 0..35) { $w += "execute if items entity @s container.$i $fixed run function stamina:durability/fix {slot:`"container.$i`"}" }
$w += "execute if items entity @s weapon.offhand $fixed run function stamina:durability/fix {slot:`"weapon.offhand`"}"
W 'durability\repaired.mcfunction' $w
Write-Host "durability: $($durItems.Count) items"

# Broken looks: each item's own vanilla sprite, snapped in two along a jagged "\" crack (the lower-left
# piece knocked a pixel down and left), with darkened break edges and dulled colours.
$crackJag = @(0, 1, 0, -1, 0, 1, 1, 0, -1, 0, 1, 0, -1, 0, 1, 0)
function Crack-Sprite($src) {
  $n = 16
  $dst = New-Object System.Drawing.Bitmap $n, $n, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  for ($x = 0; $x -lt $n; $x++) {
    for ($y = 0; $y -lt $n; $y++) {
      $c = $src.GetPixel($x, $y); if ($c.A -eq 0) { continue }
      $line = $x + $crackJag[$x]
      if ($y -eq $line) { continue }
      if ($y -lt $line) { $dst.SetPixel($x, $y, $c) }
      elseif ($x -ge 1 -and $y -lt $n - 1) { $dst.SetPixel($x - 1, $y + 1, $c) }
    }
  }
  $out = New-Object System.Drawing.Bitmap $n, $n, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  for ($x = 0; $x -lt $n; $x++) {
    for ($y = 0; $y -lt $n; $y++) {
      $c = $dst.GetPixel($x, $y); if ($c.A -eq 0) { continue }
      # an edge the break exposed: a see-through neighbour where the whole sprite had colour
      $edge = $false
      foreach ($o in @(@(1, 0), @(-1, 0), @(0, 1), @(0, -1))) {
        $nx = $x + $o[0]; $ny = $y + $o[1]
        if ($nx -lt 0 -or $ny -lt 0 -or $nx -ge $n -or $ny -ge $n) { continue }
        if ($dst.GetPixel($nx, $ny).A -eq 0 -and $src.GetPixel($nx, $ny).A -ne 0) { $edge = $true }
      }
      $gray = ($c.R * 0.3 + $c.G * 0.59 + $c.B * 0.11)
      $k = if ($edge) { 0.55 } else { 0.85 }
      $r = [int](($c.R * 0.7 + $gray * 0.3) * $k); $g = [int](($c.G * 0.7 + $gray * 0.3) * $k); $b = [int](($c.B * 0.7 + $gray * 0.3) * $k)
      $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($c.A, $r, $g, $b))
    }
  }
  $dst.Dispose(); $out
}

# The shield has no item sprite (it's drawn as a 3D model): cut its front face out of the entity texture
function Shield-Sprite {
  $tex = Vanilla-Png 'assets/minecraft/textures/entity/shield/shield_base_nopattern.png'
  $b = New-Object System.Drawing.Bitmap 16, 16, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  for ($x = 0; $x -lt 10; $x++) { for ($y = 0; $y -lt 16; $y++) {
    $b.SetPixel($x + 3, $y, $tex.GetPixel([int][Math]::Floor(($x + 0.5) * 13 / 10), [int][Math]::Floor(($y + 0.5) * 23 / 16))) } }
  $tex.Dispose(); $b
}
$handheld = @{}
foreach ($tag in 'swords', 'spears', 'shovels', 'hoes', 'pickaxes', 'axes') { foreach ($id in Vanilla-Tag $tag) { $handheld[$id] = 'minecraft:item/handheld' } }
foreach ($id in 'mace', 'trident') { $handheld[$id] = 'minecraft:item/handheld' }
foreach ($id in 'fishing_rod', 'carrot_on_a_stick', 'warped_fungus_on_a_stick') { $handheld[$id] = 'minecraft:item/handheld_rod' }
$texDir = Join-Path $pack 'assets\stamina\textures\item\broken'
foreach ($d in $durItems) {
  $id = $d.id
  $src = switch ($id) { 'shield' { Shield-Sprite } 'crossbow' { Vanilla-Png 'assets/minecraft/textures/item/crossbow_standby.png' } default { Vanilla-Png "assets/minecraft/textures/item/$id.png" } }
  SavePng (Crack-Sprite $src) (Join-Path $texDir "$id.png"); $src.Dispose()
  $layers = [ordered]@{ layer0 = "stamina:item/broken/$id" }
  $def = [ordered]@{ type = 'minecraft:model'; model = "stamina:item/broken/$id" }
  if ($id -like 'leather_*') {
    # dyeable: grey base tinted by the dye colour, plus the undyed overlay
    $ov = Vanilla-Png "assets/minecraft/textures/item/${id}_overlay.png"
    SavePng (Crack-Sprite $ov) (Join-Path $texDir "${id}_overlay.png"); $ov.Dispose()
    $layers.layer1 = "stamina:item/broken/${id}_overlay"
    $def.tints = @([ordered]@{ type = 'minecraft:dye'; default = -6265536 })
  }
  $parent = if ($handheld[$id]) { $handheld[$id] } else { 'minecraft:item/generated' }
  J (Join-Path $pack "assets\stamina\models\item\broken\$id.json") ([ordered]@{ parent = $parent; textures = $layers })
  J (Join-Path $pack "assets\stamina\items\broken\$id.json") ([ordered]@{ model = $def })
}
# ============================================================ The gravestone's model (stamina:grave/build)
# One item model on the 16px block grid, with vanilla's full-size block textures, so every pixel matches the
# blocks around it: a polished andesite plinth, a headstone 8px wide and 12px tall with a stepped top and a
# cross carved into its face, and a two-step coarse dirt mound in front (the model's north = the grave's front).
$and = Vanilla-Png 'assets/minecraft/textures/block/polished_andesite.png'
$carved = New-Object System.Drawing.Bitmap 16, 16, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
# texture u = 16 - model x and v = 16 - model y on a north face: the cross is model x 7-9, y 7-13 and x 5-11, y 10-12
function In-Cross($u, $v) { (($u -ge 7 -and $u -lt 9) -and ($v -ge 3 -and $v -lt 9)) -or (($u -ge 5 -and $u -lt 11) -and ($v -ge 4 -and $v -lt 6)) }
for ($x = 0; $x -lt 16; $x++) { for ($y = 0; $y -lt 16; $y++) {
  $c = $and.GetPixel($x, $y)
  if (In-Cross $x $y) {
    # the groove: dark, darkest along its top edge (in shadow)
    $k = if (-not (In-Cross $x ($y - 1))) { 0.42 } else { 0.58 }
    $c = [System.Drawing.Color]::FromArgb(255, [int]($c.R * $k), [int]($c.G * $k), [int]($c.B * $k))
  }
  $carved.SetPixel($x, $y, $c)
} }
$and.Dispose()
SavePng $carved (Join-Path $pack 'assets\stamina\textures\block\grave_stone.png')
function Gr-Box($from, $to, $tex, $northTex) {
  $faces = [ordered]@{}
  foreach ($f in 'north', 'east', 'south', 'west', 'up', 'down') { $faces[$f] = [ordered]@{ texture = $(if ($f -eq 'north' -and $northTex) { $northTex } else { $tex }) } }
  [ordered]@{ from = $from; to = $to; faces = $faces }
}
J (Join-Path $pack 'assets\stamina\models\item\grave.json') ([ordered]@{
  textures = [ordered]@{ stone = 'minecraft:block/polished_andesite'; face = 'stamina:block/grave_stone'; dirt = 'minecraft:block/coarse_dirt'; particle = 'minecraft:block/polished_andesite' }
  elements = @(
    (Gr-Box @(3, 0, 6) @(13, 2, 10) '#stone'),
    (Gr-Box @(4, 2, 7) @(12, 14, 9) '#stone' '#face'),
    (Gr-Box @(5, 14, 7) @(11, 15, 9) '#stone'),
    (Gr-Box @(4, 0, 1) @(12, 1, 6) '#dirt'),
    (Gr-Box @(5, 1, 2) @(11, 2, 5) '#dirt')
  )
})
J (Join-Path $pack 'assets\stamina\items\grave.json') ([ordered]@{ model = [ordered]@{ type = 'minecraft:model'; model = 'stamina:item/grave' } })

# ============================================================ Text meter (#hud_mode 0)
$bar = [string][char]0x25AE; $BOLTC = [string][char]0x26A1
$lines = @('# GENERATED: 20-segment text stamina meter (used when #hud_mode = 0)')
for ($n = 0; $n -le 20; $n++) {
  $color = if ($n -le 5) { 'red' } elseif ($n -le 10) { 'yellow' } else { 'green' }
  $lines += ('execute if score @s st.seg matches __N__ run title @s actionbar [{"text":""},{"text":"__BOLT__ ","color":"gold"},{"text":"__FILL__","color":"__C__"},{"text":"__EMPTY__","color":"dark_gray"},{"text":" "},{"score":{"name":"@s","objective":"st.pct"},"color":"gray"},{"text":"%","color":"gray"}]').Replace('__BOLT__', $BOLTC).Replace('__FILL__', $bar * $n).Replace('__EMPTY__', $bar * (20 - $n)).Replace('__C__', $color).Replace('__N__', "$n")
}
W 'player\display_bar.mcfunction' $lines
W 'player\display_exhausted.mcfunction' @('# GENERATED',
  ('title @s actionbar [{"text":""},{"text":"__BOLT__ EXHAUSTED","color":"red","bold":true},{"text":"  catch your breath... ","color":"gray"},{"score":{"name":"@s","objective":"st.pct"},"color":"gray"},{"text":"%","color":"gray"}]').Replace('__BOLT__', $BOLTC))

# ============================================================ Icon HUD (#hud_mode 1, needs the resource pack)
# The action bar is centred 68px above the screen bottom. The font (stamina:hud) shifts glyphs down onto the
# hunger row (ascent -26), and a 101px leading space pushes the 81px-wide bar right so it starts 10px right of
# centre, exactly where vanilla draws the food icons. Icons step 8px like vanilla (9px advance + 1px negative
# space) and fill right-to-left like drumsticks.
$PAD = [string][char]0xE000; $NEG = [string][char]0xE001
$FULL = [string][char]0xE010; $HALF = [string][char]0xE011; $EMPTY = [string][char]0xE012
$tints = [ordered]@{ normal = '#FFD13B'; exhausted = '#FF5555' }
foreach ($state in $tints.Keys) {
  $lines = @("# GENERATED: stamina icons on the hunger row ($state), then the effect timer rows")
  for ($lv = 0; $lv -le 20; $lv++) {
    $plain = $PAD; $tinted = ''
    for ($i = 9; $i -ge 0; $i--) {
      if ($lv -ge 2 * $i + 2) { $ch = $FULL; $t = $true } elseif ($lv -eq 2 * $i + 1) { $ch = $HALF; $t = $true } else { $ch = $EMPTY; $t = $false }
      if ($i -gt 0) { $ch += $NEG }
      if ($t) { $tinted += $ch } else { $plain += $ch }
    }
    $lines += ('execute if score @s st.seg matches __N__ run title @s actionbar [{"text":"","font":"stamina:hud","shadow_color":0},{"text":"__P__","color":"white"},{"text":"__T__","color":"__C__"},{"nbt":"rows[]","storage":"stamina:hud","interpret":true,"separator":""}]').Replace('__N__', "$lv").Replace('__P__', $plain).Replace('__T__', $tinted).Replace('__C__', $tints[$state])
  }
  W "player\hud\$state.mcfunction" $lines
}
$fontJson = @'
{
  "providers": [
    { "type": "space", "advances": { "__PAD__": 101, "__NEG__": -1, "__BARW__": 182 } },
    { "type": "bitmap", "file": "stamina:font/stamina_icons.png", "ascent": -26, "height": 9, "chars": ["__ICONS__"] }
  ]
}
'@
WriteFile (Join-Path $pack 'assets\stamina\font\hud.json') ($fontJson.Replace("`r`n", "`n").Replace('__PAD__', "$($u)e000").Replace('__NEG__', "$($u)e001").Replace('__BARW__', "$($u)e002").Replace('__ICONS__', "$($u)e010$($u)e011$($u)e012"))

# 9x9 lightning bolt sheet (full, half, empty). O = outline, W = fill (tinted by the text colour). Rightmost
# opaque column is 7, so each glyph advances 9px.
$shape = @('....OOOO.', '...OWWWO.', '..OWWWO..', '.OWWWOOO.', 'OWWWWWWO.', '.OOOWWO..', '...OWO...', '..OWO....', '..OO.....')
$sheet = New-Object System.Drawing.Bitmap 27, 9, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$outline = [System.Drawing.Color]::FromArgb(255, 0, 0, 0); $dark = [System.Drawing.Color]::FromArgb(255, 58, 58, 58)
for ($g = 0; $g -lt 3; $g++) {
  for ($y = 0; $y -lt 9; $y++) { for ($x = 0; $x -lt 9; $x++) {
    $p = $shape[$y][$x]
    if ($p -eq 'O') { $sheet.SetPixel($g * 9 + $x, $y, $outline) }
    elseif ($p -eq 'W') {
      $lit = ($g -eq 0) -or ($g -eq 1 -and $x -ge 4)
      $v = if ($y -le 3) { 255 } else { 205 }
      $sheet.SetPixel($g * 9 + $x, $y, $(if ($lit) { [System.Drawing.Color]::FromArgb(255, $v, $v, $v) } else { $dark }))
    }
  } }
}
SavePng $sheet (Join-Path $pack 'assets\stamina\textures\font\stamina_icons.png')

# The vanilla hunger icons are made transparent (the stamina icons take their place)
foreach ($n in 'food_empty', 'food_half', 'food_full', 'food_empty_hunger', 'food_half_hunger', 'food_full_hunger') {
  SavePng (New-Object System.Drawing.Bitmap 9, 9, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)) (Join-Path $pack "assets\minecraft\textures\gui\sprites\hud\$n.png")
}

# ============================================================ Effect timers (column right of the hotbar)
# Each active effect becomes one row: [+7 space][icon + padding to 10px][+2][mm:ss = 26px][-45 space].
# Every row nets to zero width, so the action-bar centering (and the stamina bar) never moves.
# Row k uses font stamina:fx<k>, whose glyphs are shifted so the row sits 11px above row k-1, starting level
# with the hotbar. Ascent must stay <= glyph height, which caps it at 6 rows.
$effects = @('absorption','bad_omen','blindness','breath_of_the_nautilus','conduit_power','darkness','dolphins_grace',
  'fire_resistance','glowing','haste','health_boost','hero_of_the_village','infested','invisibility','jump_boost',
  'levitation','luck','mining_fatigue','nausea','night_vision','oozing','poison','raid_omen','regeneration',
  'resistance','slow_falling','slowness','speed','strength','trial_omen','unluck','water_breathing','weakness',
  'weaving','wind_charged','wither')
$A7 = [string][char]0xE0F0; $A2 = [string][char]0xE0F1; $B45 = [string][char]0xE0F2; $P6 = [string][char]0xE0F3

# Glyph advance = round(opaque width * 9/18) + 1. Read each vanilla icon's opaque width from the game jar
# (not copied into the pack) and pad every icon to exactly 10px.
$pairs = @()
for ($i = 0; $i -lt $effects.Count; $i++) {
  $e = $effects[$i]
  $bmp = Vanilla-Png "assets/minecraft/textures/mob_effect/$e.png"; $h = $bmp.Height; $aw = 0
  for ($x = $bmp.Width - 1; $x -ge 0 -and $aw -eq 0; $x--) { for ($y = 0; $y -lt $bmp.Height; $y++) { if ($bmp.GetPixel($x, $y).A -ne 0) { $aw = $x + 1; break } } }
  $bmp.Dispose()
  $adv = [int][Math]::Floor(0.5 + $aw * 9.0 / $h) + 1
  $pad = if ($adv -lt 10) { [string][char](0xE0E0 + 10 - $adv) } else { '' }
  $pairs += '"minecraft:' + $e + '":"' + [string][char](0xE100 + $i) + $pad + '"'
}
W 'player\fx\icons.mcfunction' @('# GENERATED: effect id -> HUD icon glyph (+ padding to a fixed 10px)', ('data modify storage stamina:hud icons set value {' + ($pairs -join ',') + '}'))
W 'player\fx\row.mcfunction' @(
  '# GENERATED macro. args: icon, icolor, row, m1, m2, s1, s2, color',
  ('$data modify storage stamina:hud rows append value {text:"' + $A7 + '$(icon)' + $A2 + '",color:"$(icolor)",font:"stamina:fx$(row)",extra:[{text:"$(m1)$(m2):$(s1)$(s2)",color:"$(color)",shadow_color:-12632257},{text:"' + $B45 + '"}]}')
)
# Clock (stamina:player/clock): HH:MM (26px, like a timer) left of the hotbar, level with the first timer row.
# The HUD title's cursor sits at the hotbar's right edge (+91) after the stamina bar; jump to -124, write, jump
# back, so it nets zero width like the timer rows.
W 'player\clock_row.mcfunction' @(
  '# GENERATED macro. args: h1, h2, m1, m2 (digits, or "-")',
  ('$data modify storage stamina:hud rows append value {text:"' + [string][char]0xE0F4 + '",font:"stamina:fx0",extra:[{text:"$(h1)$(h2):$(m1)$(m2)",color:"white",shadow_color:-12632257},{text:"' + [string][char]0xE0F5 + '"}]}')
)
# Without the stamina bar (riding, creative, spectator), a 182px space stands in for it, so the timer rows and
# the clock still start from the hotbar's right edge instead of the middle of the hotbar
W 'player\hud\mounted.mcfunction' @(
  '# GENERATED. No stamina icons (mounted, or in creative/spectator): a space as wide as the bar, then the timer rows',
  ('title @s actionbar [{"text":"' + [string][char]0xE002 + '","font":"stamina:hud"},{"nbt":"rows[]","storage":"stamina:hud","interpret":true,"separator":""}]')
)
# Single-digit minutes: a 6px space in place of the tens digit keeps every row the same width
W 'player\fx\pad_minutes.mcfunction' @('# GENERATED', ('data modify storage stamina:fx args.m1 set value "' + $P6 + '"'))

# Row fonts: spaces, vanilla ascii.png for "0-9 : -" only, and one glyph per effect icon
$nul = "$($u)0000"
$asciiRows = @()
for ($r = 0; $r -lt 16; $r++) {
  if ($r -eq 2) { $row = ($nul * 13) + "$($u)002d" + ($nul * 2) }
  elseif ($r -eq 3) { $row = ''; for ($c = 0x30; $c -le 0x3a; $c++) { $row += $u + ('{0:x4}' -f $c) }; $row += $nul * 5 }
  else { $row = $nul * 16 }
  $asciiRows += '"' + $row + '"'
}
#   (e0f4/e0f5: the clock's jump from the hotbar's right edge to 7px left of its left edge, and back)
$spaceAdv = @(('"' + $u + 'e0f0": 7'), ('"' + $u + 'e0f1": 2'), ('"' + $u + 'e0f2": -45'), ('"' + $u + 'e0f3": 6'), ('"' + $u + 'e0f4": -215'), ('"' + $u + 'e0f5": 189'))
for ($k = 1; $k -le 10; $k++) { $spaceAdv += '"' + $u + ('e0e{0:x}' -f $k) + '": ' + $k }
for ($row = 0; $row -le 5; $row++) {
  $iconAscent = -49 + 11 * $row      # row 0: icon top 16px above the screen bottom
  $prov = @('    { "type": "space", "advances": { ' + ($spaceAdv -join ', ') + ' } }')
  $prov += '    { "type": "bitmap", "file": "minecraft:font/ascii.png", "ascent": ' + ($iconAscent - 1) + ', "chars": [' + ($asciiRows -join ', ') + '] }'
  for ($i = 0; $i -lt $effects.Count; $i++) {
    $prov += '    { "type": "bitmap", "file": "minecraft:mob_effect/' + $effects[$i] + '.png", "ascent": ' + $iconAscent + ', "height": 9, "chars": ["' + $u + ('{0:x4}' -f (0xE100 + $i)) + '"] }'
  }
  WriteFile (Join-Path $pack "assets\stamina\font\fx$row.json") ("{`n  `"providers`": [`n" + ($prov -join ",`n") + "`n  ]`n}`n")
}

# ============================================================ Compass markers and graves on the locator bar
# Waypoint styles stamina:north/east/south/west (stamina:compass/make) and stamina:grave (stamina:grave/waypoint):
# 9x9 dots, a letter or a tombstone, white with a dark outline (the waypoint colour tints them)
$glyphs = [ordered]@{
  north = @('.........', '.##...##.', '.###..##.', '.####.##.', '.##.####.', '.##..###.', '.##...##.', '.........', '.........')
  east  = @('.........', '.#######.', '.##......', '.######..', '.##......', '.##......', '.#######.', '.........', '.........')
  south = @('.........', '..#####..', '.##......', '..####...', '.....##..', '.....##..', '.#####...', '.........', '.........')
  west  = @('.........', '.##...##.', '.##...##.', '.##.#.##.', '.#######.', '.###.###.', '.##...##.', '.........', '.........')
  grave = @('...###...', '..#####..', '.##...##.', '.#.###.#.', '.##.#.##.', '.##.#.##.', '.#######.', '#########', '#########')
  # a skull for hostile mobs on the recovery compass's radar (stamina:compass/radar_on); the eye holes and
  # the gaps between the teeth come out dark from the outline
  hostile = @('.........', '..#####..', '.#######.', '.#..#..#.', '.#..#..#.', '.#######.', '..##.##..', '..#.#.#..', '.........')
  # passive animals: a diamond; friendly mobs (villagers, golems, allays, tamed animals): a heart
  passive = @('.........', '....#....', '...###...', '..#####..', '.#######.', '..#####..', '...###...', '....#....', '.........')
  friendly = @('.........', '.##...##.', '####.####', '#########', '.#######.', '..#####..', '...###...', '....#....', '.........')
}
$white = [System.Drawing.Color]::FromArgb(255, 255, 255, 255); $edge = [System.Drawing.Color]::FromArgb(255, 40, 40, 40)
foreach ($k in $glyphs.Keys) {
  $g = $glyphs[$k]
  $bmp = New-Object System.Drawing.Bitmap(9, 9, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  for ($y = 0; $y -lt 9; $y++) { for ($x = 0; $x -lt 9; $x++) {
    if ($g[$y][$x] -eq '#') { $bmp.SetPixel($x, $y, $white); continue }
    $near = $false
    foreach ($o in @(@(-1, 0), @(1, 0), @(0, -1), @(0, 1))) { $nx = $x + $o[0]; $ny = $y + $o[1]; if ($nx -ge 0 -and $ny -ge 0 -and $nx -lt 9 -and $ny -lt 9 -and $g[$ny][$nx] -eq '#') { $near = $true } }
    if ($near) { $bmp.SetPixel($x, $y, $edge) }
  } }
  SavePng $bmp (Join-Path $pack "assets\stamina\textures\gui\sprites\hud\locator_bar_dot\$k.png")
  WriteFile (Join-Path $pack "assets\stamina\waypoint_style\$k.json") ("{`n  `"sprites`": [`"stamina:$k`"]`n}`n")
}

# ============================================================ Pack meta and icon
# One pack.mcmeta for both halves: the range 97..121 holds the resource pack format (97) and the data pack
# format (121), so each loader accepts it (both are past the formats that also needed the old pack_format field).
WriteFile (Join-Path $pack 'pack.mcmeta') @'
{
  "pack": {
    "description": "Stamina Pack: stamina replaces hunger, food heals, graves, HUD timers, compass and clock",
    "min_format": 97,
    "max_format": 121
  }
}
'@.Replace("`r`n", "`n")
# Pack icon: a gold bolt on dark slate
$ic = New-Object System.Drawing.Bitmap 64, 64, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gr = [System.Drawing.Graphics]::FromImage($ic); $gr.Clear([System.Drawing.Color]::FromArgb(255, 38, 42, 52)); $gr.Dispose()
for ($y = 0; $y -lt 9; $y++) { for ($x = 0; $x -lt 9; $x++) {
  $p = $shape[$y][$x]; if ($p -eq '.') { continue }
  $c = if ($p -eq 'O') { [System.Drawing.Color]::FromArgb(255, 20, 16, 8) } else { [System.Drawing.Color]::FromArgb(255, 255, 209, 59) }
  for ($dy = 0; $dy -lt 6; $dy++) { for ($dx = 0; $dx -lt 6; $dx++) { $ic.SetPixel(5 + $x * 6 + $dx, 5 + $y * 6 + $dy, $c) } }
} }
$ic.Save((Join-Path $pack 'pack.png'), [System.Drawing.Imaging.ImageFormat]::Png); $ic.Dispose()
$vj.Dispose()

# ============================================================ Zip (forward-slash entry names)
function Zip-Pack($dir, $zip) {
  if (Test-Path $zip) { [IO.File]::Delete($zip) }
  $z = [IO.Compression.ZipFile]::Open($zip, 'Create')
  try {
    Get-ChildItem $dir -Recurse -File | ForEach-Object {
      $rel = $_.FullName.Substring($dir.Length + 1).Replace('\', '/')
      [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($z, $_.FullName, $rel)
    }
  } finally { $z.Dispose() }
}
Zip-Pack $pack (Join-Path $proj 'stamina_pack.zip')
Write-Host "Built stamina_pack.zip"
