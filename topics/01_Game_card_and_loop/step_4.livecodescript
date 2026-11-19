-- HOWTO 01 Game card and loop, step 4: words on screen
-- Adding: HUD.Set in Game.OnStart

local sCube
local sAngle = 0

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(160, 160, 160)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sAngle
   HUD.Set "Title", "SPINNING CUBE", 20, 120, 14   -- name, text, x, y, size (screen pixels)
end Game.OnStart

on Game.OnUpdate
   add 0.05 to sAngle
   SetObjectRotation sCube, 0, sAngle, 0
end Game.OnUpdate
