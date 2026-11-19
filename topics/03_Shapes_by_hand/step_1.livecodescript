-- HOWTO 03 Shapes: by hand, step 1: a new, empty mesh
-- Adding: put Mesh.New() into tM

on Game.OnStart
   local tM
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   put Mesh.New() into tM          -- an empty shape: no points, no lines yet
end Game.OnStart
