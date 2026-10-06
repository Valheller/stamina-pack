# Renders logo.png (512x512): the project logo for upload pages - the gold stamina bolt over the name, on the
# dark dirt backdrop inside a tooltip-style frame, with an "AI" badge in the top-right corner (the pack was
# written entirely by AI). Same drawing kit as the other graphics (tools\gfx.ps1).
# Run after tools\build.ps1:  powershell -ExecutionPolicy Bypass -File tools\logo.ps1

$CanvasW = 512; $CanvasH = 512
. (Join-Path $PSScriptRoot 'gfx.ps1')

# Backdrop: darkened dirt, then the tooltip frame inset a little
$dirt = Jar-Png 'block/dirt'; $dk = Tint 0.25 0.25 0.25
for ($y = 0; $y -lt $CanvasH; $y += 64) { for ($x = 0; $x -lt $CanvasW; $x += 64) { Sprite $dirt $x $y 4 $dk } }
$dirt.Dispose()
Panel 12 12 488 488

# The bolt (stamina_icons glyph 0: 9x9, its lit columns 0-7), big and centred, coloured like the HUD's full
# icon. Its black outline would vanish on the dark frame, so it's redrawn in dark amber to keep the silhouette.
$bolt = New-Object System.Drawing.Bitmap 9, 9, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
for ($y = 0; $y -lt 9; $y++) { for ($x = 0; $x -lt 9; $x++) {
  $c = $icons.GetPixel($x, $y); if ($c.A -eq 0) { continue }
  if ($c.R -lt 30) { $bolt.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, 120, 72, 0)) }
  else { $k = $c.R / 255.0; $bolt.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, [int](255 * $k), [int](209 * $k), [int](59 * $k))) }
} }
$s = 30
Sprite $bolt ((512 - 8 * $s) / 2) 54 $s
$bolt.Dispose()

# The name
Text-Center 'STAMINA' 256 344 8 $gold
Text-Center 'PACK' 256 424 5 $gray

# "AI" badge, top right: a small dark tooltip box
Panel 392 24 96 66
Text-Center 'AI' 441 39 5 $white

Save-Canvas 'logo.png'
