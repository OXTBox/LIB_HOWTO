-- HOWTO 07 Mouse and picking, step 2: hear the click
-- Adding: on Game.OnClick pX, pY: show where you clicked
-- Needs topics 01, 04 and 11.

global gObjectTransforms   -- the engine's array of every object

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
end Game.OnStart

on Game.OnClick pX, pY
   HUD.Set "Click", pX & "," & pY, 20, 120, 14   -- where you clicked, in screen pixels
end Game.OnClick
