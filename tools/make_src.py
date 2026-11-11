"""One-time generator: faithful TASM conversions (original_src/) -> clean sjasmplus project (src/).

  * removes the copy protection (R-register XOR decryptors, raw-track checks)
  * replaces hard-coded disk positions with symbols from disk.inc
  * merges the 13 per-level copies of the engine (PRn + PARTn) into one source
    with IF LVL conditionals
  * replaces hand-maintained kernel address tables with the exported kernel API

The result in src/ is the thing to edit; this script is kept for provenance.
"""
import os, re, sys, difflib

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
ARC = os.path.join(ROOT, 'original_src', 'archive')
COM = os.path.join(ROOT, 'original_src', 'compile')
SRC = os.path.join(ROOT, 'src')
NLEV = 13

# ---- disk map of the master disk: name -> (track/sector word, sectors, comment)
DISK = [
    ('PRINCE',   0x0100, 64,  'prince sprites, set 1          -> page 6 (#C000)'),
    ('HIGH',     0x0500, 5,   'small sprites/digits           -> 57458'),
    ('PRINCE1',  0x0505, 64,  'prince sprites, set 2          -> page 1 (#C000)'),
    ('PRINCE2',  0x0905, 33,  'enemy sprites (guard)          -> page 3 (#C000)'),
    ('FIRE',     0x0B06, 1,   'torch flame (not loaded by the game)'),
    ('LONGGATE', 0x0B07, 17,  'gates/doors graphics, set 1    -> 61200 (page 3)'),
    ('LONGGATA', 0x0C08, 17,  'gates/doors graphics, set 2'),
    ('PRINCE2A', 0x0D09, 33,  'enemy sprites, set A'),
    ('LOADING',  0x0F0A, 27,  'loading screen                 -> #4000'),
    ('PRINCE2C', 0x1105, 33,  'enemy sprites, set C (level 13)'),
    ('STEELMIR', 0x1306, 10,  'blades + mirror graphics       -> 58608 (page 3)'),
    ('MUSIC',    0x1400, 44,  'in-game music + player         -> page 4 (#C000)'),
    ('TILES',    0x160C, 38,  'dungeon tiles + drawing code   -> #D800 (page 0)'),
    ('TILESA',   0x1902, 38,  'palace tiles + drawing code    -> #D800 (page 0)'),
    ('ENDFILE',  0x1B08, 34,  'ending sprites                 -> page 3 (#C000)'),
    ('FONT1',    0x1D0A, 3,   'ending font                    -> 59282'),
    ('OMUSIC',   0x1D0D, 9,   'ending music                   -> page 4 (#C000)'),
    ('ENDING',   0x1E06, 41,  'ending program                 -> 29300'),
    ('LEVEL13',  0x200F, 46,  'level 13 program               -> 29300'),
    ('PRINCE2B', 0x230D, 33,  'enemy sprites, set B (level 12)'),
    ('LONGGATB', 0x250E, 17,  'gates/doors graphics, set 3'),
    ('LEVEL12',  0x260F, 46,  ''),
    ('CUT1',     0x290D, 30,  'cutscene (after levels 1,5,11) -> 39000'),
    ('LEVEL11',  0x2B0B, 46,  ''),
    ('LEVEL10',  0x2E09, 46,  ''),
    ('LEVEL9',   0x3107, 46,  ''),
    ('CUT4',     0x3405, 31,  'cutscene (after level 8)       -> 39000'),
    ('CUT3',     0x3604, 31,  'cutscene (after level 7)       -> 39000'),
    ('LEVEL8',   0x3803, 46,  ''),
    ('LEVEL7',   0x3B01, 46,  ''),
    ('LEVEL6',   0x3D0F, 46,  ''),
    ('LEVEL5',   0x400D, 46,  ''),
    ('LEVEL4',   0x430B, 46,  ''),
    ('CUT2',     0x4609, 30,  'cutscene (after level 3)       -> 39000'),
    ('LEVEL3',   0x4807, 46,  ''),
    ('LEVEL2',   0x4B05, 46,  ''),
    ('LEVEL1',   0x4E03, 46,  'level 1 program                -> 29300'),
    ('MENU',     0x5101, 46,  'main menu / password entry     -> 29300'),
    ('KERNEL',   0x530F, 17,  'resident kernel                -> #61A8'),
    ('INTRO',    0x5500, 153, 'intro (music, titles)          -> 26000, entry 32000'),
    ('DEMO',     0x5E09, 46,  'attract-mode demo level        -> 29300'),
]
POS2NAME = {p: n for n, p, s, c in DISK}
NSEC = {n: s for n, p, s, c in DISK}
# names the original ABLOCK1 table used for disk positions
OLDNAMES = {'PRINCE': 'PRINCE', 'HIGH_': 'HIGH', 'PRINCE1': 'PRINCE1', 'PRINCE2': 'PRINCE2',
            'LONGGATE': 'LONGGATE', 'LONGGATA': 'LONGGATA', 'PRINCE2A': 'PRINCE2A',
            'LOADING': 'LOADING', 'STEELMIR': 'STEELMIR', 'MUSIC_': 'MUSIC', 'LEVEL': 'TILES',
            'LEVELA': 'TILESA'}


