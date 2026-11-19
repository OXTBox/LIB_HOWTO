-- HOWTO 14 Animation: No Bones, step 1: spin
-- Adding: SetObjectRotationSpeed sGem, 0, 0.05, 0
-- Needs topics 01, 04 and 05.

local sGem

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Gem", MeshSphere(30, 2, 6)   -- 2 rings: a six-sided diamond
   put Entity.Spawn("Gem", -240, 0, 600, "cyan") into sGem
   SetObjectRotationSpeed sGem, 0, 0.05, 0   -- it turns slowly forever
end Game.OnStart
