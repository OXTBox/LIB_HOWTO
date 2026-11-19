-- HOWTO 01 Game card and loop, step 2: a shape on screen
-- Adding: Mesh.Define and Entity.Spawn in Game.OnStart, and the script-local sCube

local sCube   -- the key of our cube in the scene; kept between handlers

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Cube", MeshBox(160, 160, 160)          -- names a shape; nothing shows yet
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube   -- now it is in the scene, 600 ahead
end Game.OnStart
