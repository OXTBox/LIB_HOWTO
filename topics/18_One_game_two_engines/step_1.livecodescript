-- HOWTO 18 One game, two engines, step 1: only engine calls
-- Adding: nothing new: topic 01's cube uses only engine calls
-- Needs topic 01.

local sCube, sAngle = 0

-- Only engine calls (topics 01-17), no buttons or fields of our own on the card:
-- the xt3d bench has the same calls, and nothing else from the Vibecode3D card.
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
   HUD.Clear
end Game.OnStop
