# Renders install_guide.png (1920x1080): how to install the Stamina Pack, in the same style as showcase.png
# (tools\gfx.ps1). Run after tools\build.ps1:  powershell -ExecutionPolicy Bypass -File tools\install_guide.ps1

. (Join-Path $PSScriptRoot 'gfx.ps1')
Backdrop
Title 'HOW TO INSTALL' 'One file, two folders: stamina_pack.zip is both the datapack and the resource pack'

# A path or command in a dark box, centred on $cx
function Path-Box($text, $cx, $y, $color = $white) {
  $w = (Text-Width $text 2) + 40
  Inset ($cx - $w / 2) $y $w 40
  Text-Center $text $cx ($y + 12) 2 $color
}
# Lines of gray text, centred, wrapped to the panel
function Lines($text, $cx, $y, $maxW, $color = $gray) {
  foreach ($l in (Wrap $text $maxW 2)) { Text-Center $l $cx $y 2 $color; $y += 22 }
  $y
}
function Step($n, $title, $px, $py, $pw) {
  Text $n ($px + 30) ($py + 26) 8 $gold
  Text $title ($px + 100) ($py + 44) 3 $yellow
}

# ---- Three steps
$pw = 580; $ph = 430; $py = 250
$xs = @(60, 670, 1280)

# 1: the zip
$px = $xs[0]; $cx = $px + $pw / 2
Panel $px $py $pw $ph; Step '1' 'Get the zip' $px $py $pw
$icon = New-Object System.Drawing.Bitmap (Join-Path $proj 'pack\pack.png'); Sprite $icon ($cx - 64) ($py + 115) 2; $icon.Dispose()
Path-Box 'stamina_pack.zip' $cx ($py + 268)
[void](Lines 'Keep it zipped. The same file is both the datapack and the resource pack, so it goes in two places.' $cx ($py + 330) ($pw - 70))

# 2: datapack
$px = $xs[1]; $cx = $px + $pw / 2
Panel $px $py $pw $ph; Step '2' 'Add the datapack' $px $py $pw
$grass = Jar-Png 'block/grass_block_side'; Sprite $grass ($cx - 48) ($py + 112) 6; $grass.Dispose()
$y = Lines 'New world: Create World > More > Data Packs, then drag the zip into the window.' $cx ($py + 228) ($pw - 70) $white
$y = Lines 'Existing world: copy it into' $cx ($y + 10) ($pw - 70)
Path-Box '.minecraft/saves/<world>/datapacks/' $cx ($y + 4)
[void](Lines 'then type /reload in game.' $cx ($y + 56) ($pw - 70))

# 3: resource pack
$px = $xs[2]; $cx = $px + $pw / 2
Panel $px $py $pw $ph; Step '3' 'Add the resource pack' $px $py $pw
$paint = Jar-Png 'item/painting'; Sprite $paint ($cx - 48) ($py + 112) 6; $paint.Dispose()
$y = Lines 'Copy the same zip into' $cx ($py + 228) ($pw - 70)
Path-Box '.minecraft/resourcepacks/' $cx ($y + 4)
[void](Lines 'Then Options > Resource Packs, and move Stamina Pack to the Selected side. It draws the stamina bar, timers, compass markers and gravestones.' $cx ($y + 58) ($pw - 70) $white)

# ---- Below: checking it, and servers
$py2 = 712; $ph2 = 278; $pw2 = 885

# Check it worked: the chat line on load, and the bolts where the hunger bar was
$px = 60; $cx = $px + $pw2 / 2
Panel $px $py2 $pw2 $ph2
Text-Center 'Check it worked' $cx ($py2 + 30) 3 $yellow
$msg1 = '[Stamina] '; $msg2 = 'Loaded. Hunger is now stamina; food heals.'
$mw = (Text-Width ($msg1 + $msg2) 2) + 40
$bx = $cx - $mw / 2
$chat = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(150, 0, 0, 0)); $g.FillRectangle($chat, $bx, ($py2 + 84), $mw, 36); $chat.Dispose()
Text $msg1 ($bx + 20) ($py2 + 94) 2 $gold
Text $msg2 ($bx + 20 + (Text-Width $msg1 2) + 4) ($py2 + 94) 2 $gray
for ($i = 0; $i -lt 10; $i++) { $x = $cx - 162 + $i * 32; if ($i -lt 2) { Sprite $icons $x ($py2 + 148) 4 $null 18 0 9 9 } else { Sprite $icons $x ($py2 + 148) 4 (TintOf $goldBolt) 0 0 9 9 } }
[void](Lines 'This appears in chat, and gold stamina bolts replace the hunger bar.' $cx ($py2 + 205) ($pw2 - 90))

# Servers
$px = 975; $cx = $px + $pw2 / 2
Panel $px $py2 $pw2 $ph2
Text-Center 'Playing on a server' $cx ($py2 + 30) 3 $yellow
$cb = Jar-Png 'block/command_block_front'; Sprite $cb ($px + 50) ($py2 + 96) 6 $null 0 0 16 16; $cb.Dispose()
$tx = $px + 180
Text 'Put the zip in the server world''s datapacks folder,' $tx ($py2 + 92) 2 $white
Text 'then offer it to players in server.properties:' $tx ($py2 + 116) 2 $white
Inset $tx ($py2 + 148) 640 68
Text 'resource-pack=<download link to the zip>' ($tx + 18) ($py2 + 158) 2 $green
Text 'require-resource-pack=true' ($tx + 18) ($py2 + 186) 2 $green
Text 'Players get the resource side when they join.' $tx ($py2 + 232) 2 $gray

# ---- Footer
Text-Center 'To remove it: run /function stamina:uninstall, then delete the zip from both folders' ($CanvasW / 2) 1018 2 $dgray
Text-Center 'Disclaimer: this pack was fully vibe coded (written entirely by AI). Back up your world first.' ($CanvasW / 2) 1046 2 (Rgb '5E5E5E')

Save-Canvas 'install_guide.png'
