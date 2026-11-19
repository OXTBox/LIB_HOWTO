-- HOWTO 02 Shapes: built-in meshes, step 3: a ball
-- Adding: MeshSphere
-- Needs topic 01. Up is minus Y: the floor lies at y 120, below the camera's eye (y 0).

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Floor", MeshGrid(12, 8, 60)            -- 12 x 8 squares, 60 apart, lying flat
   get Entity.Spawn("Floor", 0, 120, 420, "#204020")   -- a function: get it (topic 04 keeps the key)
   Mesh.Define "Box", MeshBox(80, 80, 80)
   get Entity.Spawn("Box", -240, 80, 420, "cyan")           -- y 80: half its height above the floor
   Mesh.Define "Ball", MeshSphere(44, 6, 10)          -- radius, rings, sides
   get Entity.Spawn("Ball", -80, 76, 420, "orange")
end Game.OnStart
