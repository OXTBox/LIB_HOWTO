-- HOWTO 13 Levels and layouts, step 6: (next) a map drawn by hand
-- Adding: Maze.FromFile: a .cellmap from the BitEditor, the same walls code
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
   Maze.FromFile "LIB_BIT/editor/maps/amazing_couple_mazes/maze_0" & ((sSeed - 1) mod 3) + 1 & ".cellmap"
   if sGrid is empty then put Bit.Maze(6, 6, sSeed) into sGrid   -- no file: build one
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

-- a map painted in LIB_BIT's BitEditor: a cell is open floor when its floor height is 1-99
on Maze.FromFile pPath
   local tFile, tMap, tLine
   put empty into sGrid
   put Game.FindFile(pPath) into tFile
   if tFile is empty then exit Maze.FromFile
   put CellMap.Read(tFile) into tMap
   CellMap.Upgrade tMap   -- an old map file in today's format
   repeat with tR = 1 to tMap["meta"]["rows"]
      put empty into tLine
      repeat with tC = 1 to tMap["meta"]["cols"]
         if tMap["floor"][tR][tC] >= 100 or tMap["floor"][tR][tC] <= 0 then
            put "1" after tLine
         else
            put "0" after tLine
         end if
      end repeat
      put tLine & return after sGrid
   end repeat
   delete the last char of sGrid
end Maze.FromFile
-- the libraries: found with Game.FindFile, then used like part of the engine
on Maze.LoadLibraries
   start using stack Game.FindFile("LIB_BIT/livecode/lib_bit.livecodescript")
   start using stack Game.FindFile("LIB_MAP/livecode/lib_map.livecodescript")
   start using stack Game.FindFile("LIB_BIT/editor/livecode/lib_cellmap.livecodescript")
end Maze.LoadLibraries
