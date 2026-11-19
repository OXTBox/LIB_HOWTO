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

## Done so far (19 Nov 2026, branch howto-steps)
- 01 Game card and loop (5 steps) and 02 Shapes: built-in meshes (5 steps): code played on the
  real engine with pictures checked; words by Spark, 3 lines fixed by Claude.
- Found while testing: a shape at z 0 sits inside the camera; `Entity.Spawn` must be called as a
  function. Both are now pitfalls in the outline.
4. The stack reads everything from these text files: fixing a lesson never means editing the stack.

## Look
Dark mode. Topic list on the left on every card; the Vibecode3D and xt3d viewports share the
right side (a toggle picks the engine); the step's code in a scrolling, syntax-coloured field
at the bottom right.
