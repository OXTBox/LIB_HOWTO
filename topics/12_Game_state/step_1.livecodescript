-- HOWTO 12 Game state, step 1: the numbers
-- Adding: sScore, sLives, sLevel set in Game.OnStart; Catch.ShowNumbers
-- Needs topics 06, 09 and 10. It starts from a small catch game: A/D move the paddle, drops fall.

global gViewLeft
local sPaddle, sPX, sDrop, sDropKind, sDY, sTicks, sTestKeys
local sScore, sLives, sLevel

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   focus on nothing
   Mesh.Define "Paddle", MeshBox(100, 16, 40)
   Mesh.Define "Drop", MeshSphere(16, 4, 6)
   put 0 into sPX
   put Entity.Spawn("Paddle", 0, 120, 500, "cyan") into sPaddle
   put 0 into sTicks
   put 0 into sScore
   put 3 into sLives
   put 1 into sLevel
   Catch.ShowNumbers
   Catch.NewDrop
end Game.OnStart

-- a new drop at the top: mostly green gems, sometimes a red hazard
on Catch.NewDrop
   if sDrop is not empty then Entity.Kill sDrop
   if random(4) = 1 then
      put "hazard" into sDropKind
   else
      put "gem" into sDropKind
   end if
   if sDropKind is "gem" then
      put Entity.Spawn("Drop", random(400) - 200, -200, 500, "#40FF40") into sDrop
   else
      put Entity.Spawn("Drop", random(400) - 200, -200, 500, "red") into sDrop
   end if
   put 0 into sDY
end Catch.NewDrop

on Catch.ShowNumbers
   HUD.Set "Numbers", "SCORE" && sScore & "   LIVES" && sLives & "   LEVEL" && sLevel, gViewLeft + 20, 120, 14
end Catch.ShowNumbers

on Game.OnUpdate
   local tKeys, tX, tY
   add 1 to sTicks
   put Catch.Keys() into tKeys
   if 97 is among the items of tKeys or 65361 is among the items of tKeys then subtract 6 from sPX   -- A / left
   if 100 is among the items of tKeys or 65363 is among the items of tKeys then add 6 to sPX   -- D / right
   SetObjectPosition sPaddle, sPX, 120, 500
   add 0.1 * sLevel to sDY   -- it falls faster and faster, faster on later levels
   put GetObjectPosition(sDrop, "X") into tX
   put GetObjectPosition(sDrop, "Y") + sDY into tY
   SetObjectPosition sDrop, tX, tY, 500
   if tY > 100 and tY < 130 and abs(tX - sPX) < 60 then
      Catch.NewDrop   -- caught
   else if tY > 200 then
      Catch.NewDrop   -- missed: the next one
   end if
end Game.OnUpdate

-- the test hook (topic 06): a test can hold keys without a keyboard
on Catch.TestKeys pKeys
   put pKeys into sTestKeys
end Catch.TestKeys

function Catch.Keys
   if sTestKeys is not empty then return sTestKeys
   return the keysDown
end Catch.Keys
