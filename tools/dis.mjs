// Quick Z80 disassembly of a binary, using the disassembler of the ZX-M8XXX emulator.
//   node tools/dis.mjs <file> <org> <start> [count]
// Set M8XXX_DIR to the emulator folder (default D:/Emulators/ZX/ZX-M8XXX).
import { readFileSync } from 'fs';
import { pathToFileURL } from 'url';
const emu = process.env.M8XXX_DIR || 'D:/Emulators/ZX/ZX-M8XXX';
const { Disassembler } = await import(pathToFileURL(emu + '/core/disasm.js').href);
const [,, file, orgS, startS, cntS] = process.argv;
const org = Number(orgS), buf = readFileSync(file);
const mem = { read: a => { const i = a - org; return i >= 0 && i < buf.length ? buf[i] : 0; } };
const d = new Disassembler(mem);
let a = Number(startS);
for (let i = 0; i < Number(cntS || 60); i++) {
  const r = d.disassemble(a);
  console.log(a.toString(16).toUpperCase().padStart(4, '0') + '  ' + r.mnemonic);
  a += r.bytes.length;
}
