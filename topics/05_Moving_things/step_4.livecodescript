-- HOWTO 05 Moving things, step 4: let the engine move it
-- Adding: a second cube with SetObjectVelocity, once
-- Needs topics 01 and 04.

local sCube, sX, sVX, sDrift

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(60, 60, 60)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sX
   put 4 into sVX
   SetObjectRotationSpeed sCube, 0, 0.05, 0   -- once: the engine turns it every update
   put Entity.Spawn("Cube", 0, -150, 600, "orange") into sDrift
   SetObjectVelocity sDrift, 0, 0, 2           -- once: 2 units away from you every update
end Game.OnStart

on Game.OnUpdate
   add sVX to sX
   if abs(sX) > 200 then put -sVX into sVX   -- past an edge: turn round
   SetObjectPosition sCube, sX, 0, 600
end Game.OnUpdate
