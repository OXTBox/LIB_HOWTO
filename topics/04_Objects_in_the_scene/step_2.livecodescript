-- HOWTO 04 Objects in the scene, step 2: many of the same shape
-- Adding: a repeat that spawns five cubes, keys kept in sCubes[n]
-- Needs topic 01.

local sCubes   -- an array: sCubes[1] .. sCubes[5] hold the five keys

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(50, 50, 50)
   repeat with n = 1 to 5
      put Entity.Spawn("Cube", -240 + n * 80, 0, 600, "cyan") into sCubes[n]
   end repeat
end Game.OnStart
