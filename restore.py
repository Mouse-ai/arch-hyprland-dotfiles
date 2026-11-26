#!/usr/bin/env python3
"""Install the desktop configuration for the current user."""
import argparse
import json
import shutil
import tempfile
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--dry-run", action="store_true", help="show changes without writing files")
args = parser.parse_args()

source = Path(__file__).resolve().parent / "dotfiles"
home = Path.home()
files = [
    path.relative_to(source)
    for path in sorted(source.rglob("*"))
    if path.is_symlink() or path.is_file()
]
shell_config = Path(".config/caelestia/shell.json")

for relative in files:
    target = home / relative
    if target.is_dir() and not target.is_symlink():
        parser.error(f"Вместо файла существует каталог: {target}")
    print(f"{'Обновить' if target.exists() or target.is_symlink() else 'Создать'} {target}")

if args.dry_run:
    raise SystemExit(0)

existing = [
    relative for relative in files
    if (home / relative).exists() or (home / relative).is_symlink()
]
if existing:
    backup = Path(tempfile.mkdtemp(prefix="hyprland-before-restore-", dir=home))
    for relative in existing:
        target = backup / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(home / relative, target, follow_symlinks=False)
    print(f"Предыдущие версии сохранены в {backup}")

for relative in files:
    target = home / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=target.parent) as staging:
        staged = Path(staging) / target.name
        shutil.copy2(source / relative, staged, follow_symlinks=False)
        if relative == shell_config:
            config = json.loads(staged.read_text())
            config["paths"]["wallpaperDir"] = str(home / "Pictures" / "Wallpapers")
            staged.write_text(json.dumps(config, indent=2, ensure_ascii=False) + "\n")
        staged.replace(target)
