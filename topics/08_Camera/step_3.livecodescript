-- HOWTO 08 Camera, step 3: from above
-- Adding: Engine.SetCam 0, 420, 300 and a steep gCameraPitch
-- Needs topics 01, 05 and 06.

global gCameraYaw, gCameraPitch   -- the engine's: which way the camera looks (radians)

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
   Engine.SetCam 0, 420, 300   -- high up and closer
   put -atan2(420, 300) into gCameraPitch   -- steeply down
end Game.OnStart
