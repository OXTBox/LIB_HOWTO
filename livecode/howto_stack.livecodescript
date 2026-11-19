script "howto_stack"
######################################################################################
## HOWTO  (LIB_HOWTO, Opus 19 Nov 2026) -- the stack script of the HOWTO tutorial stack
## Layout (PLAN.md): topics + steps on the left; engine toggle and the viewport top right;
## the step's words and its code (syntax coloured, lines new in this step marked) bottom
## right; < step / Run this step / Stop / step > below.
## The stack holds NO lesson text: it reads LIB_HOWTO/topics/<id>_<Title>/step_<n>.txt
## (words) and step_<n>.livecodescript (the whole card script after that step).
## Run this step = the tests/play_step.sh trick: GL.Open opens the Game Player on
## Simple_Test1, the step's script replaces the card script before the player starts it,
## and the window (no title bar) is laid exactly over the viewport.
## HT.Build makes every control again from this script (template colours first).
######################################################################################

constant kFallbackProjects = "//wsl$/Ubuntu/home/igame3d/projects"
constant kPlay = "Play Simple_Test1"
-- the xt3d games bench (xRay): LIB_MCP inside it on port 8770 (LIB_PORTS: xt3d-bench-mcp)
constant kBenchExe = "xt3D_Raylib_Livecode_Bridge/standalone/xt3d_Bench_LibMCP/xt3d_Bench_LibMCP.exe"
constant kBenchScript = "xt3D_Raylib_Livecode_Bridge/testbench/xt3d_testBench_lib_mcp.livecodescript"
constant kBenchStack = "xt3dTestBenchLibMCP"
constant kBenchPort = 8770
constant kW = 1280
constant kH = 840
constant kLeftW = 250
-- colours (dark mode)
constant kPaper = "14,17,22"
constant kPanel = "24,29,37"
constant kInk = "216,222,233"
constant kDim = "130,140,155"
constant kAccent = "124,200,255"
constant kButton = "40,52,68"
constant kOn = "60,110,160"
constant kNewLine = "34,52,40"
constant kIdent = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
constant kKeywords = "on,end,function,command,return,if,then,else,repeat,with,for,each,while,until,to,down,put,into,after,before,get,set,the,of,local,global,constant,exit,next,pass,is,not,and,or,in,among,true,false,empty,send,dispatch,add,subtract,multiply,divide,by,switch,case,break,default,try,catch,throw,private,me,it,word,char,item,line,lines,items,words,number,round,random,abs,max,min,div,mod,times,forever,contains,there,a,an,delete,variable,keys,element,elements,key,this,card,stack,field"

local sTopics      -- one line per topic folder name
local sTopic       -- the chosen topic's line number
local sStep        -- the chosen step number
local sSteps       -- how many steps the chosen topic has
local sEngine      -- "Vibecode3D" or "xt3d"
local sDefined     -- handler names the shown script defines (cr list)
local sXt3dOn      -- true while a step plays in the xt3d games bench
local sHttp        -- open requests to the bench, by socket

-------------------------------------------------------------------- open / close

on preOpenStack
   if there is not a field "Code" of card 1 of me then HT.Build
   -- owner, 19 Nov: big apps open at 200,32 at 0.95 scale, clear of the taskbar on 1536 x 864
   set the scaleFactor of me to 0.95
   set the topLeft of me to 200, 32
   if sEngine is empty then put "Vibecode3D" into sEngine
   HT.ShowEngine
   HT.LoadTopics
   put the cTopic of me into sTopic
   if sTopic is not an integer then put 1 into sTopic
   put the cStep of me into sStep
   if sStep is not an integer then put 1 into sStep
   HT.ShowTopic sTopic, sStep
end preOpenStack

-- LIB_ALPHA 12b: closing frees the stack; the step window goes with it
on closeStackRequest
   HT.Stop
   set the destroyStack of me to true
   pass closeStackRequest
end closeStackRequest

on closeStack
   HT.Stop
   pass closeStack
end closeStack

-- the step window sits on the viewport: keep it there and in front
on moveStack
   if there is a stack kPlay then set the rect of stack kPlay to HT.ViewportOnScreen()
   pass moveStack
