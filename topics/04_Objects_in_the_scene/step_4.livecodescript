-- HOWTO 04 Objects in the scene, step 4: remove one
-- Adding: Entity.Kill sCubes[3] after 60 updates (sTicks counts them)
-- Needs topic 01.

local sCubes, sTicks

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
   put 0 into sTicks
end Game.OnStart

on Game.OnUpdate
   add 1 to sTicks
   if sTicks = 60 then Entity.Kill sCubes[3]   -- two seconds in: the middle one goes
end Game.OnUpdate
