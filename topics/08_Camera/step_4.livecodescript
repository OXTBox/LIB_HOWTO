-- HOWTO 08 Camera, step 4: turn around the scene
-- Adding: Cam.LookAtMiddle: the camera circles, gCameraYaw keeps it looking in
-- Needs topics 01, 05 and 06.

global gCameraYaw, gCameraPitch   -- the engine's: which way the camera looks (radians)
local sOrbit = 0

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
   put 0 into sOrbit
end Game.OnStart

on Game.OnUpdate
   add 0.01 to sOrbit   -- radians a step: once round in about 20 seconds
   Cam.LookAtMiddle sin(sOrbit) * -400, -160, cos(sOrbit) * -400
end Game.OnUpdate

-- put the camera at world point pX,pY,pZ (up is minus Y) and look at 0,0,0
on Cam.LookAtMiddle pX, pY, pZ
   Engine.SetCam -pX, -pY, -pZ
   put atan2(0 - pX, 0 - pZ) into gCameraYaw
   put -atan2(0 - pY, sqrt(pX ^ 2 + pZ ^ 2)) into gCameraPitch
end Cam.LookAtMiddle
