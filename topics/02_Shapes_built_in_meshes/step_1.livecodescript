-- HOWTO 02 Shapes: built-in meshes, step 1: a floor
-- Adding: Mesh.Define "Floor", MeshGrid and Entity.Spawn
-- Needs topic 01. Up is minus Y: the floor lies at y 120, below the camera's eye (y 0).

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Floor", MeshGrid(12, 8, 60)            -- 12 x 8 squares, 60 apart, lying flat
   get Entity.Spawn("Floor", 0, 120, 420, "#204020")   -- a function: get it (topic 04 keeps the key)
end Game.OnStart
