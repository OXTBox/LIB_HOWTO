# LIB_HOWTO

Step-by-step game building instructions for Vibecode3D and xt3d, one small step at a time:
**"Adding this function and/or this handler: makes this happen."** Approved by the owner
2026-11-14.

| Where | What |
|---|---|
| `PLAN.md` | the stack layout and the order of work (for review) |
| `topics/<id>_<Title>/` | one fundamental (the stack's left-side list): `step_<n>.txt` (words), `step_<n>.livecodescript` (the whole card script after that step; its header says what it adds) |
| `games/<Game>/` | later: how a real game was built, cut into the same kind of steps |
| `tests/play_step.sh` | plays one step on the REAL engine (Simple_Test1's window, its script swapped), lists the scene, takes a picture |
| `livecode/` | the HOWTO stack and its syntax-colour library |

## How it is made
1. Spark (the local model) writes the big outline: `../LIB_SPARK/howto/` -> `OUTLINE.md`.
2. Claude and the owner review it; the approved outline is copied here as `OUTLINE.md`.
3. Claude writes each step's code, as small as it can be to get something on screen, and plays
   it on the real engine (`tests/play_step.sh`). Then Spark writes the step's words from the
   outline and that code (`../LIB_SPARK/howto/run_steps.py`); Claude checks them.

## Done (19 Nov 2026, branch howto-steps)
All 18 topics, 92 steps. Every step's code was played on the real engine (the Game Player's
engine, `tests/play_step.sh`) and its picture looked at; `tests/check_calls.py` says every
engine call is in pure Engine 1 too; the xTalk lint is clean. Spark wrote all the words; Claude
read every one against the code and fixed 38. The xt3d bench was NOT tried.

Tools: `tests/play_step.sh` (play a step, list the scene, picture, test calls, read a function),
`tests/check_calls.py` (engine calls in both engine scripts), `tools/steps.py` (writes step files;
the step files are the source), `../LIB_SPARK/howto/run_steps.py` (Spark's words).

### Where the code differs from the outline (the code is right; OUTLINE.md has the main ones)
- 01-06: the camera sits at 0,0,0, so shapes stand at z 400-600, not 0. `Entity.Spawn` is a
  function (`put`/`get` it). 02: the floor at y 120, the row at z 420 (not edge-on).
- 03 step 5: the face is added and the house turns (in wire view a face looks like its edges).
- 06 and later: a colour change kills the cube and spawns a new one (`Entity.SetColor` is not in
  Engine 1). Keys go through a `<Prefix>.Keys()` test hook from topic 06 on, so tests can drive them.
- 07 step 5: a yellow arrow floats over the rock under the mouse (`mouseMove` + `ScreenToCameraRay`
  with move 0, scale 1); the rock itself does not change colour.
- 08: the scene sits around 0,0,0; step 4 circles the camera (Cam.LookAtMiddle) instead of only
  turning gCameraYaw. Raw `Engine.SetCam` / gCameraYaw / gCameraPitch (Camera.SetLook is xt3d-only).
- 09: help text at gViewBottom - 50 (above the engine's status line).
- 10: steps 1-3 pass through on purpose; step 5 starts again from step 1 with a distance check.
- 11: Space calls Fx.Burst, Return calls Fx.Blast, a new cube comes back a second later; step 4
  sets "explode" back to "derez" in Game.OnStop.
- 12: a small catch game (paddle, gems, hazards); `Catch.State`, not `Game.State`.
- 13: the level table is cubes (count, spin, colour) and a click goes to the next level; steps 3-6
  are a maze card (Bit.Maze, Map.BlockEdges, Maze.SegmentsToMesh; step 6 reads amazing_couple
  maze_0N.cellmap). Libraries are found with `Game.FindFile` (as every LIB_GAMES game does).
- 14: the wing is tipped toward you; meshes are swapped by renaming the object's mesh in
  gSceneObjects (`Entity.SetMesh` is not in Engine 1).
- 15: the clip Animazoo_gangster_walk + Animazoo_hands_on_hips, scene at z 150.
- 16: sample sounds in topics/16_Sound/Sounds/zap. In the Game Player sound is silent:
  LIB_SYSTEM/ISSUES 0013 (Audio.Init needs a "Viewport" group).
- 17: a cube driven by keys; steps 3 and 5 add no code, only how to take notes / run a test.

## Look
Dark mode. Topic list on the left on every card; the Vibecode3D and xt3d viewports share the
right side (a toggle picks the engine); the step's code in a scrolling, syntax-coloured field
at the bottom right.
