# LIB_HOWTO: notes for AI models
- Read `../LIB_SYSTEM/LIB_ALPHA.md` first (as everywhere).
- Spark writes words only (outlines, step titles, "makes this happen"); Claude writes the code.
- Each step's code is the smallest change that shows something new; it must compile and pass a
  headless run (`../LIB_GAMES/tools/headless_play.sh`, on the spark-arcade branch).
- Only real engine calls (`../Vibecode3D/LiveCode_Claude_Kit/kit/docs/engine-api.md`); a step must
  run unchanged in Vibecode3D and the xt3d bench.
