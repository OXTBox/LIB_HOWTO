-- HOWTO 16 Sound, step 1: sound files where the engine looks
-- Adding: SoundDirectory() on the HUD: put a "zap" folder with zap1.wav, zap2.wav there
-- Needs topic 07 or 10. Sample sounds: Sounds/zap/zap1.wav, zap2.wav next to these steps.

local sBall, sVX, sLeft, sRight

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Ball", MeshSphere(22, 6, 10)
   Mesh.Define "Block", MeshBox(56, 56, 56)
   put Entity.Spawn("Block", -200, 0, 500, "magenta") into sLeft
   put Entity.Spawn("Block", 200, 0, 500, "cyan") into sRight
   put Entity.Spawn("Ball", 0, 0, 500, "orange") into sBall
   put 4 into sVX
   -- the engine looks for sounds here: one folder a sound type ("zap"), its files inside
   HUD.Set "Where", "SOUNDS: " & toUpper(SoundDirectory()), 20, 120, 9
end Game.OnStart

-- topic 10's simple way: the ball bounces between the two blocks
on Game.OnUpdate
   local tX
   put GetObjectPosition(sBall, "X") + sVX into tX
   if tX > 150 then   -- touching the right block
      put -4 into sVX
   end if
   if tX < -150 then   -- touching the left block
      put 4 into sVX
   end if
   SetObjectPosition sBall, tX, 0, 500
end Game.OnUpdate
