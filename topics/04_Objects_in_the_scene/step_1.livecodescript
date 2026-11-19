-- HOWTO 04 Objects in the scene, step 1: keep the key
-- Adding: put Entity.Spawn(...) into sCube
-- Needs topic 01.

local sCube

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(50, 50, 50)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube   -- sCube now holds a key like "Cube_1"
end Game.OnStart
