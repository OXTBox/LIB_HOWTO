-- HOWTO 16 Sound, step 3: play one on an event
-- Adding: Sound.Play "zap" when the ball hits the right block
-- In the Game Player sound is silent for now: LIB_SYSTEM/ISSUES 0013 (no Viewport group there).
-- Needs topic 07 or 10. Sample sounds: Sounds/zap/zap1.wav, zap2.wav next to these steps.

local sBall, sVX, sLeft, sRight

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Audio.Init   -- loads every sound folder once (Game.Play does it the first time anyway)
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
      Sound.Play "zap"   -- the type is the folder name; several files take turns
   end if
   if tX < -150 then   -- touching the left block
      put 4 into sVX
   end if
   SetObjectPosition sBall, tX, 0, 500
end Game.OnUpdate
