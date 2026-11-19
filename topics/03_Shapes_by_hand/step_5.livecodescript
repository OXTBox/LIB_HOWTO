-- HOWTO 03 Shapes: by hand, step 5: a face, and turn it
-- Adding: Mesh.AddFace tM, "4 5 6 7"; SetObjectRotationSpeed so you see it from the side
-- In wire view a face looks like its edges; the filled and hidden-line looks use faces.

on Game.OnStart
   local tM, tKey
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
   Mesh.AddFace tM, "4 5 6 7"      -- the square as one face: its points in order around the edge
   Mesh.Define "Tri", tM
   put Entity.Spawn("Tri", 0, 0, 400, "yellow") into tKey
   SetObjectRotationSpeed tKey, 0, 0.03, 0   -- turns slowly: it is flat, seen side-on it nearly vanishes
end Game.OnStart
