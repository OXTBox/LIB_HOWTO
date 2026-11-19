-- HOWTO 04 Objects in the scene, step 3: colours
-- Adding: a different colour for each cube
-- Needs topic 01.

local sCubes

on Game.OnStart
   local tColours
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(50, 50, 50)
   put "red,orange,#40FF40,cyan,magenta" into tColours
   repeat with n = 1 to 5
      put Entity.Spawn("Cube", -240 + n * 80, 0, 600, item n of tColours) into sCubes[n]
   end repeat
end Game.OnStart
