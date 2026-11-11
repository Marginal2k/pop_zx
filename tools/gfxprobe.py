"""Quick look at raw bitmap data: python gfxprobe.py file offset width_bytes height count cols out.png [step] [scale]"""
import sys
from PIL import Image
def strip(b, off, w, h, count, cols, step=None, scale=2):
    step = step or w * h
    rows = (count + cols - 1) // cols
    img = Image.new('RGB', (cols * (w * 8 + 2), rows * (h + 2)), (0, 0, 120))
    px = img.load()
    for n in range(count):
        ox = (n % cols) * (w * 8 + 2) + 1; oy = (n // cols) * (h + 2) + 1
        for y in range(h):
            for x in range(w):
                i = off + n * step + y * w + x
                v = b[i] if i < len(b) else 0
                for bit in range(8):
                    px[ox + x * 8 + bit, oy + y] = (255, 255, 255) if v & (0x80 >> bit) else (0, 0, 0)
    return img.resize((img.width * scale, img.height * scale), Image.NEAREST)
if __name__ == '__main__':
    a = sys.argv
    b = open(a[1], 'rb').read()
    strip(b, int(a[2], 0), int(a[3]), int(a[4]), int(a[5]), int(a[6]), None if len(a) < 9 or a[8] == '0' else int(a[8]), int(a[9]) if len(a) > 9 else 2).save(a[7])
