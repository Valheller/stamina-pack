# Shared drawing kit for the pack's graphics (tools\showcase.ps1, tools\install_guide.ps1): a 1920x1080 canvas,
# Minecraft's own pixel font (ascii.png) and sprites from the 26.3 client jar, this pack's textures (pack\assets),
# tooltip-style panels and the dark dirt backdrop. Dot-source it, draw, then call Save-Canvas.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing, System.IO.Compression, System.IO.Compression.FileSystem

$proj = Split-Path $PSScriptRoot -Parent
$assets = Join-Path $proj 'pack\assets'
$vj = [IO.Compression.ZipFile]::OpenRead((Join-Path $env:APPDATA '.minecraft\versions\26.3\26.3.jar'))
function Jar-Png($path) {
  $ms = New-Object IO.MemoryStream
  $s = $vj.GetEntry("assets/minecraft/textures/$path.png").Open(); $s.CopyTo($ms); $s.Close()
  New-Object System.Drawing.Bitmap ([System.Drawing.Image]::FromStream($ms))
}
function Pack-Png($path) { New-Object System.Drawing.Bitmap (Join-Path $assets "stamina\textures\$path.png") }
function Rgb($hex) { [System.Drawing.Color]::FromArgb(255, [Convert]::ToInt32($hex.Substring(0, 2), 16), [Convert]::ToInt32($hex.Substring(2, 2), 16), [Convert]::ToInt32($hex.Substring(4, 2), 16)) }

# Canvas size: 1920x1080 unless the caller set $CanvasW/$CanvasH before dot-sourcing
# (not "W": PowerShell names ignore case, and $w is used below)
if (-not $CanvasW) { $CanvasW = 1920 }; if (-not $CanvasH) { $CanvasH = 1080 }
$img = New-Object System.Drawing.Bitmap $CanvasW, $CanvasH, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($img)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None

# Text colours, as the game's formatting codes have them
$gold = Rgb 'FFAA00'; $goldBolt = Rgb 'FFD13B'; $white = Rgb 'FFFFFF'; $yellow = Rgb 'FFFF55'
$gray = Rgb 'AAAAAA'; $dgray = Rgb '7E7E7E'; $green = Rgb '55FF55'; $aqua = Rgb '55FFFF'; $red = Rgb 'FF5555'

# A colour multiply (r, g, b, a factors), the way the game tints white sprites and text
function Tint($r, $gg, $b, $a = 1.0) {
  $m = New-Object System.Drawing.Imaging.ColorMatrix
  $m.Matrix00 = $r; $m.Matrix11 = $gg; $m.Matrix22 = $b; $m.Matrix33 = $a; $m.Matrix44 = 1
  $ia = New-Object System.Drawing.Imaging.ImageAttributes; $ia.SetColorMatrix($m); $ia
}
function TintOf($color, $k = 1.0) { Tint ($color.R / 255.0 * $k) ($color.G / 255.0 * $k) ($color.B / 255.0 * $k) }
# Draw (part of) a sprite at a whole-number scale; $sx..$sh pick a region, $attr tints it
function Sprite($bmp, $x, $y, $s, $attr = $null, $sx = 0, $sy = 0, $sw = -1, $sh = -1) {
  if ($sw -lt 0) { $sw = $bmp.Width }; if ($sh -lt 0) { $sh = $bmp.Height }
  $dest = New-Object System.Drawing.Rectangle ([int]$x), ([int]$y), ([int]($sw * $s)), ([int]($sh * $s))
  if ($attr) { $g.DrawImage($bmp, $dest, $sx, $sy, $sw, $sh, [System.Drawing.GraphicsUnit]::Pixel, $attr) }
  else { $g.DrawImage($bmp, $dest, $sx, $sy, $sw, $sh, [System.Drawing.GraphicsUnit]::Pixel) }
}

