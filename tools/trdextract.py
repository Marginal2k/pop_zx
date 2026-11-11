import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from trdcat import cat
src, dst = sys.argv[1], sys.argv[2]
os.makedirs(dst, exist_ok=True)
d, c = cat(src)
for (i, dele, name, typ, start, length, secs, sec, trk) in c:
    off = (trk*16+sec)*256
    # full sectors kept; logical length stored in name list
    n = name.strip().replace('/', '_')
    fn = '%s.%s' % (n, typ)
    if os.path.exists(os.path.join(dst, fn)) or fn.lower() in [x.lower() for x in os.listdir(dst)]:
        fn = '%s~%d.%s' % (n, i, typ)
    open(os.path.join(dst, fn), 'wb').write(d[off:off+secs*256])
    print(fn, start, length, secs)
