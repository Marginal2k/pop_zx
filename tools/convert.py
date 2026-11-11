"""Convert detokenized TASM 3 text to sjasmplus syntax (minimal, formatting-preserving)."""
import sys, os, re
DIRS = {'DEFB', 'DEFW', 'ORG'}
def conv_line(l):
    l = l.rstrip()
    m = re.match(r'^([A-Za-z]+)(\s+)(.*)$', l)
    if m and m.group(1).upper() in DIRS:           # directive in column 0
        l = '        ' + m.group(1) + ' ' * max(1, 8 - len(m.group(1))) + m.group(3)
    m = re.match(r'^(\S*\s+)INCLUDE(\s+)(\S+)(.*)$', l)
    if m:
        l = '%sINCLUDE%s"%s.asm"%s' % (m.group(1), m.group(2), m.group(3), m.group(4))
    # label NOT collides with the sjasmplus operator
    if re.match(r'^NOT\s', l): l = 'NOT_0' + l[5:]
    l = re.sub(r'^(\s+J[RP]\s+\w+,)NOT$', r'\1NOT_0', l)
    # typo in the original (TASM silently took it); the symbol is unused
    l = re.sub(r'^(TIMER\s+EQU\s+)690F', r'\g<1>#690F', l)
    return l
if __name__ == '__main__':
    src, dst = sys.argv[1], sys.argv[2]
    os.makedirs(dst, exist_ok=True)
    for f in sorted(os.listdir(src)):
        L = open(os.path.join(src, f), encoding='cp866').read().split('\n')
        while L and not L[-1].strip(): L.pop()
        open(os.path.join(dst, f), 'w', encoding='utf-8', newline='\n').write('\n'.join(conv_line(l) for l in L) + '\n')
