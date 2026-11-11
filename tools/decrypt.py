"""Decrypt R-register XOR-encrypted code blocks of the Prince master disk
by interpreting the small decryptor prologue (handles all its variants)."""
def decrypt(m, org=29300, limit=64):
    p = bytearray(m)
    reg = dict(A=0, B=0, C=0, H=0, L=0); R = 0; r7 = 0
    pc = 0; zf = False; steps = 0; wrote = 0; first = None
    def rinc(n):
        nonlocal R
        R = (R + n) & 0x7F
    try:
        while True:
            op = p[pc]
            if op == 0xED:
                rinc(2); op2 = p[pc+1]; pc += 2
                if op2 == 0x4F: R = reg['A'] & 0x7F; r7 = reg['A'] & 0x80
                elif op2 == 0x5F: reg['A'] = R | r7
                else: return bytes(m), None
                continue
            rinc(1)
            if op == 0xF3: pc += 1
            elif op == 0x21: reg['L'], reg['H'] = p[pc+1], p[pc+2]; pc += 3
            elif op == 0x01: reg['C'], reg['B'] = p[pc+1], p[pc+2]; pc += 3
            elif op == 0x3E: reg['A'] = p[pc+1]; pc += 2
            elif op == 0xAE: reg['A'] ^= p[(reg['H'] << 8 | reg['L']) - org]; pc += 1
            elif op == 0xA8: reg['A'] ^= reg['B']; pc += 1
            elif op == 0xA9: reg['A'] ^= reg['C']; pc += 1
            elif op == 0x77:
                a = (reg['H'] << 8 | reg['L']) - org
                if first is None: first = a
                p[a] = reg['A']; wrote += 1; pc += 1
            elif op == 0x23:
                hl = ((reg['H'] << 8 | reg['L']) + 1) & 0xFFFF; reg['H'], reg['L'] = hl >> 8, hl & 255; pc += 1
            elif op == 0x0B:
                bc = ((reg['B'] << 8 | reg['C']) - 1) & 0xFFFF; reg['B'], reg['C'] = bc >> 8, bc & 255; pc += 1
            elif op == 0x78: reg['A'] = reg['B']; pc += 1
            elif op == 0xB1: reg['A'] |= reg['C']; zf = reg['A'] == 0; pc += 1
            elif op == 0x20:
                e = p[pc+1]; pc += 2
                if not zf: pc += e - 256 if e > 127 else e
                else: break
            else:
                return bytes(m), None
            if wrote == 0:
                steps += 1
                if steps > limit: return bytes(m), None
    except IndexError:
        return bytes(m), None
    return bytes(p), dict(stax=org + first, count=wrote, end=org + pc)
