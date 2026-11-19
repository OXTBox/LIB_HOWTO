-- HOWTO 15 Animation: BVH, step 1: the clip file
-- Adding: Clip.Read: header lines and one line of numbers a frame
-- Needs topics 03, 06 and 14. Clips: LIB_MOCAP/library (BVH captures turned into stick text).

constant kWalk = "Animazoo_gangster_walk"
constant kIdle = "Animazoo_hands_on_hips"
constant kM = 30   -- engine units a metre
local sClip

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Floor", MeshGrid(10, 4, 30)
   get Entity.Spawn("Floor", 0, 30, 150, "#204020")
   Clip.Read kWalk
   HUD.Set "Clip", "FRAMES" && sClip[kWalk]["frames"] && "  FPS" && sClip[kWalk]["fps"] && "  CYCLE" && sClip[kWalk]["cycle"], 20, 120, 12
end Game.OnStart

-- read a LIB_MOCAP stick clip: header lines ("fps,30") into sClip[pName][...], frames into sClip[pName]["frame"][n]
on Clip.Read pName
   local tFile, tLine, tN
   put Game.FindFile("LIB_MOCAP/library/" & pName & "/" & pName & "_stick.txt") into tFile
   if tFile is empty then
      HUD.Set "Err", "NO CLIP " & toUpper(pName), 20, 150, 12
      exit Clip.Read
   end if
   put 0 into tN
   repeat for each line tLine in URL ("file:" & tFile)
      if tLine is empty or char 1 of tLine is "#" then next repeat
      if char 1 of tLine is "-" or char 1 of tLine is a number then
         add 1 to tN
         put tLine into sClip[pName]["frame"][tN]   -- x,y,z of every joint, metres, y up
      else
         put item 2 to -1 of tLine into sClip[pName][item 1 of tLine]   -- e.g. fps, travel, cycle, edges
      end if
   end repeat
   put tN into sClip[pName]["frames"]
end Clip.Read
