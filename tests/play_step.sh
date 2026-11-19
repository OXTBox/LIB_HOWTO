#!/usr/bin/env bash
# play_step.sh - play one LIB_HOWTO step on the REAL engine and say what is in the scene.
#   tests/play_step.sh <step .livecodescript> [updates] [snap.png] [call] [expr]
#   e.g. tests/play_step.sh topics/01_Game_card_and_loop/step_3.livecodescript 60 C:/LIB_MCP/s3.png
#   [call] "Handler|a|b" is dispatched to the card with "a","b" after the start (commas stay in
#   one argument: "Hero.TestKeys|119,100"); several are split by ";", 10 updates apart;
#   [expr] is evaluated on the card at the end and printed (e.g. "Cube.State()"). "-" skips one.
# Opens the Simple_Test1 game window (game_launch.livecodescript), swaps in the step's card
# script before the player starts it, lets it run [updates] steps of 33 ms (default 30), then
# prints: compile result, the scene objects (key, position, rotation), [expr],
# and any run-time errors from LIB_LLMIN/LIB_DEV/GAME_PLAYER_ERRORS.txt.
# Writes nothing into LIB_GAMES. Needs LIB_MCP's test standalone (port 8767).
STEP="$(realpath "$1")"; N="${2:-30}"; SNAP="${3:-}"; CALL="${4:-}"; EXPR="${5:-}"
[[ "$SNAP" == "-" ]] && SNAP=""; [[ "$CALL" == "-" ]] && CALL=""
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LCMCP="$ROOT/LIB_MCP/tools/lcmcp"
ERRS="$ROOT/LIB_LLMIN/LIB_DEV/GAME_PLAYER_ERRORS.txt"
W="//wsl\$/Ubuntu"
for _ in 1 2 3 4 5; do "$LCMCP" --standalone ping >/dev/null 2>&1 && break; sleep 2; done
BEFORE=0; [[ -f "$ERRS" ]] && BEFORE=$(wc -l < "$ERRS")
{
cat <<LC
global gSceneObjects, gObjectTransforms
put "$W$ROOT" into tP
if not ("GameLaunch" is among the lines of the stacksInUse) then start using stack (tP & "/LIB_DEV/livecode/game_launch.livecodescript")
put "Play Simple_Test1" into tS
if there is a stack tS then close stack tS
put GL.Open(tP, "Simple_Test1", false) into tWhy
if tWhy is not empty then return "OPEN FAILED: " & tWhy
put textDecode(URL ("binfile:$W$STEP"), "UTF-8") into tScript
replace numToChar(13) with empty in tScript
set the script of card 1 of stack tS to tScript
put "compile: " & the result & cr into tLog
set the uPrefix of stack tS to empty
set the title of stack tS to "127.0.0.1:8767 | CLAUDE | howto step"
if there is a field "PlayerMessage" of stack tS then hide field "PlayerMessage" of stack tS
wait 150 milliseconds with messages
LC
IFS=';' read -ra CALLS <<< "$CALL"
for c in "${CALLS[@]}"; do      # each "Handler|a|b": dispatched with "a","b"; 10 updates apart
  args="${c#*|}"; [[ "$c" != *"|"* ]] && args=""
  q=""; [[ -n "$args" ]] && q=" with \"${args//|/\",\"}\""
  echo "dispatch \"${c%%|*}\" to card 1 of stack tS$q"
  echo "wait 330 milliseconds with messages"
done
cat <<LC
wait ($N * 33) milliseconds with messages
put "objects: " & the number of lines of gSceneObjects & cr after tLog
repeat for each line tL in gSceneObjects
  put word 2 of tL into tK
  put "  " & tK && "at" && round(gObjectTransforms[tK]["x"]) & "," & round(gObjectTransforms[tK]["y"]) & "," & round(gObjectTransforms[tK]["z"]) && "rot" && round(gObjectTransforms[tK]["rotX"],2) & "," & round(gObjectTransforms[tK]["rotY"],2) & "," & round(gObjectTransforms[tK]["rotZ"],2) & cr after tLog
end repeat
LC
[[ -n "$EXPR" ]] && echo "put \"expr: \" & value(\"$EXPR\", card 1 of stack tS) & cr after tLog"
[[ -n "$SNAP" ]] && echo "export snapshot from card 1 of stack tS to file \"$SNAP\" as PNG"
cat <<LC
close stack tS
return tLog
LC
} | timeout 110 "$LCMCP" --standalone run - | sed 's/^result: //'
AFTER=0; [[ -f "$ERRS" ]] && AFTER=$(wc -l < "$ERRS")
if [[ "$AFTER" -gt "$BEFORE" ]]; then echo "ERRORS:"; tail -n $((AFTER - BEFORE)) "$ERRS" | head -12; fi
