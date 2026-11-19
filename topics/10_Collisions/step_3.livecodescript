-- HOWTO 10 Collisions, step 3: a rule
-- Adding: Collision.ClearRules at the start, Collision.AddRule "ball", "block"
-- Needs topics 04, 05 and 11.

local sBall, sBlock

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear
   HUD.Clear
   Collision.ClearRules   -- no rules left over from another game
   Mesh.Define "Ball", MeshSphere(22, 6, 10)
   Mesh.Define "Block", MeshBox(56, 56, 56)
   put Entity.Spawn("Block", 150, 0, 500, "cyan") into sBlock
   put Entity.Spawn("Ball", -150, 0, 500, "orange") into sBall
   SetObjectVelocity sBall, 2, 0, 0   -- rolls right, 2 units an update
   Collision.SetGroup sBall, "ball", 22     -- group name, and how close counts as touching
   Collision.SetGroup sBlock, "block", 28
   Collision.AddRule "ball", "block"   -- the engine checks these two groups every update
end Game.OnStart
