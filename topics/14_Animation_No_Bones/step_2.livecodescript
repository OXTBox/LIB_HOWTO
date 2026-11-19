-- HOWTO 14 Animation: No Bones, step 2: bob
-- Adding: Scene.SetBob sBuoy, 6, 0.1, 0.05
-- Needs topics 01, 04 and 05.

local sGem, sBuoy

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Gem", MeshSphere(30, 2, 6)   -- 2 rings: a six-sided diamond
   put Entity.Spawn("Gem", -240, 0, 600, "cyan") into sGem
   SetObjectRotationSpeed sGem, 0, 0.05, 0   -- it turns slowly forever
   Mesh.Define "Buoy", MeshPrism(8, 30, 24)
   put Entity.Spawn("Buoy", -80, 0, 600, "orange") into sBuoy   -- place it first: it bobs around here
   Scene.SetBob sBuoy, 6, 0.1, 0.05   -- how high, how much it rocks, how fast
end Game.OnStart
