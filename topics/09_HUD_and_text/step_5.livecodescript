-- HOWTO 09 HUD and text, step 5: only redraw when it changed
-- Adding: Game.ShowHUD keeps the last text in sHUDWas
-- Needs topic 01.

global gViewLeft, gViewBottom   -- the engine's: the edges of the view in screen pixels
local sCube, sScore, sTicks, sHUDWas

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
   HUD.Set "Help", "ARROWS MOVE   SPACE JUMP", gViewLeft + 20, gViewBottom - 50, 11
   HUD.Set "Msg", "GET READY", 300, 300, 24
   put empty into sHUDWas
end Game.OnStart

on Game.OnStop
   HUD.Clear
end Game.OnStop

on Game.OnUpdate
   add 1 to sTicks
   if sTicks mod 30 = 0 then add 1 to sScore
   Game.ShowHUD
   if sTicks = 60 then HUD.Remove "Msg"   -- two seconds, then it goes
end Game.OnUpdate

-- set the score text only when it changed: the same screen, less work every update
on Game.ShowHUD
   local tText
   put "SCORE" && sScore into tText
   if tText is sHUDWas then exit Game.ShowHUD
   put tText into sHUDWas
   HUD.Set "Score", tText, gViewLeft + 20, 120, 14
end Game.ShowHUD