# ---- Minecraft's font: ascii.png, 16x16 cells of 8x8; a glyph's width is its rightmost lit column + 1
$font = Jar-Png 'font/ascii'
$cw = @{}
for ($c = 32; $c -lt 127; $c++) {
  $cx = ($c % 16) * 8; $cy = [Math]::Floor($c / 16) * 8; $w = 0
  for ($x = 7; $x -ge 0 -and $w -eq 0; $x--) { for ($y = 0; $y -lt 8; $y++) { if ($font.GetPixel($cx + $x, $cy + $y).A -gt 0) { $w = $x + 1; break } } }
  $cw[$c] = if ($c -eq 32) { 3 } else { $w }
}
function Text-Width($text, $s) { $n = 0; foreach ($ch in $text.ToCharArray()) { $n += ($cw[[int]$ch] + 1) }; ($n - 1) * $s }
function Text($text, $x, $y, $s, $color, $shadow = $true) {
  # the game's drop shadow: the same text at a quarter brightness, one (scaled) pixel down and right
  if ($shadow) { $sa = TintOf $color 0.25; $cx0 = $x; foreach ($ch in $text.ToCharArray()) { $c = [int]$ch; Sprite $font ($cx0 + $s) ($y + $s) $s $sa (($c % 16) * 8) ([Math]::Floor($c / 16) * 8) $cw[$c] 8; $cx0 += ($cw[$c] + 1) * $s } }
  $a = TintOf $color
  foreach ($ch in $text.ToCharArray()) { $c = [int]$ch; Sprite $font $x $y $s $a (($c % 16) * 8) ([Math]::Floor($c / 16) * 8) $cw[$c] 8; $x += ($cw[$c] + 1) * $s }
}
function Text-Center($text, $cx, $y, $s, $color) { Text $text ($cx - (Text-Width $text $s) / 2) $y $s $color }
function Wrap($text, $maxW, $s) {
  $lines = @(); $cur = ''
  foreach ($word in $text.Split(' ')) {
    $try = if ($cur) { "$cur $word" } else { $word }
    if ((Text-Width $try $s) -gt $maxW -and $cur) { $lines += $cur; $cur = $word } else { $cur = $try }
  }
  if ($cur) { $lines += $cur }; $lines
}

# ---- Background: the classic dirt menu backdrop, darkened, with a darker band behind the title
function Backdrop {
  $dirt = Jar-Png 'block/dirt'; $dk = Tint 0.25 0.25 0.25
  for ($y = 0; $y -lt $CanvasH; $y += 64) { for ($x = 0; $x -lt $CanvasW; $x += 64) { Sprite $dirt $x $y 4 $dk } }
  $dirt.Dispose()
  $shade = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(90, 0, 0, 0))
  $g.FillRectangle($shade, 0, 0, $CanvasW, 230); $shade.Dispose()
}

# ---- Title: gold, flanked by two stamina bolts, with a gray line under it
$icons = Pack-Png 'font/stamina_icons'
function Title($text, $sub) {
  $tw = Text-Width $text 10
  Text-Center $text ($CanvasW / 2) 46 10 $gold
  Sprite $icons ($CanvasW / 2 - $tw / 2 - 90) 50 8 (TintOf $goldBolt) 0 0 9 9
  Sprite $icons ($CanvasW / 2 + $tw / 2 + 18) 50 8 (TintOf $goldBolt) 0 0 9 9
  Text-Center $sub ($CanvasW / 2) 158 3 $gray
}

# ---- A panel in the style of the game's tooltips: near-black purple with a purple gradient border
$panelBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(238, 16, 0, 16))
function Panel($px, $py, $pw, $ph) {
  $g.FillRectangle($panelBg, $px + 3, $py, $pw - 6, $ph); $g.FillRectangle($panelBg, $px, $py + 3, $pw, $ph - 6)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.Point 0, $py), (New-Object System.Drawing.Point 0, ($py + $ph)), ([System.Drawing.Color]::FromArgb(255, 80, 0, 255)), ([System.Drawing.Color]::FromArgb(255, 40, 0, 127)))
  $g.FillRectangle($grad, $px + 3, $py + 3, $pw - 6, 3); $g.FillRectangle($grad, $px + 3, $py + $ph - 6, $pw - 6, 3)
  $g.FillRectangle($grad, $px + 3, $py + 3, 3, $ph - 6); $g.FillRectangle($grad, $px + $pw - 6, $py + 3, 3, $ph - 6)
  $grad.Dispose()
}
# A dark inset box, like the game's text fields and chat background
function Inset($x, $y, $w, $h) {
  $b = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0, 0, 0)); $g.FillRectangle($b, $x, $y, $w, $h); $b.Dispose()
  $p = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 160, 160, 160)), 3; $g.DrawRectangle($p, $x, $y, $w, $h); $p.Dispose()
}

function Save-Canvas($name) {
  $out = Join-Path $proj $name
  $img.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $img.Dispose(); $font.Dispose(); $icons.Dispose(); $vj.Dispose()
  Write-Host "Wrote $out"
}
