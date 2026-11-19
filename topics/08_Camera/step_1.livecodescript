-- HOWTO 08 Camera, step 1: where the camera is
-- Adding: Engine.SetCam 0, 120, 400 (the scene now sits around 0,0,0)
-- Needs topics 01, 05 and 06.

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Floor", MeshGrid(10, 10, 60)
   get Entity.Spawn("Floor", 0, 40, 0, "#204020")   -- the scene sits around 0,0,0 this time
   Mesh.Define "Cube", MeshBox(40, 40, 40)
   get Entity.Spawn("Cube", -150, 20, -150, "red")
   get Entity.Spawn("Cube", 150, 20, -150, "#40FF40")
   get Entity.Spawn("Cube", -150, 20, 150, "magenta")
   get Entity.Spawn("Cube", 150, 20, 150, "yellow")
   Engine.SetCam 0, 120, 400   -- the camera 400 back and 120 up (SetCam takes them negated)
end Game.OnStart