end moveStack

on resumeStack
   if there is a stack kPlay then send "HT.Raise" to me in 20 milliseconds
   pass resumeStack
end resumeStack

command HT.Raise
   if there is a stack kPlay then
      if the mode of stack kPlay is not 0 then go stack kPlay
   end if
end HT.Raise

-------------------------------------------------------------------- clicks and keys

on mouseUp pButton
   local tName
   if pButton is not 1 then pass mouseUp
   put the short name of the target into tName
   switch tName
      case "Prev"
         HT.GoStep sStep - 1
         break
      case "Next"
         HT.GoStep sStep + 1
         break
      case "Run"
         HT.RunStep
         break
      case "Stop"
         HT.Stop
         HT.Status "Stopped."
         break
      case "EngineXT"
         put "Vibecode3D" into sEngine
         HT.ShowEngine
         break
      case "EngineXRay"
         put "xt3d" into sEngine
         HT.ShowEngine
         break
      case "Topics"
         if the hilitedLine of field "Topics" of card 1 of me is an integer then
            HT.ShowTopic the hilitedLine of field "Topics" of card 1 of me, 1
         end if
         break
      case "Steps"
         if the hilitedLine of field "Steps" of card 1 of me is an integer then
            HT.GoStep the hilitedLine of field "Steps" of card 1 of me
         end if
         break
      default
         pass mouseUp
   end switch
end mouseUp

on arrowKey pWhich
   switch pWhich
      case "left"
         HT.GoStep sStep - 1
         break
      case "right"
         HT.GoStep sStep + 1
         break
      case "up"
         if sTopic > 1 then HT.ShowTopic sTopic - 1, 1
         break
      case "down"
         if sTopic < the number of lines of sTopics then HT.ShowTopic sTopic + 1, 1
         break
      default
         pass arrowKey
   end switch
end arrowKey

on returnKey
   HT.RunStep
end returnKey

-------------------------------------------------------------------- files

-- the projects folder: the nearest folder above this stack's file that holds LIB_LLMOUT
function HT.Projects
   local tP
   put the effective fileName of me into tP
   set the itemDelimiter to "/"
   repeat while the number of items of tP > 1
      delete the last item of tP
      if there is a folder (tP & "/LIB_LLMOUT") then return tP
   end repeat
   return kFallbackProjects
end HT.Projects

function HT.TopicsFolder
   return HT.Projects() & "/LIB_HOWTO/topics"
end HT.TopicsFolder

function HT.ReadText pPath
   local tData
   if there is not a file pPath then return empty
   put URL ("binfile:" & pPath) into tData
   put textDecode(tData, "UTF-8") into tData
   replace numToChar(13) with empty in tData
   return tData
end HT.ReadText

function HT.StepFile pStep, pExt
   return HT.TopicsFolder() & "/" & line sTopic of sTopics & "/step_" & pStep & pExt
end HT.StepFile

-- "Title: x" -> x, from a step's words
function HT.Words pText, pLabel
   local tLine, tFrom
   put the length of pLabel + 2 into tFrom
   repeat for each line tLine in pText
      if tLine begins with (pLabel & ":") then
         delete char 1 to tFrom - 1 of tLine
         return word 1 to -1 of tLine
      end if
   end repeat
   return empty
end HT.Words

-------------------------------------------------------------------- topics and steps

command HT.LoadTopics
   local tList, tF, tShow
   put folders(HT.TopicsFolder()) into tList
   filter tList with "[0-9][0-9]_*"
   sort lines of tList ascending
   put tList into sTopics
   repeat for each line tF in tList
      replace "_" with " " in tF
      put char 1 to 2 of tF && char 4 to -1 of tF & cr after tShow
   end repeat
   delete the last char of tShow
   put tShow into field "Topics" of card 1 of me
   if sTopics is empty then HT.Status "No topics found in" && HT.TopicsFolder()
end HT.LoadTopics

