# Phantasy Star Nova (PCSG00351) patches and cheats for Vita3K

Memory patches and cheats for **Phantasy Star Nova** (ファンタシースター ノヴァ, JP, `PCSG00351`) on **Vita3K**, tested on Vita3K Plus v1.4 (PC, OpenGL) and Vita3K Plus on Android (Vulkan).

| Patch | What it does |
|---|---|
| `PCSG00351_60FPS.txt` | Unlocks 60 fps (the game caps its frame manager at 30) |
| `PCSG00351_CAMERA.txt` | Right-stick camera sensitivity 65%, meant for use with the 60 fps patch |
| `PCSG00351_BLOOM20.txt` | Bloom at 20% of stock strength (brightness is preserved) |
| `PCSG00351_BLOOM0.txt` | Bloom completely off (colours stay normal) |

`cheats/PCSG00351.psv` holds the same effects as toggleable cheats in Vita3K (**Manage Cheats**), plus **Bloom 50%** and a **Bloom 100% (stock)** entry that restores the original code.

> **Game version 1.05 only.** Vita3K logs `Version: 1.05` when the game starts. The addresses do not match v1.00 and will crash or do nothing there.
> Patches change the game's code in memory at load time; nothing here contains game data.

## Patches vs cheats

- **Patch files** (`patches/*.txt`) are applied automatically every time the game launches. Easiest to set and forget.
- **Cheats** (`cheats/PCSG00351.psv`) are ticked in Vita3K's Manage Cheats menu and can be switched on and off. Use these to try different bloom strengths.
- Don't enable a bloom patch file and a bloom cheat at the same time, and tick only one bloom cheat at a time. They change the same spot.

## PC (Windows)

1. Find your Vita3K folder (the one with `Vita3K.exe`).
2. Copy the files you want from `patches/` into a folder called `patch` next to `Vita3K.exe` (create it if needed).
3. For cheats, copy `cheats/PCSG00351.psv` into the `cheats` folder next to `Vita3K.exe`.
4. Launch the game. Open `vita3k.log` in the same folder and check for a line like
   `Found 2 patches for titleid PCSG00351` followed by `Patching segment 0 at offset ...` lines.
5. To switch a patch off without deleting it, rename `X.txt` to `X.txt.off` (or use `tools/toggle-pc.bat` placed next to `Vita3K.exe`).

## Android (Vita3K Plus)

1. Use the **Vulkan** renderer (Settings -> Renderer). The game did not start for us with OpenGL on Android.
2. Copy the patch files to
   `Android/data/org.vita3kplus.emulator/files/patch/`
   (on a PC: `adb push patches\PCSG00351_BLOOM20.txt /sdcard/Android/data/org.vita3kplus.emulator/files/patch/`).
   Cheats go in `.../files/cheats/`. If your Vita3K build uses a different package name, replace `org.vita3kplus.emulator`.
   Newer Android versions hide `Android/data` from file managers; adb is the reliable way.
3. Launch the game and check `.../files/vita3k.log` for `Found N patches for titleid PCSG00351`.
4. `tools/toggle-android.bat` turns a patch on or off over adb.

### Important: line endings

Patch and cheat files **must use LF line endings**. Vita3K on Android treats a trailing carriage return (Windows CRLF) as an extra data byte, which overwrites the next instruction and crashes the game on launch. This repo enforces LF through `.gitattributes`. If you edit a file on Windows, save it with LF endings. A correct run logs the right number of values, for example `offset 0xA7F61A with 8 values`; 9 means a stray CR.

## Troubleshooting

- **No "Found N patches" line:** the file is in the wrong folder, is not named `PCSG00351_<anything>.txt`, or the game version is not 1.05.
- **Patch count is right but nothing changes:** you may be running a different game version; check `Version:` in the log.
- **Game won't open on Android after adding a patch:** check the value counts in the log (see line endings above), then remove the newest patch and relaunch.
- **Bloom patch seems to do nothing as a cheat while the game is running:** untick and tick it again, or use the patch file and restart the game.

## How the bloom patch works

The post-process combiner builds a blend constant from two weights that sum to 1: scene `0.636` and bloom `0.364`. The game recomputes these every frame, so changing them in memory does not stick. The code that loads them (v1.05 `0x81a7f61a`) is patched instead:

- **0%:** loads scene `1.0`, bloom `0.0` directly (8 bytes, in place).
- **20% / 50%:** a jump into a small code cave (padding at `0x81f40920`) computes `bloom = stock x k` and `scene = 1 - bloom`, then jumps back to `0x81a7f622`.

Disabling the game's own bloom flag instead made the screen render cyan, which is why the strength is changed rather than the effect being turned off. Notes on each patch are in the comments at the top of every file.

## Notes

- Tested in-game: 60 fps, camera, Bloom 0% (patch file, PC) and Bloom 20% (cheat on PC, patch file on Android). Bloom 50% has not been tested yet.
- Offsets are relative to segment 0 of the game's `eboot.bin`, which Vita3K loads at `0x81000000`.
