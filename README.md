# LIB_HOWTO

Step-by-step game building instructions for Vibecode3D and xt3d, one small step at a time:
**"Adding this function and/or this handler: makes this happen."** Approved by the owner
2026-11-14.

| Where | What |
|---|---|
| `PLAN.md` | the stack layout and the order of work (for review) |
| `topics/<id>_<Title>/` | one fundamental (the stack's left-side list): `step_<n>.txt` (words), `step_<n>.livecodescript` (the code that step adds) |
| `games/<Game>/` | later: how a real game was built, cut into the same kind of steps |
| `livecode/` | the HOWTO stack and its syntax-colour library |

## How it is made
1. Spark (the local model) writes the big outline: `../LIB_SPARK/howto/` -> `OUTLINE.md`.
2. Claude and the owner review it; the approved outline is copied here as `OUTLINE.md`.
3. Spark writes each step's words; Claude writes each step's code, as small as it can be to
   get something on screen, and checks that it compiles and runs headless.
4. The stack reads everything from these text files: fixing a lesson never means editing the stack.

## Look
Dark mode. Topic list on the left on every card; the Vibecode3D and xt3d viewports share the
right side (a toggle picks the engine); the step's code in a scrolling, syntax-coloured field
at the bottom right.
