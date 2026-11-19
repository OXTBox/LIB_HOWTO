-- HOWTO 14 Animation: No Bones, step 5: a flip-book
-- Adding: 8 wing shapes made at the start; Wing.Show swaps the next one in
-- Needs topics 01, 04 and 05.

local sGem, sBuoy, sBall, sR, sTicks, sSides, sWing, sFrame

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
   put 4 into sSides
   put 0 into sTicks
   Ball.Reshape
   -- 8 shapes made once at the start: a wing at 8 points of its flap
   repeat with n = 1 to 8
      Mesh.Define "Wing." & n, Wing.Mesh(sin(n * pi / 4) * 40)
   end repeat
   put 1 into sFrame
   put Entity.Spawn("Wing.1", 240, 0, 600, "yellow") into sWing
   SetObjectRotation sWing, -0.8, 0, 0   -- tipped toward you, so you see it flap
end Game.OnStart

on Game.OnUpdate
   add 1 to sTicks
   if sTicks mod 30 = 0 and sR < 60 then   -- once a second, until it is big
      add 4 to sR
      add 2 to sSides   -- and rounder
      Ball.Reshape
   end if
   if sTicks mod 2 = 0 then   -- the next page of the flip-book every other update
      put sFrame mod 8 + 1 into sFrame
      Wing.Show "Wing." & sFrame
   end if
end Game.OnUpdate

-- a size change needs a new shape: define it again, swap the old ball for a new one
on Ball.Reshape
   Mesh.Define "Ball", MeshSphere(sR, sSides div 2, sSides)
   if sBall is not empty then Entity.Kill sBall
   put Entity.Spawn("Ball", 80, 0, 600, "#40FF40") into sBall
end Ball.Reshape

-- a flat wing: its tip lifted by pLift (up is minus Y)
function Wing.Mesh pLift
   local tM
   put Mesh.New() into tM
   Mesh.AddVertex tM, -10, 0, -20
   Mesh.AddVertex tM, -10, 0, 20
   Mesh.AddVertex tM, 70, -pLift, 0
   Mesh.AddLine tM, 1, 2
   Mesh.AddLine tM, 2, 3
   Mesh.AddLine tM, 3, 1
   return tM
end Wing.Mesh

-- show the wing with another of its shapes: the object's line in gSceneObjects names its mesh
on Wing.Show pMesh
   global gSceneObjects
   repeat with i = 1 to the number of lines of gSceneObjects
      if word 2 of line i of gSceneObjects is sWing then put pMesh into word 1 of line i of gSceneObjects
   end repeat
end Wing.Show
