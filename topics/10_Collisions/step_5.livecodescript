-- HOWTO 10 Collisions, step 5: the simple way
-- Adding: instead of groups: a distance check in Game.OnUpdate (this script starts again from step 1)
-- Needs topics 04, 05 and 11.

local sBall, sBlock

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Mesh.Define "Ball", MeshSphere(22, 6, 10)
   Mesh.Define "Block", MeshBox(56, 56, 56)
   put Entity.Spawn("Block", 150, 0, 500, "cyan") into sBlock
   put Entity.Spawn("Ball", -150, 0, 500, "orange") into sBall
   SetObjectVelocity sBall, 2, 0, 0   -- rolls right, 2 units an update
end Game.OnStart

-- the simple way: no groups, no rules; just measure
on Game.OnUpdate
   local tDX
   put GetObjectPosition(sBlock, "X") - GetObjectPosition(sBall, "X") into tDX
   if tDX > 0 and tDX < 50 then   -- the ball is touching the block's left side
      FX.Sparks GetObjectPosition(sBlock, "X") - 28, 0, 500, 12, "white"
      SetObjectVelocity sBall, -2, 0, 0
   end if
end Game.OnUpdate
