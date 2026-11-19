-- HOWTO 13 Levels and layouts, step 3: a maze from a seed
-- Adding: a new card from here: start using LIB_BIT and LIB_MAP; Bit.Maze(6, 6, sSeed)
-- Needs topics 02 and 12.

global gCameraPitch
local sSeed = 1, sGrid

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Maze.LoadLibraries
   put 1 into sSeed
   Maze.Build
end Game.OnStart

on Maze.Build
   put Bit.Maze(6, 6, sSeed) into sGrid   -- 6 x 6 rooms: 13 x 13 cells, "1" wall, "0" open
   HUD.Set "Maze", "MAZE" && the number of chars of line 1 of sGrid && "X" && the number of lines of sGrid && "  SEED" && sSeed, 20, 120, 14
end Maze.Build
-- the libraries: found with Game.FindFile, then used like part of the engine
on Maze.LoadLibraries
   start using stack Game.FindFile("LIB_BIT/livecode/lib_bit.livecodescript")
   start using stack Game.FindFile("LIB_MAP/livecode/lib_map.livecodescript")
end Maze.LoadLibraries
