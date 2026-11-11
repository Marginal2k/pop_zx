import sys, struct, os
def cat(path):
    d = open(path, 'rb').read()
    out = []
    for i in range(128):
        e = d[i*16:i*16+16]
        if e[0] == 0: break
        name = e[:8].decode('cp866', 'replace')
        typ = chr(e[8]) if 32 <= e[8] < 127 else '?%02X' % e[8]
        start, length = struct.unpack('<HH', e[9:13])
        secs, sec, trk = e[13], e[14], e[15]
        out.append((i, e[0] == 1, name, typ, start, length, secs, sec, trk))
    return d, out
if __name__ == '__main__':
    for p in sys.argv[1:]:
        d, c = cat(p)
        info = d[8*256:9*256]
        print('==', os.path.basename(p), 'label=%r files=%d del=%d free=%d first free trk/sec=%d/%d' % (
            info[0xF5:0xFD].decode('cp866', 'replace'), info[0xE4], info[0xF4],
            struct.unpack('<H', info[0xE5:0xE7])[0], info[0xE2], info[0xE1]))
        for (i, dele, name, typ, start, length, secs, sec, trk) in c:
            print('%3d %s %-8s.%s start=%5d(%04X) len=%5d secs=%3d trk=%3d sec=%2d' % (
                i, 'D' if dele else ' ', name, typ, start, start, length, secs, trk, sec))
