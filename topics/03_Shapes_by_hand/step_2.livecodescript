-- HOWTO 03 Shapes: by hand, step 2: three points
-- Adding: Mesh.AddVertex three times (points alone draw nothing)

on Game.OnStart
   local tM
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   put Mesh.New() into tM
   Mesh.AddVertex tM, -60, 0, 0    -- point 1: left   (up is minus Y)
   Mesh.AddVertex tM, 60, 0, 0     -- point 2: right
   Mesh.AddVertex tM, 0, -100, 0   -- point 3: the top
end Game.OnStart
