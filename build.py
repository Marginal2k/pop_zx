#!/usr/bin/env python3
"""Prince of Persia (ZX Spectrum 128, TR-DOS) - build script.

    python build.py            assemble everything, write build/prince.trd
    python build.py --list     also keep sjasmplus listings in build/lst/
    python build.py --res DIR [--out FILE]
                               take resources from DIR first (alternative graphics
                               made with tools/gfx.py), then from res/

Needs sjasmplus (https://github.com/z00m128/sjasmplus) in PATH
(or set the SJASMPLUS environment variable).
"""
import os, re, struct, subprocess, sys

ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, 'src')
RES = os.path.join(ROOT, 'res')
OUT = os.path.join(ROOT, 'build')
SJASM = os.environ.get('SJASMPLUS', 'sjasmplus')
LISTING = '--list' in sys.argv


def _opt(name, default):
    return sys.argv[sys.argv.index(name) + 1] if name in sys.argv else default


RES_ALT = _opt('--res', None) and os.path.abspath(_opt('--res', None))
IMAGE = os.path.abspath(_opt('--out', os.path.join(OUT, 'prince.trd')))


def resfile(name):
    if RES_ALT and os.path.exists(os.path.join(RES_ALT, name)):
        return os.path.join(RES_ALT, name)
    return os.path.join(RES, name)

# block name (D_xxx / N_xxx in src/disk.inc) -> what goes there
#   ('res', file, load address)            binary resource
#   ('asm', source, org, {defines})        assembled program
BLOCKS = {
    'PRINCE':   ('res', 'prince.bin',   0xC000),
    'HIGH':     ('res', 'high.bin',     57458),
    'PRINCE1':  ('res', 'prince1.bin',  0xC000),
    'PRINCE2':  ('res', 'prince2.bin',  0xC000),
    'FIRE':     ('res', 'fire.bin',     0x8000),
    'LONGGATE': ('res', 'longgate.bin', 61200),
    'LONGGATA': ('res', 'longgata.bin', 61200),
    'PRINCE2A': ('res', 'prince2a.bin', 0xC000),
    'LOADING':  ('res', 'loading.bin',  0x4000),
    'PRINCE2C': ('res', 'prince2c.bin', 0xC000),
    'STEELMIR': ('res', 'steelmir.bin', 58608),
    'MUSIC':    ('res', 'music.bin',    0xC000),
    'TILES':    ('res', 'tiles.bin',    0xD800),
    'TILESA':   ('res', 'tilesa.bin',   0xD800),
    'ENDFILE':  ('res', 'endfile.bin',  0xC000),
    'FONT1':    ('res', 'font1.bin',    59282),
    'OMUSIC':   ('res', 'omusic.bin',   0xC000),
    'PRINCE2B': ('res', 'prince2b.bin', 0xC000),
    'LONGGATB': ('res', 'longgatb.bin', 61200),
    'CUT1':     ('res', 'cut1.bin',     39000),
    'CUT2':     ('res', 'cut2.bin',     39000),
    'CUT3':     ('res', 'cut3.bin',     39000),
    'CUT4':     ('res', 'cut4.bin',     39000),
    'KERNEL':   ('asm', 'kernel.asm',   25000, {}),
    'INTRO':    ('asm', 'intro.asm',    26000, {}),
    'MENU':     ('asm', 'menu.asm',     29300, {}),
    'DEMO':     ('asm', 'demo.asm',     29300, {}),
    'ENDING':   ('asm', 'ending.asm',   29300, {}),
}
for _n in range(1, 14):
    BLOCKS['LEVEL%d' % _n] = ('asm', 'game.asm', 29300, {'LVL': _n})


def die(msg):
    print('ERROR:', msg)
    sys.exit(1)


def diskmap():
    d, n = {}, {}
    for l in open(os.path.join(SRC, 'disk.inc')):
        m = re.match(r'^([DN])_(\w+)\s+EQU\s+(#?)([0-9A-Fa-f]+)', l)
        if m:
            (d if m.group(1) == 'D' else n)[m.group(2)] = int(m.group(4), 16 if m.group(3) else 10)
    return d, n


