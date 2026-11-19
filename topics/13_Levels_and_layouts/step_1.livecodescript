-- HOWTO 13 Levels and layouts, step 1: a level table
-- Adding: Level.Table (one line a level) and Level.Start
-- Needs topics 02 and 12.

local sLevel

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(40, 40, 40)
   Level.Start 1
end Game.OnStart

-- one line a level: how many cubes, how fast they spin, their colour
function Level.Table
   return "3,0.02,cyan" & return & "5,0.04,yellow" & return & "8,0.08,magenta"
end Level.Table

on Level.Start pLevel
   local tRow, tKey
   put pLevel into sLevel
   put line pLevel of Level.Table() into tRow
   Scene.ClearAll
   repeat with n = 1 to item 1 of tRow
      put Entity.Spawn("Cube", (n - (item 1 of tRow + 1) / 2) * 70, 0, 600, item 3 of tRow) into tKey
      SetObjectRotationSpeed tKey, 0, item 2 of tRow, 0
   end repeat
   HUD.Set "Level", "LEVEL" && pLevel, 20, 120, 14
end Level.Start
