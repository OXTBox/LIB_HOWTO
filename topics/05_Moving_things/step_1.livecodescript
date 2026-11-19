-- HOWTO 05 Moving things, step 1: move it by hand every step
-- Adding: add 2 to sX in Game.OnUpdate; SetObjectPosition
-- Needs topics 01 and 04.

local sCube, sX

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(60, 60, 60)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sX
end Game.OnStart

on Game.OnUpdate
   add 2 to sX
   SetObjectPosition sCube, sX, 0, 600
end Game.OnUpdate
