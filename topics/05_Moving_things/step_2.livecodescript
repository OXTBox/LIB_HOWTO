-- HOWTO 05 Moving things, step 2: bounce at the edges
-- Adding: sVX, turned round past x 200
-- Needs topics 01 and 04.

local sCube, sX, sVX

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(60, 60, 60)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sX
   put 4 into sVX
end Game.OnStart

on Game.OnUpdate
   add sVX to sX
   if abs(sX) > 200 then put -sVX into sVX   -- past an edge: turn round
   SetObjectPosition sCube, sX, 0, 600
end Game.OnUpdate
