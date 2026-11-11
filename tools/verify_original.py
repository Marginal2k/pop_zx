#!/usr/bin/env python3
"""Prove that original_src/ (the TASM sources converted to sjasmplus syntax, copy
protection still in place) is what the master disk was built from.

Every program is assembled with sjasmplus and compared with the block on
orig/Prince Master.trd (after undoing its XOR encryption). Only bytes that the
source defines are compared: code/data up to UNDO, the level map and the torch
flame frames. The rest of a block is whatever was in the author's memory.

Also leaves in vbuild/ the files tools/make_src.py needs.
"""
import os, re, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from decrypt import decrypt
ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
VB = os.path.join(ROOT, 'vbuild')
IMG = open(os.path.join(ROOT, 'orig', 'Prince Master.trd'), 'rb').read()
LEVELS = [0x4E03, 0x4B05, 0x4807, 0x430B, 0x400D, 0x3D0F, 0x3B01, 0x3803, 0x3107, 0x2E09, 0x2B0B, 0x260F, 0x200F]
#        name      dir        org    track/sector  sectors
JOBS = [('BLOCK2', 'archive', 25000, 0x530F, 17)]
JOBS += [('PR%d' % (i + 1), 'compile', 29300, ts, 46) for i, ts in enumerate(LEVELS)]
JOBS += [('START', 'archive', 29300, 0x5101, 46), ('DEMO', 'archive', 29300, 0x5E09, 46), ('ENDG', 'compile', 29300, 0x1E06, 44)]
EXPECTED = {'PR13': 'LD IX,STL: the master disk has STL+10',
            'START': 'positions of levels 7 and 8: the archived START is older than the master disk'}

def syms(path):
    s = {}
    for l in open(path):
        m = re.match(r'(\S+): EQU 0x([0-9A-F]+)', l)
        if m: s[m.group(1)] = int(m.group(2), 16)
    return s

def main():
    os.makedirs(VB, exist_ok=True)
    bad = 0
    for name, d, org, ts, nsec in JOBS:
        size = nsec * 256
        wrap = os.path.join(VB, 't_%s.asm' % name)
        open(wrap, 'w', newline='\n').write('        DEVICE ZXSPECTRUM128\n        INCLUDE "%s.asm"\n        SAVEBIN "%s.bin",%d,%d\n' % (name, name, org, size))
        r = subprocess.run([os.environ.get('SJASMPLUS', 'sjasmplus'), '--nologo', '--msg=err', '-I' + os.path.join(ROOT, 'original_src', d),
                            '--sym=%s.sym' % name, 't_%s.asm' % name], cwd=VB, capture_output=True, text=True)
        if r.returncode:
            print(name, 'ASSEMBLY FAILED', r.stderr); bad += 1; continue
        b = open(os.path.join(VB, name + '.bin'), 'rb').read()
        off = ((ts >> 8) * 16 + (ts & 255)) * 256
        p, info = decrypt(IMG[off:off + size], org)
        open(os.path.join(VB, name + '.master.bin'), 'wb').write(p)
        s = syms(os.path.join(VB, name + '.sym'))
        if name == 'BLOCK2':
            ranges = [(org, max(v for v in s.values() if org <= v < 29300) + 3)]
        else:
            end = s.get('UNDO') or max(v for k, v in s.items() if org <= v < 39000) + 1
            ranges = [(org, end), (39600, min(39600 + (s['HEIGHT'] + 1) * (s['LENGHT'] + 1), org + size))]
            if name == 'ENDG': ranges[1] = (39600, 39600 + 4 * (s['LENGHT'] + 1))    # only 4 map rows exist in the source
        diff = [a for lo, hi in ranges for a in range(lo, hi) if b[a - org] != p[a - org]]
        note = EXPECTED.get(name, '')
        ok = not diff or note
        bad += not ok
        print('%-7s #%04X %s compared %5d bytes, %d differ%s' % (name, ts, 'encrypted' if info else 'plain    ',
              sum(hi - lo for lo, hi in ranges), len(diff), '  (%s)' % note if diff and note else ''))
    print('OK' if not bad else 'MISMATCH')
    return bad

if __name__ == '__main__':
    sys.exit(main())
