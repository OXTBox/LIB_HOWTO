-- HOWTO 01 Game card and loop, step 5: clean up when the game stops
-- Adding: on Game.OnStop
-- The engine sends Game.OnStop when you press Stop or pick another game.

local sCube
local sAngle = 0

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(160, 160, 160)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sAngle
   HUD.Set "Title", "SPINNING CUBE", 20, 120, 14
end Game.OnStart

on Game.OnUpdate
   add 0.05 to sAngle
   SetObjectRotation sCube, 0, sAngle, 0
end Game.OnUpdate

on Game.OnStop
   HUD.Clear   -- the next game starts with no old title on screen
end Game.OnStop
