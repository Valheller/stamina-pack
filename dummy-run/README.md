# Dummy Run

A 3D take on Happy Wheels that runs in the browser. You drive a crash-test dummy in a rocket-powered shopping cart along an elevated test track. The dummy is a ragdoll: hard hits knock it out of the cart and pop its limbs (or head) off.

Open `index.html` in a browser. It loads three.js 0.160.0 and cannon-es 0.20.0 from jsDelivr, so it needs a network connection. There's no build step.

## Track

Downhill start, boost pad, a field of FRAGILE crates, a kicker over a spike pit, three wrecking balls, a minefield, a 4 m wide bridge with two sweeper arms, and a final ramp jump to the finish flag. Three checkpoints along the way.

## Controls

| Key | Action |
| --- | --- |
| W / ↑ | Gas. In the air: lean forward |
| S / ↓ | Brake, then reverse. In the air: lean back |
| A D / ← → | Steer. In the air: roll |
| Space | Hop |
| Shift | Rocket boost (refills slowly) |
| Z | Bail out of the cart |
| R | Retry from the last checkpoint (the timer keeps running) |
| T | Restart the track |
| C | Cycle chase / side / wide camera |
| M | Sound on or off |
| P / Esc | Pause |

On touch screens, on-screen buttons replace the keyboard.

## Notes

- The dummy dies if its head pops off, its torso hits something hard enough, it lands torso or head first on the spikes, or it falls off the track. It can lose arms and legs and still finish.
- Best time is saved in the browser's localStorage.
- The `<!--wrapper-->` comments mark the document wrapper (doctype, `<head>`, `<body>`). Removing those regions gives a body-only fragment for hosts that add their own wrapper.
- `window.__dummy` exposes the game state and a `simulate(dt)` step for automated testing.
