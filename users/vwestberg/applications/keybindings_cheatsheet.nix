{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "keybinds-popup" ''
      dms keybinds show mangowc | ${pkgs.python3}/bin/python3 -c "
import json, sys, subprocess
data = json.load(sys.stdin)
binds = data.get('binds', {})
ESC = chr(27)
R   = ESC + '[0m'
B   = ESC + '[1m'
CAT = ESC + '[1;96m'
KEY = ESC + '[93m'
order = ['Window', 'Tags', 'Monitor', 'Overview', 'System', 'Execute']
cats = sorted(binds.keys(), key=lambda c: order.index(c) if c in order else 99)
print()
for cat in cats:
    items = binds[cat]
    print('  ' + CAT + B + cat.upper() + R)
    for b in items:
        key = b.get('key') or str()
        desc = b.get('desc') or b.get('action') or str()
        print('    ' + KEY + key.ljust(28) + R + desc)
    print()
res = subprocess.run(
    ['zsh', '-c', '. /etc/zshrc 2>/dev/null; alias 2>/dev/null'],
    capture_output=True, text=True, timeout=5
)
if res.stdout.strip():
    print('  ' + CAT + B + 'ALIASES' + R)
    for line in sorted(res.stdout.strip().split('\n')):
        if '=' in line:
            name, _, cmd = line.partition('=')
            cmd = cmd.strip(\"'\")
            if len(cmd) > 55: cmd = cmd[:52] + '...'
            print('    ' + KEY + name.ljust(28) + R + cmd)
    print()
      " | ${pkgs.fzf}/bin/fzf --ansi --no-sort --layout=reverse \
            --header="  Keybindings & Aliases  (type to search, Esc to close)" \
            --header-first --no-info --no-preview --bind="esc:abort,enter:abort"
    '')
  ];
}
