-- HOWTO 03 Shapes: by hand, step 4: a house: a square and a roof
-- Adding: four more points and four lines

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
   Mesh.AddVertex tM, -60, 0, 0    -- point 4: the square below the roof
   Mesh.AddVertex tM, 60, 0, 0     -- point 5
   Mesh.AddVertex tM, 60, 100, 0   -- point 6 (down is plus Y)
   Mesh.AddVertex tM, -60, 100, 0  -- point 7
   Mesh.AddLine tM, 4, 5
   Mesh.AddLine tM, 5, 6
   Mesh.AddLine tM, 6, 7
   Mesh.AddLine tM, 7, 4
   Mesh.Define "Tri", tM
   get Entity.Spawn("Tri", 0, 0, 400, "yellow")
end Game.OnStart
