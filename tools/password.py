"""Level passwords of Prince of Persia (ZX, Nicodim 1996).
   python tools/password.py <level 2..12> [minutes left 0..59] [lives 3..12] [seconds]"""
import sys
def rev4(v): return int('{:04b}'.format(v)[::-1], 2)
def password(level, minutes=59, lives=3, seconds=0):
    assert 2 <= level <= 12 and 3 <= lives <= 12 and 0 <= minutes <= 59 and 0 <= seconds <= 59
    bcd = lambda n: (n // 10) << 4 | n % 10
    m, s = bcd(minutes), bcd(seconds)
    v = [rev4(level), m & 15, s >> 4, s & 15, m >> 4, rev4(lives)]
    v.append(sum(v) & 15)
    return ''.join(chr(65 + x) for x in v)
if __name__ == '__main__':
    a = [int(x) for x in sys.argv[1:]]
    if a: print(password(*a))
    else:
        for l in range(2, 13): print(l, password(l))
