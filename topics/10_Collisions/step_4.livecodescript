-- HOWTO 10 Collisions, step 4: react to the hit
-- Adding: on Collision.Hit: sparks, and the ball rolls back
-- Needs topics 04, 05 and 11.

local sBall, sBlock

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules
   Mesh.Define "Ball", MeshSphere(22, 6, 10)
   Mesh.Define "Block", MeshBox(56, 56, 56)
   put Entity.Spawn("Block", 150, 0, 500, "cyan") into sBlock
   put Entity.Spawn("Ball", -150, 0, 500, "orange") into sBall
   SetObjectVelocity sBall, 2, 0, 0   -- rolls right, 2 units an update
   Collision.SetGroup sBall, "ball", 22     -- group name, and how close counts as touching
   Collision.SetGroup sBlock, "block", 28
   Collision.AddRule "ball", "block"   -- the engine checks these two groups every update
end Game.OnStart

-- the engine sends this when a "ball" touches a "block"
on Collision.Hit pA, pB
   FX.Sparks GetObjectPosition(sBlock, "X") - 28, 0, 500, 12, "white"
   SetObjectVelocity sBall, -2, 0, 0   -- bounce back at once, so it does not hit again next update
end Collision.Hit
