-- HOWTO 01 Game card and loop, step 3: the loop
-- Adding: on Game.OnUpdate, and the script-local sAngle
-- The engine sends Game.OnUpdate about 30 times a second while the game runs.

local sCube
local sAngle = 0   -- radians; a script-local keeps its value from one update to the next

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(160, 160, 160)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sAngle
end Game.OnStart

on Game.OnUpdate
   add 0.05 to sAngle
   SetObjectRotation sCube, 0, sAngle, 0   -- turn it around the up-down (Y) axis
end Game.OnUpdate
