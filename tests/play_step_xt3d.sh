#!/usr/bin/env bash
# play_step_xt3d.sh - play LIB_HOWTO steps in the xt3d games bench (xRay) and say how each went.
#   tests/play_step_xt3d.sh [step files...]      (none = all 92 steps, topic by topic)
#   SECONDS_EACH=2 SNAPS=C:/LIB_MCP/howto_xt3d tests/play_step_xt3d.sh ...
# Uses the bench's xbPlayFile (xt3D_Raylib_Livecode_Bridge/testbench, branch howto-xt3d):
# the step file is played as the bench card's script, nothing is written into LIB_GAMES.
# Prints one line a step: OK (+ the bench's stats line) or the error from the info field.
# Mouse-look steps: gNoMouse is on while it runs and off again at the end.
HERE="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
GB="$ROOT/xt3D_Raylib_Livecode_Bridge/tools/gamebench"
BENCH="//wsl\$/Ubuntu$ROOT/xt3D_Raylib_Livecode_Bridge/testbench/xt3d_testBench_lib_mcp.livecodescript"
EACH="${SECONDS_EACH:-2}"; SNAPS="${SNAPS:-}"
if [[ $# -eq 0 ]]; then
  mapfile -t FILES < <(ls "$HERE"/topics/*/step_*.livecodescript | sort -V)
else FILES=("$@"); fi
timeout 90 "$GB" run "if there is not a stack \"xt3dTestBenchLibMCP\" or the mode of stack \"xt3dTestBenchLibMCP\" is 0 then go stack \"$BENCH\"
wait 2 seconds with messages
global gNoMouse
put true into gNoMouse
return \"bench open\"" | sed 's/^result: //'
FAIL=0
for f in "${FILES[@]}"; do
  f="$(realpath "$f")"; rel="${f#$HERE/topics/}"
  name="HOWTO $(basename "$(dirname "$f")" | cut -c1-2).$(basename "$f" .livecodescript | sed 's/step_//')"
  snap=""; [[ -n "$SNAPS" ]] && snap="export snapshot from rect (the rect of image \"view\") of window (the windowID of this stack) to file \"$SNAPS/${name// /_}.png\" as PNG"
  out=$(timeout 60 "$GB" run "set the lockCursor to false
set the defaultStack to \"xt3dTestBenchLibMCP\"
xbPlayFile \"//wsl\$/Ubuntu$f\", \"$name\"
put the result into tR
wait $EACH seconds with messages
put tR & \"|\" & line 1 of field \"info\" & \"|\" & xbGameStats() into tOut
replace return with \" \" in tOut
$snap
xbStopGame
return tOut" 2>&1 | tr '\n' ' ' | sed 's/^result: //')
  if [[ "$out" == *"stopped by an error"* || "$out" == *"compile"* || "$out" == ERROR* || "$out" != "|Playing"* ]]; then
    echo "FAIL $rel: $out"; FAIL=$((FAIL+1))
    timeout 30 "$GB" eval 'field "info" of stack "xt3dTestBenchLibMCP"' | head -6 | sed 's/^/     /'
  else
    echo "OK   $rel: ${out##*|}"
  fi
done
timeout 30 "$GB" run 'global gNoMouse
put false into gNoMouse
return "mouse back"' >/dev/null
echo "failed: $FAIL of ${#FILES[@]}"
