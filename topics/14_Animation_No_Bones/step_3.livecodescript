-- HOWTO 14 Animation: No Bones, step 3: grow
-- Adding: every 30 updates Ball.Reshape: a bigger MeshSphere, kill the old ball, spawn the new
-- Needs topics 01, 04 and 05.

local sGem, sBuoy, sBall, sR, sTicks

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Gem", MeshSphere(30, 2, 6)   -- 2 rings: a six-sided diamond
   put Entity.Spawn("Gem", -240, 0, 600, "cyan") into sGem
   SetObjectRotationSpeed sGem, 0, 0.05, 0   -- it turns slowly forever
   Mesh.Define "Buoy", MeshPrism(8, 30, 24)
   put Entity.Spawn("Buoy", -80, 0, 600, "orange") into sBuoy   -- place it first: it bobs around here
   Scene.SetBob sBuoy, 6, 0.1, 0.05   -- how high, how much it rocks, how fast
   put empty into sBall
   put 16 into sR
   put 0 into sTicks
   Ball.Reshape
end Game.OnStart

on Game.OnUpdate
   add 1 to sTicks
   if sTicks mod 30 = 0 and sR < 60 then   -- once a second, until it is big
      add 4 to sR
      Ball.Reshape
   end if
end Game.OnUpdate

-- a size change needs a new shape: define it again, swap the old ball for a new one
on Ball.Reshape
   Mesh.Define "Ball", MeshSphere(sR, 6, 10)
   if sBall is not empty then Entity.Kill sBall
   put Entity.Spawn("Ball", 80, 0, 600, "#40FF40") into sBall
end Ball.Reshape
