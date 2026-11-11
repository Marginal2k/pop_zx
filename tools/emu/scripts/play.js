// Boot the disk and follow a key script.
//   steps=F300,S,Kspace,F200,S ...   F<n> run n frames, S screenshot, K<key> tap key, D<key>/U<key> hold/release
export async function run(zx, q) {
  const machine = q.get('machine') || 'pentagon';
  await zx.ready({ machine }); await zx.start({ machine });
  const F = n => { for (let i = 0; i < n; i++) zx.spectrum.runFrame(); };
  await zx.loadUrl((q.get('trd') || '/media/prince.trd') + '?' + Date.now(), { name: 'prince.trd' });
  zx.pause(); zx.spectrum.bootTrdos();
  const res = { shots: [] };
  const info = () => { const r = zx.captureRegisters(); return 'pc=' + r.pc.toString(16) + ' sp=' + r.sp.toString(16) + ' frame=' + zx.spectrum.totalFrames + ' prg=' + Array.from({ length: 12 }, (_, i) => zx.peek(29301 + i).toString(16).padStart(2, '0')).join(''); };
  const shot = label => res.shots.push({ label, info: info(), scr: Array.from(zx.peekRange ? zx.peekRange(0x4000, 6912) : Array.from({ length: 6912 }, (_, i) => zx.peek(0x4000 + i))) });
  for (const st of (q.get('steps') || 'F500,S').split(',')) {
    const c = st[0], a = st.slice(1);
    if (c === 'F') F(+a);
    else if (c === 'S') shot(a || st);
    else if (c === 'K') { zx.keyDown(a); F(8); zx.keyUp(a); F(8); }
    else if (c === 'D') zx.keyDown(a);
    else if (c === 'U') zx.keyUp(a);
    else if (c === 'C') { for (const ch of a) { zx.keyDown('CAPS'); F(2); zx.keyDown(ch); F(6); zx.keyUp(ch); zx.keyUp('CAPS'); F(6); } }
    else if (c === 'J') zx.setRegisters({ pc: parseInt(a, 16) });   // jump (used to force a level exit)
    else if (c === 'T') { for (const ch of a) { zx.keyDown(ch); F(6); zx.keyUp(ch); F(6); } }
  }
  await zx.report(res, 'result', q.get('name') || 'play'); return { shots: res.shots.length };
}
