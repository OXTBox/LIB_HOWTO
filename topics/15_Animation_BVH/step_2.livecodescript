-- HOWTO 15 Animation: BVH, step 2: one pose
-- Adding: Clip.Mesh: frame 1 as points and lines; a stick figure stands on the floor
-- Needs topics 03, 06 and 14. Clips: LIB_MOCAP/library (BVH captures turned into stick text).

constant kWalk = "Animazoo_gangster_walk"
constant kIdle = "Animazoo_hands_on_hips"
constant kM = 30   -- engine units a metre
local sClip, sFig

on Game.OnStart
   Engine.ResetCamera
   Scene.ClearAll
   HUD.Clear
   Mesh.Define "Floor", MeshGrid(10, 4, 30)
   get Entity.Spawn("Floor", 0, 30, 150, "#204020")
   Clip.Read kWalk
   Mesh.Define "Pose", Clip.Mesh(kWalk, 1)
   put Entity.Spawn("Pose", 0, 30, 150, "white") into sFig   -- feet on the floor (y 30)
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

-- one frame as a wire mesh: a point a joint, a line an edge ("0-1" = joints 0 and 1)
function Clip.Mesh pName, pFrame
   local tM, tV, tE
   put Mesh.New() into tM
   put sClip[pName]["frame"][pFrame] into tV
   split tV by comma
   repeat with i = 0 to sClip[pName]["joints"] - 1
      Mesh.AddVertex tM, tV[3 * i + 1] * kM, -tV[3 * i + 2] * kM, tV[3 * i + 3] * kM   -- up is minus Y
   end repeat
   set the itemDel to "-"
   repeat for each word tE in sClip[pName]["edges"]
      Mesh.AddLine tM, item 1 of tE + 1, item 2 of tE + 1   -- the file counts joints from 0
   end repeat
   set the itemDel to comma
   return tM
end Clip.Mesh
