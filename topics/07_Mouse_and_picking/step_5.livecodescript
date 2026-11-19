-- HOWTO 07 Mouse and picking, step 5: (deeper) pick without firing
-- Adding: mouseMove, ScreenToCameraRay and RayCastScene: an arrow over the rock under the mouse
-- Needs topics 01, 04 and 11.

global gObjectTransforms, gSceneObjects, CenterX, CenterY, gFocalLength   -- the engine's
local sScore, sArrow

on Game.OnStart
   local tKey
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Mesh.Define "Rock", MeshSphere(30, 3, 5)
   repeat with n = 1 to 5
      if n = 1 then
         put Entity.Spawn("Rock", 0, 0, 500, "#A0A0A0") into tKey   -- the first one in the middle
      else
         put Entity.Spawn("Rock", random(400) - 200, random(200) - 150, 400 + random(300), "#A0A0A0") into tKey
      end if
      put 2 into gObjectTransforms[tKey]["hp"]   -- hit points: two hits blast it
   end repeat
   put 0 into sScore
   Mesh.Define "Arrow", MeshPyramid(3, 12, 24)
   put Entity.Spawn("Arrow", 0, -2000, 0, "yellow") into sArrow   -- parked out of sight
   SetObjectRotation sArrow, 0, 0, pi   -- upside down: it points at the rock
end Game.OnStart

on Game.OnClick pX, pY
   HUD.Set "Click", pX & "," & pY, 20, 120, 14   -- where you clicked, in screen pixels
   Weapon.FireAt pX, pY   -- a laser from the click: the engine finds what it hits
end Game.OnClick

-- the engine sends this when Weapon.FireAt took a rock's last hit point
on Game.OnKill pKey, pX, pY, pZ
   add 1 to sScore
   FX.Sparks pX, pY, pZ, 12, "orange"
   HUD.Set "Score", "SCORE" && sScore, 20, 150, 14
end Game.OnKill

-- the card gets mouseMove whenever the mouse moves over it
on mouseMove pX, pY
   Rock.Hover pX, pY
end mouseMove

-- which rock is under the screen point pX,pY? a yellow arrow floats over it
on Rock.Hover pX, pY
   local tRay, tRocks, tKey
   put ScreenToCameraRay(pX, pY, CenterX, CenterY, 0, 0, 1, gFocalLength) into tRay
   if the number of words of tRay >= 3 then
      put gSceneObjects into tRocks
      filter tRocks with "Rock *"   -- only rocks: not the arrow itself
      put word 2 of RayCastScene(tRocks, word 1 of tRay, word 2 of tRay, word 3 of tRay) into tKey
   end if
   if tKey is empty then
      SetObjectPosition sArrow, 0, -2000, 0   -- nothing under the mouse: park the arrow far away
   else
      SetObjectPosition sArrow, GetObjectPosition(tKey, "X"), GetObjectPosition(tKey, "Y") - 60, GetObjectPosition(tKey, "Z")
   end if
end Rock.Hover