def symbols(path):
    s = {}
    for l in open(path):
        m = re.match(r'(\S+): EQU 0x([0-9A-F]+)', l)
        if m:
            s[m.group(1)] = int(m.group(2), 16)
    return s


def assemble(name, source, org, size, defines=None, extra=()):
    """Assemble src/<source> in a 128K device, save <size> bytes from <org>."""
    wrap = os.path.join(OUT, 'obj', '_build_' + name + '.asm').replace(os.sep, '/')
    binf = os.path.join(OUT, 'obj', name + '.bin')
    symf = os.path.join(OUT, 'obj', name + '.sym')
    with open(wrap, 'w', newline='\n') as f:
        f.write('        DEVICE  ZXSPECTRUM128\n')
        f.write('        INCLUDE "%s"\n' % source)
        f.write('        SAVEBIN "%s",%d,%d\n' % (binf.replace('\\', '/'), org, size))
    cmd = [SJASM, '--nologo', '--msg=war', '-Wno-opkeyword', '-I' + SRC, '-I' + os.path.join(OUT, 'obj'), '-I' + RES, '--sym=' + symf]
    if RES_ALT:
        cmd.insert(cmd.index('-I' + RES), '-I' + RES_ALT)
    cmd += ['-D%s=%s' % kv for kv in (defines or {}).items()]
    if LISTING:
        cmd.append('--lst=' + os.path.join(OUT, 'lst', name + '.lst'))
    cmd += list(extra) + [wrap]
    r = subprocess.run(cmd, capture_output=True, text=True)
    msgs = (r.stdout + r.stderr).strip()
    if msgs:
        print(msgs)
    if r.returncode != 0 or 'error' in msgs.lower():
        die('assembling %s failed' % name)
    return open(binf, 'rb').read(), symbols(symf)


def basic_boot(entry, ts, nsec):
    """10 RANDOMIZE USR VAL "nnnnn": REM <machine code>
    The code in the REM reads the driver+loader block (track/sector ts, nsec
    sectors) to DISKIO and jumps to it. PROG is 23867 with TR-DOS present."""
    code = bytes([0x21, 0x00, 0x5E,                    # LD HL,DISKIO
                  0x11, ts & 255, ts >> 8,             # LD DE,track/sector
                  0x01, 0x05, nsec,                    # LD BC,nsec*256+5
                  0xCD, 0x13, 0x3D,                    # CALL #3D13
                  0xC3, entry & 255, entry >> 8])      # JP BOOT
    assert 0x0D not in code
    head = bytes([0xF9, 0xC0, 0xB0]) + b'"%05d":' + bytes([0xEA])   # RANDOMIZE USR VAL "n": REM
    usr = 23867 + 4 + len(head % 0)
    body = head % usr + code + bytes([0x0D])
    p = struct.pack('>H', 10) + struct.pack('<H', len(body)) + body
    return p, p + bytes([0x80, 0xAA]) + struct.pack('<H', 10)   # program, file body with autostart line


