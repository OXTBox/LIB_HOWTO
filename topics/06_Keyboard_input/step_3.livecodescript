-- HOWTO 06 Keyboard input, step 3: all four directions
-- Adding: Cube.Held for A/D/W/S and the arrows, both cases
-- Needs topics 01 and 05.

local sCube, sX, sZ

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   focus on nothing   -- keys go to the game, not to a field
   Mesh.Define "Cube", MeshBox(60, 60, 60)
   put Entity.Spawn("Cube", 0, 0, 600, "cyan") into sCube
   put 0 into sX
   put 600 into sZ
end Game.OnStart

on Game.OnUpdate
   local tKeys
   put the keysDown into tKeys
   if Cube.Held(tKeys, "100,68,65363") then add 3 to sX      -- d D right
   if Cube.Held(tKeys, "97,65,65361") then subtract 3 from sX -- a A left
   if Cube.Held(tKeys, "119,87,65362") then add 3 to sZ      -- w W up: away (plus Z)
   if Cube.Held(tKeys, "115,83,65364") then subtract 3 from sZ -- s S down: nearer
   SetObjectPosition sCube, sX, 0, sZ
end Game.OnUpdate

-- true when any of the key codes in pCodes is in the list of keys held down
function Cube.Held pKeys, pCodes
   repeat for each item tCode in pCodes
      if tCode is among the items of pKeys then return true
   end repeat
   return false
end Cube.Held

on arrowKey
   -- empty: the arrow keys belong to the game (no card change, no cursor move)
end arrowKey
