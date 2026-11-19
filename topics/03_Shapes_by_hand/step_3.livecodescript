-- HOWTO 03 Shapes: by hand, step 3: three lines: a triangle
-- Adding: Mesh.AddLine three times, Mesh.Define, Entity.Spawn

on Game.OnStart
   local tM
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   put Mesh.New() into tM
   Mesh.AddVertex tM, -60, 0, 0    -- point 1: left   (up is minus Y)
   Mesh.AddVertex tM, 60, 0, 0     -- point 2: right
   Mesh.AddVertex tM, 0, -100, 0   -- point 3: the top
   Mesh.AddLine tM, 1, 2           -- a line from point 1 to point 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 1
   Mesh.Define "Tri", tM
   get Entity.Spawn("Tri", 0, 0, 400, "yellow")
end Game.OnStart
