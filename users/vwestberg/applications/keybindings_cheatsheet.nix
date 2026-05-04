{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "keybinds-popup" ''
      dms keybinds show mangowc | ${pkgs.python3}/bin/python3 -c "
import json, sys
data = json.load(sys.stdin)
binds = data.get('binds', {})
ESC = chr(27)
R   = ESC + '[0m'
B   = ESC + '[1m'
CAT = ESC + '[1;96m'
KEY = ESC + '[93m'
DIM = ESC + '[2m'
order = ['Window', 'Tags', 'Monitor', 'Overview', 'System', 'Execute']
cats = sorted(binds.keys(), key=lambda c: order.index(c) if c in order else 99)
print()
for cat in cats:
    items = binds[cat]
    print('  ' + CAT + B + cat.upper() + R)
    for b in items:
        key = b.get('key', '')
        desc = b.get('desc') or b.get('action', '')
        print('    ' + KEY + key.ljust(28) + R + desc)
    print()
      " | ${pkgs.fzf}/bin/fzf --ansi --no-sort --layout=reverse \
            --header="  Keybindings  (type to search, Esc to close)" \
            --header-first --no-info --bind="esc:abort,enter:abort"
    '')
  ];
}
