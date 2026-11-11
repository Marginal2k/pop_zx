"""TASM 3.x (ZX Spectrum, TR-DOS) source detokenizer. Port of ZX-M8XXX core/asm-detok.js"""
import sys, os
TOK = ['A','ADC ','ADD ',"AF'",'AF','AND ','B','BC','BIT ','C','CALL ','CCF','CP ','CPD','CPDR','CPI',
 'CPIR','CPL','D','DAA','DE','DEC ','DEFB ','DEFM ','DEFS ','DEFW ','DI','PHASE ','DJNZ ','E','EI','UNPHASE ',
 'EQU ','EX ','EXX','H','HALT','HL','I','IM ','IN ','INC ','IND','INDR','INI','INIR','IX','IY',
 'JP ','JR ','L','LD ','LDD','LDDR','LDI','LDIR','M','NC','NEG','NOP','NV','NZ','OR ','ORG ',
 'OTDR','OTIR','OUT ','OUTD','OUTI','P','PE','PO','POP ','PUSH ','R','RES ','RET','RETI','RETN','RL ',
 'RLA','RLC ','RLCA','RLD','RR ','RRA','RRC ','RRCA','RRD','RST ','SBC ','SCF','SET ','SLA ','SP','SRA ',
 'SRL ','SUB ','V','XOR ','Z','INCLUDE ','INCBIN ','SLI ','INF','LX','HX','LY','HY','DB ','DM ','DS ',
 'DW '] + ['?']*15
def detok(b):
    p = 0; out = []
    while p < len(b):
        n = b[p]; p += 1
        if n == 0xFF: break
        line = ''; i = 0
        while i < n and p < len(b):
            c = b[p]
            if c < 0x20:
                if c == 0x0A and i != n-1:
                    p += 1; i += 1
                    line += ' ' * b[p]
                else:
                    line += '{%02X}' % c
            elif c < 0x80:
                line += chr(c)
            else:
                line += TOK[c-0x80]
            p += 1; i += 1
        out.append(line)
        if p >= len(b): break
        if b[p] != n:
            out.append('; !!! framing broken at %d' % p); break
        p += 1
    return out, p
if __name__ == '__main__':
    src, dst = sys.argv[1], sys.argv[2]
    os.makedirs(dst, exist_ok=True)
    for f in sorted(os.listdir(src)):
        if not f.endswith('.A'): continue
        lines, p = detok(open(os.path.join(src, f), 'rb').read())
        open(os.path.join(dst, f[:-2] + '.asm'), 'w', encoding='cp866', newline='\n').write('\n'.join(lines) + '\n')
        print(f, len(lines), 'lines', p, 'bytes')
