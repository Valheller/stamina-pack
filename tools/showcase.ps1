# Renders showcase.png (1920x1080): a feature overview of the Stamina Pack, drawn entirely from game art (tools\gfx.ps1).
# Run after tools\build.ps1:  powershell -ExecutionPolicy Bypass -File tools\showcase.ps1

. (Join-Path $PSScriptRoot 'gfx.ps1')
Backdrop
Title 'STAMINA PACK' 'Survival, reworked for Minecraft 26.3: stamina, healing food, graves and a smarter HUD'

# ---- Feature panels: 4 x 2
$pw = 427; $ph = 360; $gap = 30; $x0 = 60; $rows = @(255, 645)

# Small sprites reused below
$heart = Jar-Png 'gui/sprites/hud/heart/full'
$bar = Jar-Png 'gui/sprites/hud/locator_bar_background'
function Dot($name, $hex, $cx, $cy) { $d = Pack-Png "gui/sprites/hud/locator_bar_dot/$name"; Sprite $d ($cx - 13) ($cy - 13) 3 (TintOf (Rgb $hex)); $d.Dispose() }
# The locator bar background is a nine-slice sprite (12x5: 5px caps, a stretchable middle): drawn 182px wide, x2
function LocBar($cx, $cy) {
  $x = $cx - 182; $y = $cy - 5
  Sprite $bar $x $y 2 $null 0 0 5 5
  $g.DrawImage($bar, (New-Object System.Drawing.Rectangle ([int]($x + 10)), ([int]$y), 344, 10), 5, 0, 2, 5, [System.Drawing.GraphicsUnit]::Pixel)
  Sprite $bar ($x + 354) $y 2 $null 7 0 5 5
}

# The gravestone seen from the front, rebuilt from its model (stamina:grave): stone, carved face, top step, mound
function Grave-Front {
  $and = Jar-Png 'block/polished_andesite'; $face = Pack-Png 'block/grave_stone'; $cd = Jar-Png 'block/coarse_dirt'
  $b = New-Object System.Drawing.Bitmap 16, 16, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  # screen column c shows model x = 15 - c, row r shows model y = 15 - r; a north face's texture pixel is (c, r)
  $parts = @(@{ x = 3, 13; y = 0, 2; t = $and }, @{ x = 4, 12; y = 2, 14; t = $face }, @{ x = 5, 11; y = 14, 15; t = $and },
    @{ x = 4, 12; y = 0, 1; t = $cd; side = $true }, @{ x = 5, 11; y = 1, 2; t = $cd; side = $true })
  foreach ($p in $parts) { for ($mx = $p.x[0]; $mx -lt $p.x[1]; $mx++) { for ($my = $p.y[0]; $my -lt $p.y[1]; $my++) {
    $c = 15 - $mx; $r = 15 - $my; $b.SetPixel($c, $r, $p.t.GetPixel($c, $r)) } } }
  $and.Dispose(); $face.Dispose(); $cd.Dispose(); $b
}