class Trd:
    def __init__(self):
        self.img = bytearray(2560 * 256)
        self.files = []
        self.used = {}                        # sector -> owner

    @staticmethod
    def sector(ts):
        return (ts >> 8) * 16 + (ts & 255)

    def put(self, name, typ, start, length, ts, data, nsec=None):
        s = self.sector(ts)
        nsec = nsec or (len(data) + 255) // 256
        if len(data) > nsec * 256:
            die('%s: %d bytes do not fit into %d sectors' % (name, len(data), nsec))
        for k in range(s, s + nsec):
            if k in self.used:
                die('disk map: %s overlaps %s at track %d sector %d' % (name, self.used[k], k // 16, k % 16))
            if k < 9 or k >= 2560:
                die('disk map: %s is outside the disk / in the catalogue' % name)
            self.used[k] = name
        self.img[s * 256:s * 256 + len(data)] = data
        self.files.append((name, typ, start, length, nsec, ts))

    def finish(self, label):
        if len(self.files) > 128:
            die('too many catalogue entries')
        for i, (name, typ, start, length, nsec, ts) in enumerate(self.files):
            e = name.ljust(8)[:8].encode('ascii') + typ.encode() + struct.pack('<HHB', start & 0xFFFF, length & 0xFFFF, nsec & 255)
            e += bytes([ts & 255, ts >> 8])
            self.img[i * 16:i * 16 + 16] = e
        last = max(self.used) + 1
        info = 8 * 256
        self.img[info + 0xE1] = last % 16
        self.img[info + 0xE2] = last // 16
        self.img[info + 0xE3] = 0x16                       # 80 tracks, double sided
        self.img[info + 0xE4] = len(self.files)
        struct.pack_into('<H', self.img, info + 0xE5, 0)   # free sectors: none (keeps TR-DOS from writing)
        self.img[info + 0xE7] = 0x10                       # TR-DOS id
        self.img[info + 0xEA:info + 0xF3] = b' ' * 9
        self.img[info + 0xF5:info + 0xFD] = label.ljust(8)[:8].encode('ascii')
        return bytes(self.img)


def main():
    for sub in ('obj', 'lst'):
        os.makedirs(os.path.join(OUT, sub), exist_ok=True)
    D, N = diskmap()
    trd = Trd()

    # 1. kernel first: it exports the API (kernel_api.inc) the programs include
    api = os.path.join(OUT, 'obj', 'kernel_api.inc')
    kbin, ksym = assemble('kernel', 'kernel.asm', 25000, 29300 - 25000, extra=['--exp=' + api])
    print('kernel    %5d bytes, %d exported symbols' % (len(kbin.rstrip(b'\0')), sum(1 for _ in open(api))))

    # 2. boot: disk driver + loader
    bbin, bsym = assemble('boot', 'boot.asm', 0x5E00, 0x300)
    blen = max(i for i, b in enumerate(bbin) if b) + 1
    prog, body = basic_boot(bsym['BOOT'], 0x000A, (blen + 255) // 256)
    trd.put('boot', 'B', len(prog), len(prog), 0x0009, body)
    trd.put('diskio', 'C', 0x5E00, blen, 0x000A, bbin[:blen])

    # 3. all blocks of the disk map
    for name in sorted(D, key=lambda n: D[n]):
        if name not in BLOCKS:
            die('disk.inc has D_%s but build.py does not know what to put there' % name)
        spec = BLOCKS[name]
        size = N[name] * 256
        if spec[0] == 'res':
            data = open(resfile(spec[1]), 'rb').read()
            org = spec[2]
        else:
            org = spec[2]
            objname = name.lower()
            if name == 'KERNEL':
                data = kbin[:size]
                if len(kbin.rstrip(b'\0')) > size:
                    die('kernel does not fit into N_KERNEL sectors')
            else:
                data, sym = assemble(objname, spec[1], org, size, spec[3])
                # programs with a level map: check that the map is inside the loaded block
                if 'LEVELE' in sym and 'LENGHT' in sym:
                    limit = sym.get('FIREGFX', sym['LEVELE'])
                    if sym.get('UNDO', 0) > limit:
                        die('%s: code (ends at %d) runs into the data at %d' % (name, sym['UNDO'], limit))
                    end = sym['LEVELE'] + (sym['HEIGHT'] + 1) * (sym['LENGHT'] + 1)
                    if end > org + size and name != 'ENDING':
                        die('%s: level map ends at %d, block is loaded only up to %d' % (name, end, org + size))
                    if 'UNDO' in sym:
                        print('%-9s code %5d..%5d  (%d bytes free)' % (name, org, sym['UNDO'], limit - sym['UNDO']))
        trd.put(name.lower(), 'C', org, min(len(data), size), D[name], data, N[name])

    img = trd.finish('PRINCE')
    path = IMAGE
    open(path, 'wb').write(img)
    print('written %s  (%d blocks, %d of 2560 sectors used)' % (os.path.relpath(path, ROOT), len(trd.files), len(trd.used)))


if __name__ == '__main__':
    main()
