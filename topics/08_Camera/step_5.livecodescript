-- HOWTO 08 Camera, step 5: follow the hero
-- Adding: a steered cube; Hero.Camera puts the camera behind it every update
-- Needs topics 01, 05 and 06.

global gCameraYaw, gCameraPitch   -- the engine's: which way the camera looks (radians)
local sHero, sHX = 0, sHZ = 0, sHeading = 0, sCamX, sCamY, sCamZ, sTestKeys

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
   put Entity.Spawn("Cube", 0, 20, 0, "cyan") into sHero   -- the hero, steered with the keys
   put 0 into sHX
   put 0 into sHZ
   put 0 into sHeading
   put empty into sCamX
   focus on nothing
end Game.OnStart

on Game.OnUpdate
   local tKeys
   put Hero.Keys() into tKeys
   if Hero.Held(tKeys, "97,65,65361") then subtract 0.06 from sHeading   -- A / left: turn
   if Hero.Held(tKeys, "100,68,65363") then add 0.06 to sHeading         -- D / right
   if Hero.Held(tKeys, "119,87,65362") then   -- W / up: forward, the way it faces
      add sin(sHeading) * 4 to sHX
      add cos(sHeading) * 4 to sHZ
   end if
   SetObjectPosition sHero, sHX, 20, sHZ
   SetObjectRotation sHero, 0, sHeading, 0
   Hero.Camera
end Game.OnUpdate

-- third person: the camera 105 behind the hero and 88 up, looking at it (Amazing Couple's way)
on Hero.Camera
   local tCX, tCY, tCZ
   put sHX - sin(sHeading) * 105 into tCX
   put -88 into tCY
   put sHZ - cos(sHeading) * 105 into tCZ
   put tCX into sCamX
   put tCY into sCamY
   put tCZ into sCamZ
   Engine.SetCam -sCamX, -sCamY, -sCamZ
   put atan2(sHX - sCamX, sHZ - sCamZ) into gCameraYaw
   put -atan2(0 - sCamY, sqrt((sHX - sCamX) ^ 2 + (sHZ - sCamZ) ^ 2)) into gCameraPitch
end Hero.Camera

function Hero.Held pKeys, pCodes
   repeat for each item tCode in pCodes
      if tCode is among the items of pKeys then return true
   end repeat
   return false
end Hero.Held

-- the test hook from topic 06
on Hero.TestKeys pKeys
   put pKeys into sTestKeys
end Hero.TestKeys

function Hero.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Hero.Keys