$features = @(
  @{ t = 'Stamina replaces hunger'; d = 'Sprinting and jumping tire you out. Rest a moment, or sneak to catch your breath. Fighting, mining and armor never cost stamina.'
     icon = { param($cx, $cy)
       $gt = TintOf $goldBolt
       for ($i = 0; $i -lt 10; $i++) {
         $x = $cx - 162 + $i * 32
         if ($i -lt 3) { Sprite $icons $x ($cy - 18) 4 $null 18 0 9 9 } elseif ($i -eq 3) { Sprite $icons $x ($cy - 18) 4 $gt 9 0 9 9 } else { Sprite $icons $x ($cy - 18) 4 $gt 0 0 9 9 }
       } } },
  @{ t = 'Food heals'; d = 'Every food heals on the spot and restores stamina. No potion effects and no new foods: each name shows what it gives.'
     icon = { param($cx, $cy)
       $beef = Jar-Png 'item/cooked_beef'; Sprite $beef ($cx - 150) ($cy - 48) 6; $beef.Dispose()
       Text '+4' ($cx - 10) ($cy - 48) 4 (Rgb 'FF5555'); Sprite $heart ($cx + 52) ($cy - 50) 4
       Text '+30%' ($cx - 10) ($cy + 10) 4 (Rgb 'FFFF55'); Sprite $icons ($cx + 112) ($cy + 8) 4 (TintOf $goldBolt) 0 0 9 9 } },
  @{ t = 'Graves'; d = 'Die and your items and XP rest under a gravestone, while your tools and armor stay with you. Click the grave to get everything back.'
     icon = { param($cx, $cy) $gf = Grave-Front; Sprite $gf ($cx - 72) ($cy - 82) 9; $gf.Dispose() } },
  @{ t = 'Effect timers'; d = 'Every active effect shows its exact time left beside the hotbar, turning red as it runs out.'
     icon = { param($cx, $cy)
       $list = @(@('speed', '03:45', 'FFFFFF'), @('night_vision', '08:00', 'FFFFFF'), @('poison', '00:07', 'FF5555'))
       for ($i = 0; $i -lt 3; $i++) {
         $e = Jar-Png "mob_effect/$($list[$i][0])"; $y = $cy - 70 + $i * 48
         Sprite $e ($cx - 100) $y 2; $e.Dispose(); Text $list[$i][1] ($cx - 44) ($y + 6) 4 (Rgb $list[$i][2]) } } },
  @{ t = 'Compass HUD'; d = 'Hold a compass and the locator bar shows north, east, south and west, other players, and your graves.'
     icon = { param($cx, $cy)
       $cp = Jar-Png 'item/compass_00'; Sprite $cp ($cx - 40) ($cy - 86) 5; $cp.Dispose()
       LocBar $cx ($cy + 40); Dot 'west' 'FFFFFF' ($cx - 140) ($cy + 40); Dot 'north' 'FF5555' $cx ($cy + 40); Dot 'grave' 'D8D8D8' ($cx + 62) ($cy + 40); Dot 'east' 'FFFFFF' ($cx + 140) ($cy + 40) } },
  @{ t = 'Mob radar'; d = 'A recovery compass also marks every mob within 32 blocks: hostile, passive and friendly, each with its own marker.'
     icon = { param($cx, $cy)
       $cp = Jar-Png 'item/recovery_compass_00'; Sprite $cp ($cx - 40) ($cy - 86) 5; $cp.Dispose()
       LocBar $cx ($cy + 40); Dot 'hostile' 'FF5555' ($cx - 120) ($cy + 40); Dot 'passive' '55FF55' ($cx - 30) ($cy + 40); Dot 'friendly' '55FFFF' ($cx + 60) ($cy + 40); Dot 'hostile' 'FF5555' ($cx + 140) ($cy + 40) } },
  @{ t = 'Exact time'; d = 'Hold a clock to read the time of day in 24-hour format, right beside your hotbar.'
     icon = { param($cx, $cy)
       $ck = Jar-Png 'item/clock_00'; Sprite $ck ($cx - 150) ($cy - 48) 6; $ck.Dispose()
       Text '19:00' ($cx - 30) ($cy - 24) 7 $white } },
  @{ t = 'Broken, not lost'; d = 'Worn-out tools, weapons and armor break instead of vanishing. Repair them and they come back, enchantments and all.'
     icon = { param($cx, $cy)
       $sw = Jar-Png 'item/diamond_sword'; Sprite $sw ($cx - 170) ($cy - 48) 6; $sw.Dispose()
       Text '>' ($cx - 12) ($cy - 16) 5 $dgray
       $bs = Pack-Png 'item/broken/diamond_sword'; Sprite $bs ($cx + 74) ($cy - 48) 6; $bs.Dispose() } }
)
for ($i = 0; $i -lt $features.Count; $i++) {
  $f = $features[$i]; $px = $x0 + ($i % 4) * ($pw + $gap); $py = $rows[[Math]::Floor($i / 4)]
  Panel $px $py $pw $ph
  & $f.icon ($px + $pw / 2) ($py + 105)
  Text-Center $f.t ($px + $pw / 2) ($py + 206) 3 (Rgb 'FFFF55')
  $ly = $py + 248
  foreach ($l in (Wrap $f.d ($pw - 50) 2)) { Text-Center $l ($px + $pw / 2) $ly 2 $gray; $ly += 22 }
}

# ---- Footer
Text-Center 'No new mobs, items or recipes  -  one zip works as both datapack and resource pack  -  multiplayer ready' ($CanvasW / 2) 1020 2 $dgray
Text-Center 'Disclaimer: this pack was fully vibe coded (written entirely by AI)' ($CanvasW / 2) 1048 2 (Rgb '5E5E5E')

Save-Canvas 'showcase.png'
