"""ZX Spectrum screen dump(s) (6912 bytes) -> PNG. Several dumps are tiled."""
import sys
from PIL import Image
PAL = [(0, 0, 0), (0, 0, 205), (205, 0, 0), (205, 0, 205), (0, 205, 0), (0, 205, 205), (205, 205, 0), (205, 205, 205)]
def render(d):
    img = Image.new('RGB', (256, 192))
    px = img.load()
    for y in range(192):
        row = ((y & 7) << 8) | (((y >> 3) & 7) << 5) | ((y >> 6) << 11)
        for xb in range(32):
            b = d[row + xb]; at = d[6144 + (y >> 3) * 32 + xb]
            br = 1.2 if at & 64 else 1.0
            for bit in range(8):
                c = PAL[(at & 7) if b & (0x80 >> bit) else (at >> 3) & 7]
                px[xb * 8 + bit, y] = tuple(min(255, int(v * br)) for v in c)
    return img
def sheet(dumps, out, cols=4):
    rows = (len(dumps) + cols - 1) // cols
    img = Image.new('RGB', (cols * 260, rows * 196), (60, 60, 60))
    for i, d in enumerate(dumps):
        img.paste(render(bytes(d)), ((i % cols) * 260 + 2, (i // cols) * 196 + 2))
    img.save(out)
