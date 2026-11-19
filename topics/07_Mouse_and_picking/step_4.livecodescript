-- HOWTO 07 Mouse and picking, step 4: know what was hit
-- Adding: on Game.OnKill: score and orange sparks
-- Needs topics 01, 04 and 11.

global gObjectTransforms   -- the engine's array of every object
local sScore

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
