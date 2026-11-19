-- HOWTO 06 Keyboard input, step 1: whose keys are they
-- Adding: focus on nothing in Game.OnStart; an empty arrowKey handler
-- Needs topics 01 and 05.

local sCube, sX, sZ

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   focus on nothing   -- keys go to the game, not to a field
   Mesh.Define "Cube", MeshBox(60, 60, 60)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sX
   put 600 into sZ
end Game.OnStart

on arrowKey
   -- empty: the arrow keys belong to the game (no card change, no cursor move)
end arrowKey