command HT.ShowTopic pTopic, pStep
   local tFiles, tShow, i, tTitle
   if pTopic < 1 or pTopic > the number of lines of sTopics then exit HT.ShowTopic
   HT.Stop
   put pTopic into sTopic
   set the hilitedLine of field "Topics" of card 1 of me to sTopic
   put files(HT.TopicsFolder() & "/" & line sTopic of sTopics) into tFiles
   filter tFiles with "step_*.livecodescript"
   put the number of lines of tFiles into sSteps
   repeat with i = 1 to sSteps
      put HT.Words(HT.ReadText(HT.StepFile(i, ".txt")), "Title") into tTitle
      put i & "  " & tTitle & cr after tShow
   end repeat
   delete the last char of tShow
   put tShow into field "Steps" of card 1 of me
   HT.GoStep pStep
end HT.ShowTopic

command HT.GoStep pStep
   if sSteps < 1 then exit HT.GoStep
   if pStep < 1 or pStep > sSteps then exit HT.GoStep
   HT.Stop
   put pStep into sStep
   set the hilitedLine of field "Steps" of card 1 of me to sStep
   set the cTopic of me to sTopic
   set the cStep of me to sStep
   HT.ShowWords
   HT.ShowCode
   set the enabled of graphic "Prev" of card 1 of me to (sStep > 1)
   set the enabled of graphic "Next" of card 1 of me to (sStep < sSteps)
   HT.Viewport "Step" && sStep && "of" && sSteps & ". Press Run this step (or Return)."
   HT.Status empty
end HT.GoStep

command HT.ShowWords
   local tWords, tCode, tAdding, tH, tName
   put HT.ReadText(HT.StepFile(sStep, ".txt")) into tWords
   put HT.ReadText(HT.StepFile(sStep, ".livecodescript")) into tCode
   put HT.Words(line 2 of tCode, "-- Adding") into tAdding
   put line sTopic of field "Topics" of card 1 of me into tName
   put "<p><font color=" & quote & HT.Hex(kDim) & quote & ">" & HT.Esc(tName) & "</font></p>" into tH
   put "<p><b><font size=" & quote & "17" & quote & ">Step" && sStep && "of" && sSteps & ":" && HT.Esc(HT.Words(tWords, "Title")) & "</font></b></p>" after tH
   if tAdding is not empty then put HT.Label("Adding", tAdding) after tH
   put HT.Label("Makes this happen", HT.Words(tWords, "Makes this happen")) after tH
   put HT.Label("Look for", HT.Words(tWords, "Look for")) after tH
   set the htmlText of field "Words" of card 1 of me to tH
end HT.ShowWords

function HT.Label pLabel, pText
   return "<p><font color=" & quote & HT.Hex(kAccent) & quote & ">" & pLabel & ":</font>" && HT.Esc(pText) & "</p>"
end HT.Label

-------------------------------------------------------------------- the code field

