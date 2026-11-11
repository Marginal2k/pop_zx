"""Check that src/game.asm + src/game_part.asm, resolved for each LVL, give back
exactly the 13 original (protection-stripped) PRn / PARTn sources."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import make_src as M
def resolve(lines, lvl):
    out = []; stack = []
    for l in lines:
        m = re.match(r'^    IF (.*)$', l)
        if m:
            stack.append(eval(m.group(1).replace('||', ' or ').replace('&&', ' and '), {'LVL': lvl})); continue
        if l == '    ELSE': stack[-1] = not stack[-1]; continue
        if l == '    ENDIF': stack.pop(); continue
        if all(stack): out.append(l)
    return out
def body(rel):
    L = open(os.path.join(M.SRC, rel), encoding='utf-8').read().split('\n')[:-1]
    return L[8:] if rel == 'game.asm' else L[7:]
ksym = M.kernel_syms(); bad = 0
g = body('game.asm'); gp = body('game_part.asm')
# lines added by hand after the merge (torch flame data at 39450)
ADDED = ('; Torch flame', '; from 39450', 'FIREGFX EQU', '        ORG     FIREGFX', '        INCBIN  "fire.bin"')
g = [l for l in g if not l.startswith(ADDED)]
for n in range(1, 14):
    L = M.symbolize_disk(M.strip_protection(M.load(M.COM, 'PR%d' % n), 'PR%d' % n), 'x', [])
    exp = []
    for l in L:
        if re.match(r'^\s+INCLUDE\s+"ABLOCK1.asm"', l): exp += ['        INCLUDE "kernel_api.inc"', '        INCLUDE "disk.inc"']
        elif re.match(r'^\s+INCLUDE\s+"PART\d+.asm"', l): exp.append('        INCLUDE "game_part.asm"')
        elif re.match(r'^\s+INCLUDE\s+"LEVEL\d+.asm"', l): exp.append('        INCLUDE "levels/level%02d.asm"' % n)
        else: exp.append(l)
    while exp and not exp[-1].strip(): exp.pop()
    got = resolve(g, n)
    P = M.load(M.COM, 'PART%d' % n)
    P = [l.replace('LD      IX,STL', 'LD      IX,STL+10       ; as on the master disk (source said STL)') if n == 13 and l == '        LD      IX,STL' else l for l in P]
    P = M.drop_kernel_equs(P, ksym, set(), 'x', [])
    gotp = resolve(gp, n)
    ok = got == exp and gotp == P
    bad += not ok
    print('level %2d: game.asm %s, game_part.asm %s' % (n, 'OK' if got == exp else 'DIFF', 'OK' if gotp == P else 'DIFF'))
sys.exit(bad)
