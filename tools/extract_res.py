"""Extract the binary resources (graphics, music, blocks without source) from
the original master disk into res/. Positions come from src/disk.inc."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from decrypt import decrypt
ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
RES = ['PRINCE', 'HIGH', 'PRINCE1', 'PRINCE2', 'FIRE', 'LONGGATE', 'LONGGATA', 'PRINCE2A', 'LOADING',
       'PRINCE2C', 'STEELMIR', 'MUSIC', 'TILES', 'TILESA', 'ENDFILE', 'FONT1', 'OMUSIC', 'PRINCE2B',
       'LONGGATB', 'CUT1', 'CUT2', 'CUT3', 'CUT4', 'INTRO']
def diskmap():
    d = {}; n = {}
    for l in open(os.path.join(ROOT, 'src', 'disk.inc')):
        m = re.match(r'^([DN])_(\w+)\s+EQU\s+(#?)([0-9A-Fa-f]+)', l)
        if m: (d if m.group(1) == 'D' else n)[m.group(2)] = int(m.group(4), 16 if m.group(3) else 10)
    return d, n
if __name__ == '__main__':
    img = open(os.path.join(ROOT, 'orig', 'Prince Master.trd'), 'rb').read()
    d, n = diskmap()
    os.makedirs(os.path.join(ROOT, 'res'), exist_ok=True)
    for name in RES:
        off = ((d[name] >> 8) * 16 + (d[name] & 255)) * 256
        b = img[off:off + n[name] * 256]
        if name == 'INTRO':                       # code at 32000 is XOR-encrypted on the master
            p, info = decrypt(b[6000:], 32000)
            assert info and info['stax'] == 32021
            b = b[:6000] + p
        open(os.path.join(ROOT, 'res', name.lower() + '.bin'), 'wb').write(b)
        print('%-9s #%04X %3d sectors' % (name, d[name], n[name]))
