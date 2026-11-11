#!/usr/bin/env python3
"""Run a scenario (tools/emu/scripts/<name>.js) in headless Chrome against the
ZX-M8XXX emulator; results go to build/emu/<name>.json, screenshots to a PNG sheet.

    python tools/emu/run_emu.py play trd=/media/prince.trd name=boot
"""
import json, os, shutil, subprocess, sys, tempfile, time, urllib.parse
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
EDGE = os.environ.get('EDGE') or next((p for p in (
    r'C:\Program Files\Google\Chrome\Application\chrome.exe',
    r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe') if os.path.exists(p)), 'msedge')
PORT = int(os.environ.get('EMU_PORT', '8766'))
def main(argv):
    script = argv[0]
    params = dict(a.split('=', 1) for a in argv[1:])
    budget = int(params.pop('budget', '300000'))
    params['script'] = script
    params.setdefault('name', script)
    out = os.path.join(ROOT, 'build', 'emu')
    os.makedirs(out, exist_ok=True)
    res = os.path.join(out, params['name'] + '.json')
    if os.path.exists(res): os.remove(res)
    srv = subprocess.Popen([sys.executable, os.path.join(HERE, 'serve_emu.py'), str(PORT)])
    prof = tempfile.mkdtemp(prefix='zxrun')
    try:
        time.sleep(2.5)
        url = f'http://127.0.0.1:{PORT}/pop/harness.html?' + urllib.parse.urlencode(params)
        p = subprocess.run([EDGE, '--headless=new', '--disable-gpu', f'--user-data-dir={prof}', '--no-first-run',
                            f'--virtual-time-budget={budget}', '--dump-dom', url], capture_output=True, text=True, timeout=900)
        i = p.stdout.find('id="out">')
        print(p.stdout[i + 9:i + 700].split('</pre>')[0] if i >= 0 else 'no DOM output ' + p.stderr[-300:])
    except subprocess.TimeoutExpired:
        print('TIMEOUT')
    finally:
        srv.terminate(); shutil.rmtree(prof, ignore_errors=True)
    if not os.path.exists(res):
        print('no result file'); return 1
    data = json.load(open(res, encoding='utf-8')); data = data.get('data', data)
    shots = data.pop('shots', None)
    if shots:
        import scr2png
        png = os.path.join(out, params['name'] + '.png')
        scr2png.sheet([s['scr'] for s in shots], png)
        for i, s in enumerate(shots): print(i, s.get('label'), s.get('info'))
        print('screens ->', png)
    print(json.dumps(data)[:1500])
    return 0
if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
