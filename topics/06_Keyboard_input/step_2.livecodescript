-- HOWTO 06 Keyboard input, step 2: read the keys held down
-- Adding: the keysDown in Game.OnUpdate: D or right arrow moves right
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

on Game.OnUpdate
   local tKeys
   put the keysDown into tKeys
   if 100 is among the items of tKeys or 65363 is among the items of tKeys then add 3 to sX   -- D or right
   SetObjectPosition sCube, sX, 0, sZ
end Game.OnUpdate

on arrowKey
   -- empty: the arrow keys belong to the game (no card change, no cursor move)
end arrowKey
