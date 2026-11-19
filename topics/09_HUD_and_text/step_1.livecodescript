-- HOWTO 09 HUD and text, step 1: a line of text
-- Adding: HUD.Set "Score" at gViewLeft + 20, y 120
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
