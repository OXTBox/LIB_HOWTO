-- HOWTO 17 Pause, notes and tests, step 3: notes while you play
-- Adding: nothing in the game: press ` or F2 (the GameNotes front script)
-- Needs topics 06 and 12.

global gViewLeft
local sCube, sX, sZ, sMoved

-- Notes while you play: nothing to add here. Press ` or F2 in a game: LIB_GAMES' GameNotes
-- box opens, and your note is saved with Cube.State() in LIB_LLMIN/LIB_GAMES/GAME_NOTES.txt.

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   focus on nothing
   Mesh.Define "Cube", MeshBox(60, 60, 60)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sX
   put 600 into sZ
   put 0 into sMoved
end Game.OnStart

on Game.OnUpdate
   local tKeys
   put the keysDown into tKeys
   if 100 is among the items of tKeys or 65363 is among the items of tKeys then Cube.Move 3, 0   -- D / right
   if 97 is among the items of tKeys or 65361 is among the items of tKeys then Cube.Move -3, 0   -- A / left
   if 119 is among the items of tKeys or 65362 is among the items of tKeys then Cube.Move 0, 3   -- W / up: away
   if 115 is among the items of tKeys or 65364 is among the items of tKeys then Cube.Move 0, -3  -- S / down
end Game.OnUpdate

on Cube.Move pDX, pDZ
   add pDX to sX
   add pDZ to sZ
   add 3 to sMoved
   SetObjectPosition sCube, sX, 0, sZ
end Cube.Move

on arrowKey
end arrowKey

-- Escape: the engine stops sending Game.OnUpdate and sends Game.OnPause
on Game.OnPause
   HUD.Set "Paused", "PAUSED", gViewLeft + 340, 200, 30
end Game.OnPause

on Game.OnResume
   HUD.Remove "Paused"
end Game.OnResume

-- the game in one short line: for notes, tests and anyone who asks
function Cube.State
   return "x" && sX && "z" && sZ && "moved" && sMoved
end Cube.State