def load(d, name):
    return open(os.path.join(d, name + '.asm'), encoding='utf-8').read().split('\n')[:-1]


def save(rel, lines):
    p = os.path.join(SRC, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')


# ---------------------------------------------------------------- protection
def strip_protection(L, who):
    out = []
    i = 0
    n = dict(prologue=0, call=0, inline=0, routine=0)
    while i < len(L):
        l = L[i]
        if n['prologue'] == 0 and re.match(r'^\s+ORG\s+29300$', l):   # XOR decryptor (any instruction order)
            j = i + 1
            while not re.match(r'^\s+JR\s+NZ,XLOOP$', L[j]): j += 1
            assert j - i < 20 and any('STAX' in x for x in L[i:j]) and any(x.strip() == 'DI' for x in L[i:j])
            out += [l] + [x for x in L[i + 1:j] if not x.strip()] + ['        DI']
            i = j + 1; n['prologue'] += 1
            continue
        m = re.match(r'^(\w*)(\s+)CALL(\s+)PROT$', l)
        if m:                                                 # CALL PROT -> EI
            out.append('%s%sEI' % (m.group(1), m.group(2)))
            i += 1; n['call'] += 1
            continue
        if re.match(r'^\s+CALL\s+READ$', l):                  # inline check
            j = i
            while not (re.match(r'^\s+CP\s+#AA$', L[j]) and re.match(r'^\s+JR\s+NZ,PSEAR$', L[j + 1])): j += 1
            assert j - i < 40
            out.append('        EI')
            i = j + 2; n['inline'] += 1
            continue
        if re.match(r'^(PROT\s+CALL\s+READ|READ\s+DI)$', l):  # check routines
            j = i
            while not re.match(r'^FORMAT\s', L[j]): j += 1
            while not re.match(r'^\s+JP\s+TRDOS$', L[j]): j += 1
            assert j - i < 60
            i = j + 1; n['routine'] += 1
            continue
        out.append(l)
        i += 1
    assert n['prologue'] == 1 and n['routine'] == 1 and n['call'] + n['inline'] == (0 if who == 'START' else 1), (who, n)
    return out


# ---------------------------------------------------------------- disk symbols
def symbolize_disk(L, who, log):
    L = list(L)
    calls = [i for i, l in enumerate(L) if re.search(r'(CALL|JP)\s+#3D13\b', l)]
    def near_call(i, span=5):
        return any(0 <= c - i <= span for c in calls)
    last = None
    for i, l in enumerate(L):
        m = re.match(r'^(\w*\s+LD\s+DE,)(#[0-9A-F]{4}|\w+)$', l)
        if m:
            v = m.group(2); name = None
            if v.startswith('#') and int(v[1:], 16) in POS2NAME: name = POS2NAME[int(v[1:], 16)]
            elif v in OLDNAMES: name = OLDNAMES[v]
            if name:
                jr = any(re.match(r'^\s+JR\s+AFTER', x) for x in L[i + 1:i + 3])
                if near_call(i) or jr:
                    L[i] = m.group(1) + 'D_' + name
                    last = (i, name)
                else:
                    log.append('%s:%d NOT symbolized (no TR-DOS call nearby): %s' % (who, i + 1, l.strip()))
            continue
        m = re.match(r'^(\w*\s+LD\s+BC,)#([0-9A-F]{2})05$', l)
        if m and (near_call(i, 4)):
            cnt = int(m.group(2), 16)
            # owner: the closest symbolized DE within 3 lines before, or within 3 lines after
            name = None
            if last and i - last[0] <= 3: name = last[1]
            else:
                for k in range(i + 1, min(i + 4, len(L))):
                    mm = re.match(r'^\w*\s+LD\s+DE,(#[0-9A-F]{4}|\w+)$', L[k])
                    if mm:
                        v = mm.group(1)
                        if v.startswith('#') and int(v[1:], 16) in POS2NAME: name = POS2NAME[int(v[1:], 16)]
                        elif v in OLDNAMES: name = OLDNAMES[v]
                        break
            if name is None:
                if who.startswith('menu') and cnt == 0x1E: name = 'CUT1'
                elif cnt == 0x2E: name = 'LEVEL1'
            if name is None:
                log.append('%s:%d sector count without owner: %s' % (who, i + 1, l.strip()))
                continue
            full = NSEC[name]
            sym = 'N_LEVELPRG' if name.startswith('LEVEL') and name[5:].isdigit() else 'N_' + name
            if name.startswith('LEVEL') and name[5:].isdigit() and cnt == 0x3E: cnt = full   # PR2 quirk: #3E05
            if cnt == full: L[i] = '%s%s*256+5' % (m.group(1), sym)
            else:
                L[i] = '%s(%s%+d)*256+5' % (m.group(1), sym, cnt - full)
                log.append('%s:%d partial load of %s: %d of %d sectors' % (who, i + 1, name, cnt, full))
    for i, l in enumerate(L):                 # disk layer: all reads go through the driver
        m = re.match(r'^(\w*\s+)(CALL|JP)(\s+)#3D13$', l)
        if m: L[i] = '%s%s%sDSK_READ' % m.groups()
        elif '#3D13' in l or '#3D2F' in l: log.append('%s:%d TR-DOS reference left: %s' % (who, i + 1, l.strip()))
    return L


# ---------------------------------------------------------------- k-way merge
def merge(files):
    """files: {level: lines}. Returns list of (line, frozenset(levels))."""
    order = sorted(files)
    merged = [(l, {order[0]}) for l in files[order[0]]]
    for lv in order[1:]:
        a = [l for l, s in merged]; b = files[lv]
        sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
        out = []
        for tag, i1, i2, j1, j2 in sm.get_opcodes():
            if tag == 'equal':
                for k in range(i1, i2):
                    merged[k][1].add(lv); out.append(merged[k])
            else:
                out.extend(merged[i1:i2])
                out.extend((l, {lv}) for l in b[j1:j2])
        merged = out
    return [(l, frozenset(s)) for l, s in merged]


def cond(s, allv):
    def ranges(v):
        v = sorted(v); r = []
        for x in v:
            if r and x == r[-1][1] + 1: r[-1][1] = x
            else: r.append([x, x])
        return r
    def pos(v):
        parts = []
        for a, b in ranges(v):
            if a == b: parts.append('LVL == %d' % a)
            elif a == min(allv): parts.append('LVL <= %d' % b)
            elif b == max(allv): parts.append('LVL >= %d' % a)
            elif b == a + 1: parts.append('LVL == %d || LVL == %d' % (a, b))
            else: parts.append('(LVL >= %d && LVL <= %d)' % (a, b))
        return ' || '.join(parts)
    def neg(v):
        parts = []
        for a, b in ranges(v):
            if a == b: parts.append('LVL != %d' % a)
            elif a == min(allv): parts.append('LVL > %d' % b)
            elif b == max(allv): parts.append('LVL < %d' % a)
            else: parts.append('(LVL < %d || LVL > %d)' % (a, b))
        return ' && '.join(parts)
    p = pos(s); q = neg(allv - s)
    return p if len(p) <= len(q) else q


def emit_simple(merged, allv):
    out = []
    i = 0
    while i < len(merged):
        l, s = merged[i]
        if s == allv:
            out.append(l); i += 1; continue
        j = i
        while j < len(merged) and merged[j][1] == s: j += 1
        out.append('    IF %s' % cond(s, allv))
        out.extend(x for x, _ in merged[i:j])
        k = j
        if k < len(merged) and merged[k][1] == allv - s:      # complementary block -> ELSE
            while k < len(merged) and merged[k][1] == allv - s: k += 1
            out.append('    ELSE')
            out.extend(x for x, _ in merged[j:k])
            j = k
        out.append('    ENDIF')
        i = j
    return out


def emit(merged, allv, glue=2):
    """Line-level IFs where a difference is simple; where many levels differ in
    interleaved ways, emit whole per-level alternatives of the region instead."""
    out = []
    i = 0
    n = len(merged)
    while i < n:
        if merged[i][1] == allv:
            out.append(merged[i][0]); i += 1; continue
        # variant region: up to a run of >= glue common lines
        j = i; last_var = i
        while j < n:
            if merged[j][1] != allv: last_var = j; j += 1
            else:
                k = j
                while k < n and merged[k][1] == allv: k += 1
                if k - j >= glue or k == n: break
                j = k
        region = merged[i:last_var + 1]
        sets = []
        for l, s in region:
            if s != allv and s not in sets: sets.append(s)
        absorbed = any(s == allv for l, s in region)
        disjoint = all(a.isdisjoint(b) for x, a in enumerate(sets) for b in sets[x + 1:])
        if (len(sets) <= 2 or disjoint) and not absorbed:
            out += emit_simple(region, allv)
        else:
            groups = {}
            for lv in sorted(allv):
                groups.setdefault(tuple(l for l, s in region if lv in s), set()).add(lv)
            items = sorted(groups.items(), key=lambda kv: min(kv[1]))
            if sum(len(k) + 2 for k, v in items) > 2.2 * len(region) + 12:
                out += emit_simple(region, allv)       # too much duplication
                i = last_var + 1
                continue
            if len(items) == 2 and all(k for k, v in items):
                out.append('    IF %s' % cond(frozenset(items[0][1]), allv)); out += items[0][0]
                out.append('    ELSE'); out += items[1][0]; out.append('    ENDIF')
            else:
                for text, lv in items:
                    if not text: continue
                    out.append('    IF %s' % cond(frozenset(lv), allv)); out += text; out.append('    ENDIF')
        i = last_var + 1
    return out


# ---------------------------------------------------------------- kernel API
def parse_val(v):
    v = v.split(';')[0].strip()
    try:
        return int(v[1:], 16) if v.startswith('#') else int(v)
    except ValueError:
        return None


def kernel_syms():
    s = {}
    for l in open(os.path.join(ROOT, 'vbuild', 'BLOCK2.sym')):
        m = re.match(r'(\S+): EQU 0x([0-9A-F]+)', l)
        if m: s[m.group(1)] = int(m.group(2), 16)
    return s


def drop_kernel_equs(L, ksym, exports, who, log):
    out = []
    for l in L:
        m = re.match(r'^(\w+)\s+EQU\s+(\S+)', l)
        if m and m.group(1) in OLDNAMES and parse_val(m.group(2)) in POS2NAME:
            continue                                      # disk position -> disk.inc
        if m and m.group(1) in ksym:
            v = parse_val(m.group(2))
            if v == ksym[m.group(1)]:
                exports.add(m.group(1)); continue
            if m.group(1) == 'STL' and v == 0x6B2E:        # stale, unused in the menu
                continue
            if m.group(1) == 'TIMER' and v == 0x690F:      # stale address, unused
                continue
            log.append('%s: EQU %s = %s differs from kernel label (#%04X) - kept' % (who, m.group(1), m.group(2), ksym[m.group(1)]))
        out.append(l)
    return out


HDR = ''';==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; %s
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
'''


def header(title, extra=''):
    return (HDR % title).split('\n')[:-1] + ([x for x in extra.split('\n')] if extra else [])


def main():
    log = []
    ksym = kernel_syms()
    exports = set()
    allv = frozenset(range(1, NLEV + 1))

    # ---- game engine: PRn / PARTn / LEVELn
    pr = {}; part = {}
    for n in range(1, NLEV + 1):
        d = COM
        L = load(d, 'PR%d' % n)
        L = strip_protection(L, 'PR%d' % n)
        L = symbolize_disk(L, 'game.asm(level %d)' % n, log)
        L2 = []
        for l in L:
            if re.match(r'^\s+INCLUDE\s+"ABLOCK1.asm"', l):
                L2 += ['        INCLUDE "kernel_api.inc"', '        INCLUDE "disk.inc"']
            elif re.match(r'^\s+INCLUDE\s+"PART\d+.asm"', l): L2.append('        INCLUDE "game_part.asm"')
            elif re.match(r'^\s+INCLUDE\s+"LEVEL\d+.asm"', l): L2.append('        INCLUDE "levels/level%02d.asm"' % n)
            else: L2.append(l)
        while L2 and not L2[-1].strip(): L2.pop()
        pr[n] = L2
        P = load(d, 'PART%d' % n)
        if n == 13:
            # the master disk has LD IX,#6B2E here although STL = #6B24 in every
            # known kernel build; keep what was actually shipped
            k = [i for i, l in enumerate(P) if l == '        LD      IX,STL']
            assert len(k) == 1
            P[k[0]] = '        LD      IX,STL+10       ; as on the master disk (source said STL)'
        part[n] = P
        lev = load(d, 'LEVEL%d' % n)
        lev = [l.replace('#FFFF', '#FF') if re.match(r'^\w*\s+DEFB\s+#FFFF(,#FFFF)?$', l) else l for l in lev]
        save('levels/level%02d.asm' % n, header('Level %d: tables and map' % n) + lev)
    m = emit(merge(pr), allv)
    save('game.asm', header('Game engine, part 1 (original PR1..PR13 merged)',
         '; Build with -DLVL=n (1..13). Level specific code is under IF LVL.') + m)
    mp = merge(part)
    mp = [(l, s) for l, s in mp]
    mpe = emit(mp, allv)
    mpe = drop_kernel_equs(mpe, ksym, exports, 'game_part.asm', log)
    save('game_part.asm', header('Game engine, part 2 (original PART1..PART13 merged)') + mpe)

    # ---- kernel API names from the original table
    for l in load(COM, 'ABLOCK1'):
        mm = re.match(r'^(\w+)\s+EQU\s+(\S+)', l)
        if mm and mm.group(1) in ksym and parse_val(mm.group(2)) == ksym[mm.group(1)]: exports.add(mm.group(1))

    # ---- menu / demo / ending
    def single(srcdir, name, dst, title, incmap, fix=None):
        L = load(srcdir, name)
        L = strip_protection(L, name)
        if fix: L = fix(L)
        L = symbolize_disk(L, dst, log)
        L2 = []
        seen_api = False
        for l in L:
            mi = re.match(r'^\s+INCLUDE\s+"(\w+).asm"', l)
            if mi:
                if mi.group(1) == 'ABLOCK1':
                    L2 += ['        INCLUDE "kernel_api.inc"', '        INCLUDE "disk.inc"']; seen_api = True
                else: L2.append('        INCLUDE "%s"' % incmap[mi.group(1)])
            else: L2.append(l)
        L2 = drop_kernel_equs(L2, ksym, exports, dst, log)
        if not seen_api:
            k = max(i for i, l in enumerate(L2) if re.match(r'^\s+INCLUDE', l))
            L2[k:k] = ['        INCLUDE "kernel_api.inc"', '        INCLUDE "disk.inc"']
        save(dst, header(title) + L2)

    def fix_menu(L):
        # level 7/8 positions: the archived START.A is older than the master disk
        s = '\n'.join(L)
        assert s.count('LD      DE,#3604\n        LD      BC,#2E05') == 1 and s.count('LD      DE,#3405\n        LD      BC,#2E05') == 1
        s = s.replace('LD      DE,#3604\n        LD      BC,#2E05', 'LD      DE,#3B01\n        LD      BC,#2E05')
        s = s.replace('LD      DE,#3405\n        LD      BC,#2E05', 'LD      DE,#3803\n        LD      BC,#2E05')
        return s.split('\n')
    single(ARC, 'START', 'menu.asm', 'Main menu and password entry (original START)', {'STALEV': 'menu_level.asm'}, fix_menu)
    save('menu_level.asm', header('Menu background "level" (original STALEV)') + load(ARC, 'STALEV'))

    def fix_demo(L):
        keys = open(os.path.join(ROOT, 'vbuild', 'DEMO.master.bin'), 'rb').read()[39000 - 29300:39000 - 29300 + 60]
        assert keys[52:60] == b'\x00' + b'\xff' * 7, keys.hex()
        k = max(i for i, l in enumerate(L) if re.match(r'^\s+ORG\s+29300', l))
        add = ['; Recorded demo keys: pairs (keyboard state, frames-1). They exist only on',
               '; the master disk (the author recorded them into memory), not in the source.',
               '        ORG     KEYS']
        for i in range(0, 60, 8):
            add.append('        DEFB    ' + ','.join('#%02X' % b for b in keys[i:i + 8]))
        return L[:k] + add + L[k:]
    single(ARC, 'DEMO', 'demo.asm', 'Attract-mode demo (original DEMO)',
           {'DEMOPART': 'demo_part.asm', 'DEMOLEV': 'demo_level.asm'}, fix_demo)
    dp = drop_kernel_equs(load(ARC, 'DEMOPART'), ksym, exports, 'demo_part.asm', log)
    save('demo_part.asm', header('Demo engine, part 2 (original DEMOPART)') + dp)
    save('demo_level.asm', header('Demo level (original DEMOLEV)') + load(ARC, 'DEMOLEV'))

    def fix_end(L):
        # 5th map row: 32 bytes of memory garbage that got saved onto the master disk
        junk = open(os.path.join(ROOT, 'vbuild', 'ENDG.master.bin'), 'rb').read()[0x9B54 - 29300:0x9B74 - 29300]
        k = [i for i, l in enumerate(L) if l.startswith('_______')]
        assert len(k) == 1
        add = ['; The map is declared 6 rows high but only 4 are defined. The next 32 bytes',
               '; are memory garbage that was saved onto the master disk - kept as shipped.']
        for i in range(0, 32, 8):
            add.append('        DEFB    ' + ','.join('#%02X' % b for b in junk[i:i + 8]))
        return L[:k[0]] + add + L[k[0] + 1:]
    single(COM, 'ENDG', 'ending.asm', 'Ending sequence (original ENDG)', {'ENDPART1': 'ending_part.asm'}, fix_end)
    ep = drop_kernel_equs(load(COM, 'ENDPART1'), ksym, exports, 'ending_part.asm', log)
    save('ending_part.asm', header('Ending engine, part 2 (original ENDPART1)') + ep)

    # ---- kernel
    K = load(ARC, 'BLOCK2')
    K = symbolize_disk(K, 'kernel.asm', log)
    k = [i for i, l in enumerate(K) if re.match(r'^\s+ORG\s+25000', l)][0]
    exp = ['; Kernel entry points and variables used by the other programs.',
           '; sjasmplus --exp writes them to build/kernel_api.inc']
    exp += ['        EXPORT  %s' % n for n in sorted(exports, key=lambda n: (ksym[n], n))]
    save('kernel_exports.inc', exp)
    K[k + 1:k + 1] = ['        INCLUDE "kernel_exports.inc"', '        INCLUDE "disk.inc"']
    K += ['',
          '; The tile blocks (res/tiles*.bin) contain drawing code without source that',
          '; calls the kernel at fixed addresses, and every program is ORGed right',
          '; after the kernel - so the kernel layout must not move.',
          '        ASSERT  RANDOM == #61A8 && INC_DE == #71F4 && DEC_DE == #7203',
          '        ASSERT  $ <= 29300']
    save('kernel.asm', header('Resident kernel, loaded at #61A8 (original BLOCK2)') + K)

    # ---- disk.inc
    D = ['; Disk layer interface + disk map.',
         ';',
         '; All disk access of the game goes through the resident driver (disk_io.asm):',
         ';   DSK_INIT            - called once by the boot loader',
         ';   DSK_READ            - HL = destination address',
         ';                         DE = block id (D_xxx)',
         ';                         B  = length in 256-byte sectors (N_xxx), C is ignored',
         '; To port the game to another disk system replace disk_io.asm, the boot',
         '; loader and (if block ids mean something else there) the D_xxx values.',
         ';',
         '; TR-DOS: D_xxx = track*256+sector (logical track = cylinder*2+side),',
         ';         N_xxx = number of sectors reserved for the block.',
         '; build.py reads this file to place the blocks, so move/resize them here.',
         '',
         'DISKIO      EQU #5E00       ; driver address (free RAM below the stack/kernel)',
         'DSK_READ    EQU DISKIO',
         'DSK_INIT    EQU DISKIO+3',
         '']
    for n, p, s, c in DISK:
        D.append('D_%-9s EQU #%04X' % (n, p) + (' ; ' + c if c else ''))
    D.append('')
    for n, p, s, c in DISK:
        D.append('N_%-9s EQU %d' % (n, s))
    D += ['', 'N_LEVELPRG  EQU 46      ; every level program is loaded with this many sectors']
    save('disk.inc', D)

    open(os.path.join(ROOT, 'make_src.log'), 'w', encoding='utf-8').write('\n'.join(log) + '\n')
    print('\n'.join(log))
    print('exports:', len(exports))


if __name__ == '__main__':
    main()
