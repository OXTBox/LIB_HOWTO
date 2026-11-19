#!/usr/bin/env python3
"""check_calls.py - every engine call a HOWTO step makes must exist in BOTH engines' scripts.

    python3 -I tests/check_calls.py [topics/03_*]        (default: every topic)

Engine 1 = the pure-xTalk Vibecode3D script (Vibecode3D/livecode/VIBECODE3D_LIB_MCP_*_647PM...);
the Game Player / xt3d bench run the GENERATED vibe_engine_xt3d.livecodescript, which adds
extra handlers (Entity.SetColor, Engine.Mouse, Camera.SetLook ...). A step may use only what
Engine 1 has, so it runs unchanged everywhere. Handlers the step defines itself are fine.
"""
import glob, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
ENG1 = sorted(glob.glob(os.path.join(ROOT, 'Vibecode3D/livecode/VIBECODE3D_LIB_MCP_*_647PM.livecodescript')))[-1]
ENG2 = os.path.join(ROOT, 'xt3D_Raylib_Livecode_Bridge/testbench/vibe_engine_xt3d.livecodescript')
DEF = re.compile(r'^\s*(?:on|function|command|private function|private command)\s+([A-Za-z_][\w.]*)', re.M)
# a dotted name, or one of the engine's old undotted names
CALL = re.compile(r'\b([A-Z][A-Za-z0-9]*\.[A-Za-z][\w.]*|Mesh[A-Z]\w*|SetObject\w+|GetObject\w+|ScreenToCameraRay|RayCastScene)\b')


def defs(path):
    return set(DEF.findall(open(path, encoding='utf-8', errors='replace').read()))


def main():
    e1, e2 = defs(ENG1), defs(ENG2)
    hooks = {'Game.OnStart', 'Game.OnUpdate', 'Game.OnStop', 'Game.OnClick', 'Game.OnKill',
             'Game.OnPause', 'Game.OnResume', 'Collision.Hit'}
    dirs = sys.argv[1:] or sorted(glob.glob(os.path.join(HERE, '..', 'topics', '[0-9][0-9]_*')))
    bad = 0
    for d in dirs:
        for f in sorted(glob.glob(os.path.join(d, 'step_*.livecodescript'))):
            text = open(f, encoding='utf-8').read()
            code = '\n'.join(l.split('--')[0] for l in text.splitlines())   # not in comments
            code = re.sub(r'"[^"\n]*"', '""', code)                              # not in strings
            own = set(DEF.findall(text))
            for name in sorted(set(CALL.findall(code)) - own - hooks):
                where = 'missing in BOTH engines' if name not in e2 else 'only in the generated (xt3d / Game Player) engine'
                if name not in e1:
                    print('%s: %s %s' % (os.path.relpath(f, os.path.join(HERE, '..')), name, where))
                    bad += 1
    print('check_calls: %d problem(s)' % bad)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
