-- HOWTO 18 One game, two engines, step 3: keys belong to the game
-- Adding: focus on nothing and the empty arrowKey handler
-- Needs topic 01.

global gViewLeft, gViewTop, gViewRight, gViewBottom   -- the view edges, in each engine's window
local sCube, sAngle = 0

-- Only engine calls (topics 01-17), no buttons or fields of our own on the card:
-- the xt3d bench has the same calls, and nothing else from the Vibecode3D card.
on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   focus on nothing   -- in both engines the arrows steer the game, not a menu
   Mesh.Define "Cube", MeshBox(160, 160, 160)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sAngle
   HUD.Set "Title", "SPINNING CUBE", gViewLeft + 20, gViewTop + 120, 14   -- from the view, not fixed pixels
   HUD.Set "Help", "ONE GAME TWO ENGINES", gViewLeft + 20, gViewBottom - 50, 10
end Game.OnStart

on Game.OnUpdate
   add 0.05 to sAngle
   SetObjectRotation sCube, 0, sAngle, 0
end Game.OnUpdate

on Game.OnStop
   HUD.Clear
end Game.OnStop

on arrowKey
end arrowKey
