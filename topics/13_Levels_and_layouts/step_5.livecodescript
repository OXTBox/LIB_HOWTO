-- HOWTO 13 Levels and layouts, step 5: the same maze every time
-- Adding: click: add 1 to sSeed, build again
-- Needs topics 02 and 12.

global gCameraPitch
local sSeed = 1, sGrid

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Maze.LoadLibraries
   Engine.SetCam 0, 820, 520   -- high above the maze (topic 08)
   put -atan2(820, 520) into gCameraPitch
   put 1 into sSeed
   Maze.Build
end Game.OnStart

on Maze.Build
   put Bit.Maze(6, 6, sSeed) into sGrid
   Scene.ClearAll
   -- every wall edge as a line: cells 76 wide, walls 58 high
   Mesh.Define "Walls", Maze.SegmentsToMesh(Map.BlockEdges(sGrid, 76, 58, false))
   get Entity.Spawn("Walls", 0, 0, 0, "#7FA8FF")
   HUD.Set "Maze", "SEED" && sSeed, 20, 120, 14
end Maze.Build

-- "x1,y1,z1,x2,y2,z2" a line -> one wire mesh. The map has y across and z up;
-- the engine has up = minus Y, so a point x,y,z goes in as x, -z, -y. Shared points once.
function Maze.SegmentsToMesh pSegments
   local tMesh, tSeg, tIndex, tA, tB
   put Mesh.New() into tMesh
   repeat for each line tSeg in pSegments
      if the number of items of tSeg < 6 then next repeat
      put Maze.Point(tMesh, tIndex, item 1 of tSeg, item 2 of tSeg, item 3 of tSeg) into tA
      put Maze.Point(tMesh, tIndex, item 4 of tSeg, item 5 of tSeg, item 6 of tSeg) into tB
      Mesh.AddLine tMesh, tA, tB
   end repeat
   return tMesh
end Maze.SegmentsToMesh

function Maze.Point @pMesh, @pIndex, pX, pY, pZ
   local tKey
   put pX & "," & pY & "," & pZ into tKey
   if pIndex[tKey] is empty then
      Mesh.AddVertex pMesh, pX, -pZ, -pY
      put the result into pIndex[tKey]
   end if
   return pIndex[tKey]
end Maze.Point

-- click: the next maze. Seed 1 is always the same maze, in every engine
on Game.OnClick pX, pY
   add 1 to sSeed
   Maze.Build
end Game.OnClick
-- the libraries: found with Game.FindFile, then used like part of the engine
on Maze.LoadLibraries
   start using stack Game.FindFile("LIB_BIT/livecode/lib_bit.livecodescript")
   start using stack Game.FindFile("LIB_MAP/livecode/lib_map.livecodescript")
end Maze.LoadLibraries
