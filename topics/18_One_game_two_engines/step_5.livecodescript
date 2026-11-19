-- HOWTO 18 One game, two engines, step 5: keep the speed the same
-- Adding: Engine.Info("stepMS"): turn by time, not by updates
-- Needs topic 01.

global gViewLeft, gViewTop, gViewRight, gViewBottom   -- the view edges, in each engine's window
local sCube, sAngle = 0, sStepMS

-- Only engine calls (topics 01-17), no buttons or fields of our own on the card:
-- the xt3d bench has the same calls, and nothing else from the Vibecode3D card.
on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   focus on nothing   -- in both engines the arrows steer the game, not a menu
   put Engine.Info("stepMS") into sStepMS   -- how long one update is in THIS engine
   Mesh.Define "Cube", MeshBox(160, 160, 160)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sAngle
   HUD.Set "Title", "SPINNING CUBE", gViewLeft + 20, gViewTop + 120, 14   -- from the view, not fixed pixels
   HUD.Set "Help", "ONE GAME TWO ENGINES", gViewLeft + 20, gViewBottom - 50, 10
end Game.OnStart

on Game.OnUpdate
   add 1.5 * sStepMS / 1000 to sAngle   -- 1.5 radians a second, however long an update is
   SetObjectRotation sCube, 0, sAngle, 0
end Game.OnUpdate

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey
end arrowKey
