-- HOWTO 10 Collisions, step 1: two things on a collision course
-- Adding: a block at x 150 and a ball rolling at it with SetObjectVelocity
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
