# DELTARUNE: SHELTER

*A fan-made, non-canon DELTARUNE Chapter 6 concept.*

DELTARUNE: SHELTER is being built as a **native desktop game with Godot 4**, not as a browser game. The project is unofficial and is not affiliated with or endorsed by Toby Fox.

## Current build

The native Godot project is the main game. It currently contains an early playable slice with:

- The Hometown path and bunker entrance
- Kris and Susie opening sequence
- The mirror room and the book marked **ENTRY 1**
- A scene with Ralsei
- A first boss prototype against **YOU**
- ACT choices, a FIGHT condition, and a dodge phase

The visuals and battle systems are still prototypes. More rooms, enemies, the full PATIENCE SOUL mechanic, and later bosses are not finished yet.

## Run the game in Godot

1. Install **Godot 4.3 or a compatible Godot 4.x release**.
2. Clone or download this repository.
3. Open the folder containing `project.godot` in Godot.
4. Press **F6** to run the main scene, or **F5** to run the project.

## Windows desktop build

A Windows export preset and GitHub Actions workflow are included.

- Workflow: [Build Windows Game](.github/workflows/windows-game.yml)
- Export preset: [export_presets.cfg](export_presets.cfg)

To create a Windows build, open the repository's **Actions** tab, select **Build Windows Game**, and choose **Run workflow**. When the job succeeds, download the `DELTARUNE-SHELTER-Windows` artifact from that workflow run. The artifact should contain `SHELTER.exe` and its game data file.

**The Windows build has not yet been verified.** The first workflow run will show whether the export environment needs adjustments.

## Controls

- **Move:** WASD or arrow keys
- **Confirm / interact:** Z, Enter, or Space
- **Back in battle menus:** X or Escape
- **Battle dodge:** WASD or arrow keys
- **Battle menu selection:** Up and Down, then confirm

## Hints

1. The bunker entrance is down the path. Walk toward it and interact.
2. Reflections are worth paying attention to.
3. Read **ENTRY 1** carefully.
4. In the boss encounter, ACT can change what happens next.
5. Rushing straight into FIGHT is not always effective.
6. During the enemy turn, keep moving and watch the incoming pattern.

## Project structure

- `project.godot` — Godot project settings
- `scenes/main.tscn` — main game scene
- `scripts/main.gd` — game logic and prototype drawing
- `export_presets.cfg` — Windows desktop export preset
- `.github/workflows/windows-game.yml` — automated Windows build

## Fan project and assets

DELTARUNE and its original characters and setting belong to their respective rights holders. This is an unofficial fan-made project. Use original artwork, music, writing, and other assets, or assets that you have permission to use. Do not present this project as an official DELTARUNE release.

## Contributing

Ideas, bug reports, and constructive feedback are welcome. Please label suggestions as story, gameplay, art/audio, or technical feedback.
