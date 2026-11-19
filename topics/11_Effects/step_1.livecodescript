-- HOWTO 11 Effects, step 1: sparks
-- Adding: FX.Sparks in Game.OnStart
-- Needs topics 01 and 04.

local sCube

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(100, 100, 100)
   Fx.NewCube
   FX.Sparks 0, 0, 600, 16, "orange"   -- x, y, z, how many, colour
end Game.OnStart

on Fx.NewCube
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   SetObjectRotationSpeed sCube, 0.01, 0.02, 0
end Fx.NewCube
