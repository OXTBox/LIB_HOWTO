-- HOWTO 01 Game card and loop, step 1: an empty game card
-- Adding: on Game.OnStart
-- The engine sends Game.OnStart to the card when you press Play.

on Game.OnStart
   Engine.ResetCamera   -- the camera at 0,0,0, looking along +Z
   Scene.ClearAll       -- no objects left over from another game
   HUD.Clear            -- no words left over either
end Game.OnStart