-- the whole script after this step; lines that were not in the step before are marked
command HT.ShowCode
   local tCode, tOld, tH, tLine, i, tFirst, tNew, tSeen
   put HT.ReadText(HT.StepFile(sStep, ".livecodescript")) into tCode
   if sStep > 1 then put HT.ReadText(HT.StepFile(sStep - 1, ".livecodescript")) into tOld
   HT.FindDefined tCode
   repeat for each line tLine in tCode
      put HT.ColourLine(tLine) into tLine
      if tLine is empty then put " " into tLine
      put "<p>" & tLine & "</p>" after tH
   end repeat
   set the htmlText of field "Code" of card 1 of me to tH
   -- mark what is new (lines 1-3 are the step's header comment)
   put 0 into i
   put 0 into tFirst
   put 0 into tNew
   repeat for each line tLine in tCode
      add 1 to i
      if i < 4 or sStep is 1 then next repeat
      if word 1 to -1 of tLine is empty then next repeat
      if tLine is among the lines of tOld then next repeat
      set the backgroundColor of line i of field "Code" of card 1 of me to kNewLine
      add 1 to tNew
      if tFirst is 0 then put i into tFirst
   end repeat
   if tFirst > 4 then
      set the vScroll of field "Code" of card 1 of me to (tFirst - 4) * the effective textHeight of field "Code" of card 1 of me
   else
      set the vScroll of field "Code" of card 1 of me to 0
   end if
   if sStep is 1 then
      put "the whole script is new" into tSeen
   else if tNew is 1 then
      put "1 line new in this step (green)" into tSeen
   else
      put tNew && "lines new in this step (green)" into tSeen
   end if
   put "CODE  -  " & tSeen into field "CodeLabel" of card 1 of me
end HT.ShowCode

command HT.FindDefined pCode
   local tLine
   put empty into sDefined
   repeat for each line tLine in pCode
      if word 1 of tLine is "private" then delete word 1 of tLine
      if word 1 of tLine is among the items of "on,function,command" then put word 2 of tLine & cr after sDefined
   end repeat
end HT.FindDefined

-- one line of script as htmlText: comments, strings, numbers, keywords, handler names, engine calls
function HT.ColourLine pLine
   local tPos, tCode, tCom
   put HT.CommentStart(pLine) into tPos
   if tPos > 0 then
      put char 1 to tPos - 1 of pLine into tCode
      put char tPos to -1 of pLine into tCom
   else
      put pLine into tCode
   end if
   put HT.ColourCode(tCode) into tCode
   if tCom is not empty then put HT.Span(tCom, "comment") after tCode
   return tCode
end HT.ColourLine

-- where a -- or # comment starts (0: none), outside strings
function HT.CommentStart pLine
   local i, c, bInString
   put false into bInString
   repeat with i = 1 to the length of pLine
      put char i of pLine into c
      if c is quote then
         put not bInString into bInString
      else if bInString is false then
         if c is "#" then return i
         if c is "-" and char i + 1 of pLine is "-" then return i
      end if
   end repeat
   return 0
end HT.CommentStart

function HT.ColourCode pCode
   local i, n, c, tTok, tOut, tEnd, tPrev
   put the length of pCode into n
   put 1 into i
   repeat while i <= n
      put char i of pCode into c
      if c is quote then
         put offset(quote, pCode, i) into tEnd
         if tEnd is 0 then put n - i into tEnd
         put HT.Span(char i to i + tEnd of pCode, "string") after tOut
         add tEnd + 1 to i
      else if offset(c, kIdent) > 0 then
         put empty into tTok
         repeat while i <= n
            if offset(char i of pCode, kIdent) is 0 then exit repeat
            put char i of pCode after tTok
            add 1 to i
         end repeat
         put HT.Span(tTok, HT.Kind(tTok, tPrev)) after tOut
         put tTok into tPrev
      else
         put HT.Esc(c) after tOut
         add 1 to i
      end if
   end repeat
   return tOut
end HT.ColourCode

function HT.Kind pTok, pPrev
   if pTok is a number then return "number"
   if pPrev is among the items of "on,function,command,end" then return "handler"
   if pTok is among the lines of sDefined then return "handler"
   if pTok contains "." then
      if char 1 of pTok is among the chars of "ABCDEFGHIJKLMNOPQRSTUVWXYZ" then return "engine"
   end if
   if pTok is among the items of kKeywords then return "keyword"
   return "plain"
end HT.Kind

function HT.Span pText, pKind
   local tC, tB
   switch pKind
      case "comment"
         put "120,132,150" into tC
         break
      case "string"
         put "152,214,130" into tC
         break
      case "number"
         put "247,166,98" into tC
         break
      case "keyword"
         put "198,146,234" into tC
         break
      case "handler"
         put "255,121,168" into tC
         put true into tB
         break
      case "engine"
         put "255,214,102" into tC
         break
      default
         return HT.Esc(pText)
   end switch
   if tB is true then return "<b><font color=" & quote & HT.Hex(tC) & quote & ">" & HT.Esc(pText) & "</font></b>"
   return "<font color=" & quote & HT.Hex(tC) & quote & ">" & HT.Esc(pText) & "</font>"
end HT.Span

function HT.Esc pText
   replace "&" with "&amp;" in pText
   replace "<" with "&lt;" in pText
   replace ">" with "&gt;" in pText
   return pText
end HT.Esc

function HT.Hex pRGB
   return "#" & format("%02X%02X%02X", item 1 of pRGB, item 2 of pRGB, item 3 of pRGB)
end HT.Hex

-------------------------------------------------------------------- running a step

-- the viewport's rect in screen pixels
-- (the stack's scaleFactor shrinks it on screen: scale the card's offsets too)
function HT.ViewportOnScreen
   local tR, tS, tK
   put the rect of graphic "Viewport" of card 1 of me into tR
   put the rect of me into tS
   put the scaleFactor of me into tK
   if tK is not a number then put 1 into tK
   return item 1 of tS + round((item 1 of tR + 1) * tK), item 2 of tS + round((item 2 of tR + 1) * tK), \
         item 1 of tS + round((item 3 of tR - 1) * tK), item 2 of tS + round((item 4 of tR - 1) * tK)
end HT.ViewportOnScreen

command HT.RunStep
   local tP, tWhy, tScript, tErr
   if sSteps < 1 then exit HT.RunStep
   HT.Stop
   put HT.Projects() into tP
   put HT.ReadText(HT.StepFile(sStep, ".livecodescript")) into tScript
   if tScript is empty then
      HT.Status "No step file:" && HT.StepFile(sStep, ".livecodescript")
      exit HT.RunStep
   end if
   if sEngine is "xt3d" then
      HT.RunXt3d
      exit HT.RunStep
   end if
   try
      if not ("GameLaunch" is among the lines of the stacksInUse) then start using stack (tP & "/LIB_DEV/livecode/game_launch.livecodescript")
   catch tErr
      HT.Status "The game launcher did not load:" && line 1 of tErr
      exit HT.RunStep
   end try
   put GL.Open(tP, "Simple_Test1", false) into tWhy
   if tWhy is not empty then
      HT.Status "Could not open the player:" && tWhy
      exit HT.RunStep
   end if
   -- the player starts the card in 50 ms: swap in this step's script first
   set the script of card 1 of stack kPlay to tScript
   if the result is not empty then
      put the result into tErr
      close stack kPlay
      HT.Status "This step does not compile:" && tErr
      exit HT.RunStep
   end if
   set the uPrefix of stack kPlay to empty
   set the uGame of stack kPlay to "HOWTO" && sTopic & "." & sStep
   set the decorations of stack kPlay to empty
   set the rect of stack kPlay to HT.ViewportOnScreen()
   set the title of stack kPlay to "FOR OWNER | HOWTO step"
   HT.Viewport empty
   HT.Status "Running step" && sStep & ". Escape pauses, ... (top right of the view) has Reset; Stop ends it."
end HT.RunStep

command HT.Stop
   if there is a stack kPlay then
      if the mode of stack kPlay is not 0 then close stack kPlay
   end if
   if sXt3dOn is true then
      put false into sXt3dOn
      if HT.BenchAlive() then get HT.Bench("POST", "/run", "xbStopGame", 3000)
   end if
end HT.Stop

-------------------------------------------------------------------- running a step in xt3d

-- the step file is played by the xt3d games bench (its own window, raylib's 3D view):
-- its xbPlayFile makes the file its card script, as the Game Player does. Started if needed.
command HT.RunXt3d
   local tP, tStart, tCode, tReply, tName
   put HT.Projects() into tP
   if not HT.BenchAlive() then
      if there is not a file (tP & "/" & kBenchExe) then
         HT.Status "No xt3d games bench at" && tP & "/" & kBenchExe & " (xt3D_Raylib_Livecode_Bridge/standalone/README.md)"
         exit HT.RunXt3d
      end if
      HT.Status "Starting the xt3d games bench..."
      HT.Viewport "starting the xt3d games bench"
      HT.StartExe tP & "/" & kBenchExe
      put the milliseconds into tStart
      repeat until HT.BenchAlive() or the milliseconds - tStart > 30000
         set the cursor to busy
         wait 500 milliseconds with messages
      end repeat
      if not HT.BenchAlive() then
         HT.Status "The xt3d games bench did not answer on port" && kBenchPort && "within 30 seconds."
         HT.Viewport empty
         exit HT.RunXt3d
      end if
      wait 4 seconds with messages      -- it opens its window and raylib after its server
   end if
   put "HOWTO" && char 1 to 2 of line sTopic of sTopics & "." & sStep into tName
   -- the bench window may have been closed while its server runs on: open it again
   put "if there is not a stack" && quote & kBenchStack & quote && "or the mode of stack" && quote & kBenchStack & quote && "is 0 then" && \
         "go stack" && quote & tP & "/" & kBenchScript & quote & return & \
         "set the defaultStack to" && quote & kBenchStack & quote & return & \
         "xbPlayFile" && quote & HT.StepFile(sStep, ".livecodescript") & quote & "," && quote & tName & quote & return & \
         "return the result" into tCode
   put HT.Bench("POST", "/run", tCode, 15000) into tReply
   if tReply begins with "result:" then delete word 1 of tReply
   if word 1 to -1 of tReply is not empty then
      HT.Status "xt3d:" && tName && "did not start:" && line 1 to 3 of tReply
      exit HT.RunXt3d
   end if
   put true into sXt3dOn
   HT.Viewport "playing in the xt3d games bench window"
   HT.Status "Running step" && sStep && "in the xt3d games bench (its own window). Escape there ends it; Stop here too."
end HT.RunXt3d

command HT.StartExe pPath
   replace "/" with "\" in pPath
   open process (quote & pPath & quote) for neither
end HT.StartExe

function HT.BenchToken
   return line 1 of HT.ReadText("C:/LIB_MCP/devtoken_" & kBenchPort & ".txt")
end HT.BenchToken

function HT.BenchAlive
   if HT.BenchToken() is empty then return false
   return HT.Bench("GET", "/ping", empty, 1500) begins with "OK"
end HT.BenchAlive

function HT.Bench pMethod, pRoute, pBody, pTimeoutMs
   return HT.Http(pMethod, pRoute, pBody, HT.BenchToken(), pTimeoutMs)
end HT.Bench

-- one request to the bench over a socket of our own (no shell; the window keeps working
-- while it waits). Same as LIB_DEV/livecode/game_browser.livecodescript GB.Http.
function HT.Http pMethod, pRoute, pBody, pToken, pTimeoutMs
   local tSock, tReq, tBytes, tStart, tState, tData, tAt
   put "127.0.0.1:" & kBenchPort & "|ht" & the milliseconds into tSock
   put textEncode(pBody, "UTF-8") into tBytes
   put pMethod && pRoute && "HTTP/1.1" & crlf & "Host: 127.0.0.1:" & kBenchPort & crlf & \
         "X-Token: " & pToken & crlf & "Connection: close" & crlf into tReq
   if pMethod is "POST" then
      put "Content-Type: text/plain; charset=utf-8" & crlf & \
            "Content-Length: " & the number of bytes of tBytes & crlf after tReq
   end if
   put crlf after tReq
   put empty into sHttp[tSock]["state"]
   put empty into sHttp[tSock]["data"]
   put textEncode(tReq, "UTF-8") & tBytes into sHttp[tSock]["send"]
   put the milliseconds into tStart
   open socket to tSock with message "HT.HttpOpen"
   if the result is not empty then
      delete variable sHttp[tSock]
      return "(error:" && the result & ")"
   end if
   repeat until sHttp[tSock]["state"] is not empty or the milliseconds - tStart > pTimeoutMs
      set the cursor to busy
      wait 20 milliseconds with messages
   end repeat
   put sHttp[tSock]["state"] into tState
   put sHttp[tSock]["data"] into tData
   if tState is empty then
      -- closed when it answers or fails (closing it now lets its late error hit the next one)
      put "abandoned" into sHttp[tSock]["state"]
      return "(no answer in" && pTimeoutMs && "ms)"
   end if
   delete variable sHttp[tSock]
   close socket tSock
   if tState begins with "error" then return "(" & tState & ")"
   put offset(crlf & crlf, tData) into tAt
   if tAt > 0 then delete char 1 to tAt + 3 of tData
   return textDecode(tData, "UTF-8")
end HT.Http

on HT.HttpOpen pSock
   if pSock is not among the lines of the keys of sHttp then exit HT.HttpOpen
   if sHttp[pSock]["state"] is "abandoned" then
      delete variable sHttp[pSock]
      close socket pSock
      exit HT.HttpOpen
   end if
   write sHttp[pSock]["send"] to socket pSock
   read from socket pSock with message "HT.HttpRead"
end HT.HttpOpen

on HT.HttpRead pSock, pData
   if pSock is not among the lines of the keys of sHttp then exit HT.HttpRead
   if sHttp[pSock]["state"] is "abandoned" then exit HT.HttpRead
   put pData after sHttp[pSock]["data"]
   if HT.HttpComplete(sHttp[pSock]["data"]) then
      put "done" into sHttp[pSock]["state"]
   else
      read from socket pSock with message "HT.HttpRead"
   end if
end HT.HttpRead

on socketError pSock, pErr
   if pSock is not among the lines of the keys of sHttp then pass socketError
   if sHttp[pSock]["state"] is "abandoned" then
      delete variable sHttp[pSock]
   else
      put "error" && pErr into sHttp[pSock]["state"]
   end if
end socketError

on socketClosed pSock
   if pSock is not among the lines of the keys of sHttp then pass socketClosed
   if sHttp[pSock]["state"] is "abandoned" then
      delete variable sHttp[pSock]
   else
      put "done" into sHttp[pSock]["state"]
   end if
end socketClosed

-- the whole reply is in: the head, and as many body bytes as its Content-Length
function HT.HttpComplete pData
   local tAt, tHead, tLen, tLine
   put offset(crlf & crlf, pData) into tAt
   if tAt is 0 then return false
   put char 1 to tAt of pData into tHead
   replace numToChar(13) with empty in tHead
   put empty into tLen
   repeat for each line tLine in tHead
      if tLine begins with "Content-Length:" then put word 2 of tLine into tLen
   end repeat
   if tLen is not an integer then return false
   return the number of bytes of pData - (tAt + 3) >= tLen
end HT.HttpComplete

-------------------------------------------------------------------- small helpers

command HT.Status pText
   put pText into field "Status" of card 1 of me
end HT.Status

command HT.Viewport pText
   set the label of graphic "Viewport" of card 1 of me to pText
end HT.Viewport

command HT.ShowEngine
   if sEngine is "xt3d" then
      set the backgroundColor of graphic "EngineXRay" of card 1 of me to kOn
      set the backgroundColor of graphic "EngineXT" of card 1 of me to kButton
   else
      set the backgroundColor of graphic "EngineXT" of card 1 of me to kOn
      set the backgroundColor of graphic "EngineXRay" of card 1 of me to kButton
   end if
end HT.ShowEngine

-------------------------------------------------------------------- building the controls

-- makes every control of card 1 again (run once, or after a layout change in this file)
command HT.Build
   local i
   lock screen
   lock messages
   repeat with i = the number of controls of card 1 of me down to 1
      delete control i of card 1 of me
   end repeat
   set the width of me to kW
   set the height of me to kH
   set the resizable of me to false
   set the backgroundColor of me to kPaper
   set the foregroundColor of me to kInk
   set the textFont of me to "Segoe UI"
   set the textSize of me to 13
   -- left: topics and steps
   HT.MakeLabel "TopicsLabel", "TOPICS", 8, 8, kLeftW - 8, 30
   HT.MakeList "Topics", 8, 32, kLeftW - 8, 470
   HT.MakeLabel "StepsLabel", "STEPS", 8, 480, kLeftW - 8, 504
   HT.MakeList "Steps", 8, 506, kLeftW - 8, kH - 8
   -- right top: engine toggle and viewport
   HT.MakeLabel "EngineLabel", "ENGINE", kLeftW + 8, 8, kLeftW + 80, 32
   HT.MakeButton "EngineXT", "Vibecode3D", kLeftW + 84, 6, kLeftW + 204, 32
   HT.MakeButton "EngineXRay", "xt3d", kLeftW + 210, 6, kLeftW + 290, 32
   HT.MakeLabel "Hint", "Left / Right: steps    Up / Down: topics    Return: run", kLeftW + 300, 8, kW - 8, 32
   set the textAlign of field "Hint" of card 1 of me to "right"
   set the foregroundColor of field "Hint" of card 1 of me to kDim
   reset the templateGraphic
   set the style of the templateGraphic to "rectangle"
   set the filled of the templateGraphic to true
   set the backgroundColor of the templateGraphic to "0,0,0"
   set the foregroundColor of the templateGraphic to "60,70,85"
   set the textColor of the templateGraphic to kDim
   create graphic "Viewport"
   set the rect of it to kLeftW + 8, 38, kW - 8, 470
   set the showName of it to true
   set the textSize of it to 15
   -- right bottom: the step's words, the code, the buttons
   HT.MakeField "Words", kLeftW + 8, 478, kW - 8, 574
   set the dontWrap of field "Words" of card 1 of me to false
   HT.MakeLabel "CodeLabel", "CODE", kLeftW + 8, 578, kW - 8, 598
   set the foregroundColor of field "CodeLabel" of card 1 of me to kDim
   HT.MakeField "Code", kLeftW + 8, 600, kW - 8, kH - 46
   set the textFont of field "Code" of card 1 of me to "Consolas"
   set the textSize of field "Code" of card 1 of me to 14
   set the fixedLineHeight of field "Code" of card 1 of me to true
   set the textHeight of field "Code" of card 1 of me to 18
   set the vScrollbar of field "Code" of card 1 of me to true
   set the backgroundColor of field "Code" of card 1 of me to "10,12,16"
   HT.MakeButton "Prev", "<  step", kLeftW + 8, kH - 38, kLeftW + 108, kH - 8
   HT.MakeButton "Run", "Run this step", kLeftW + 116, kH - 38, kLeftW + 266, kH - 8
   HT.MakeButton "Stop", "Stop", kLeftW + 274, kH - 38, kLeftW + 354, kH - 8
   HT.MakeButton "Next", "step  >", kLeftW + 362, kH - 38, kLeftW + 462, kH - 8
   set the backgroundColor of graphic "Run" of card 1 of me to kOn
   HT.MakeLabel "Status", empty, kLeftW + 474, kH - 36, kW - 8, kH - 10
   set the foregroundColor of field "Status" of card 1 of me to kAccent
   unlock messages
   unlock screen
end HT.Build

command HT.TemplateField
   reset the templateField
   set the textColor of the templateField to kInk
   set the foregroundColor of the templateField to kInk
   set the backgroundColor of the templateField to kPanel
   set the borderColor of the templateField to "50,60,75"
   set the hiliteColor of the templateField to kOn
   set the opaque of the templateField to true
   set the lockText of the templateField to true
   set the threeD of the templateField to false
   set the showFocusBorder of the templateField to false
   set the traversalOn of the templateField to false
end HT.TemplateField

command HT.MakeLabel pName, pText, pL, pT, pR, pB
   HT.TemplateField
   set the opaque of the templateField to false
   set the showBorder of the templateField to false
   set the textColor of the templateField to kAccent
   set the foregroundColor of the templateField to kAccent
   create field pName
   set the rect of it to pL, pT, pR, pB
   set the dontWrap of it to true
   put pText into it
end HT.MakeLabel

command HT.MakeList pName, pL, pT, pR, pB
   HT.TemplateField
   create field pName
   set the rect of it to pL, pT, pR, pB
   set the listBehavior of it to true
   set the dontWrap of it to true
   set the vScrollbar of it to true
   set the textSize of it to 13
end HT.MakeList

command HT.MakeField pName, pL, pT, pR, pB
   HT.TemplateField
   create field pName
   set the rect of it to pL, pT, pR, pB
   set the dontWrap of it to true
end HT.MakeField

-- a button is a graphic (dark on every platform; Windows buttons ignore colours)
command HT.MakeButton pName, pLabel, pL, pT, pR, pB
   reset the templateGraphic
   set the style of the templateGraphic to "roundRect"
   set the filled of the templateGraphic to true
   set the backgroundColor of the templateGraphic to kButton
   set the foregroundColor of the templateGraphic to kInk
   set the textColor of the templateGraphic to kInk
   create graphic pName
   set the rect of it to pL, pT, pR, pB
   set the roundRadius of it to 8
   set the showName of it to true
   set the label of it to pLabel
end HT.MakeButton
