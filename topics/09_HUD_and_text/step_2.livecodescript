-- HOWTO 09 HUD and text, step 2: make it count
-- Adding: add 1 to sScore every 30 updates; HUD.Set the same name again
-- Needs topic 01.

global gViewLeft, gViewBottom   -- the engine's: the edges of the view in screen pixels
local sCube, sScore, sTicks

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(120, 120, 120)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   SetObjectRotationSpeed sCube, 0.01, 0.02, 0
   put 0 into sScore
   put 0 into sTicks
   HUD.Set "Score", "SCORE 0", gViewLeft + 20, 120, 14
end Game.OnStart

on Game.OnStop
   HUD.Clear
end Game.OnStop

on Game.OnUpdate
   add 1 to sTicks
   if sTicks mod 30 = 0 then   -- once a second
      add 1 to sScore
      HUD.Set "Score", "SCORE" && sScore, gViewLeft + 20, 120, 14   -- the same name: the text is replaced
   end if
end Game.OnUpdate
