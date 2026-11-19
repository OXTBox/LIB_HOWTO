-- HOWTO 11 Effects, step 5: a clean start
-- Adding: Particles.Clear in Game.OnStart
-- Needs topics 01 and 04.

local sCube, sTicks = 0, sKeyWas, sBackAt

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   Particles.Clear   -- no sparks left over from the last game
   HUD.Clear
   Mesh.Define "Cube", MeshBox(100, 100, 100)
   Fx.NewCube
   FX.Sparks 0, 0, 600, 16, "orange"   -- x, y, z, how many, colour
   View.Set "explode", "debris"   -- blasts now throw every edge as a flying piece
end Game.OnStart

on Fx.NewCube
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   SetObjectRotationSpeed sCube, 0.01, 0.02, 0
end Fx.NewCube

on Game.OnUpdate
   local tKeys
   add 1 to sTicks
   put the keysDown into tKeys
   if 32 is among the items of tKeys then   -- Space, once a press (topic 06)
      if sKeyWas["space"] is not true then Fx.Burst
      put true into sKeyWas["space"]
   else
      put false into sKeyWas["space"]
   end if
   if 65293 is among the items of tKeys and sCube is not empty then Fx.Blast   -- Return
   if sBackAt is a number and sTicks >= sBackAt then   -- a new cube a second later
      put empty into sBackAt
      Fx.NewCube
   end if
end Game.OnUpdate

-- sparks from wherever the cube is
on Fx.Burst
   if sCube is empty then exit Fx.Burst
   FX.Sparks GetObjectPosition(sCube, "X"), GetObjectPosition(sCube, "Y"), GetObjectPosition(sCube, "Z"), 16, "orange"
end Fx.Burst

on Fx.Blast
   FX.Destroy sCube   -- the engine's blast: the cube is gone after it
   put empty into sCube
   put sTicks + 30 into sBackAt
end Fx.Blast

on Game.OnStop
   View.Set "explode", "derez"   -- give the next game the usual de-rez blast back
end Game.OnStop
