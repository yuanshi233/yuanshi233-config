#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

fail() {
	printf 'validation failed: %s\n' "$1" >&2
	exit 1
}

for file in bootstrap.md identity.md engineering-contract.md engineering-workflow.md README.md AGENTS.md experience/README.md experience/template.md experience/candidates/.gitkeep scripts/install.sh scripts/sync.sh scripts/validate.sh .github/workflows/validate.yml; do
	[ -s "$file" ] || fail "missing or empty file: $file"
done

for script in scripts/install.sh scripts/sync.sh scripts/validate.sh; do
	[ -x "$script" ] || fail "script is not executable: $script"
done

for script in scripts/*.sh; do
	sh -n "$script" || fail "invalid shell syntax: $script"
done

for source in bootstrap.md identity.md engineering-contract.md engineering-workflow.md; do
	grep -F "$source" README.md >/dev/null || fail "README.md does not mention $source"
	grep -F "$source" scripts/install.sh >/dev/null || fail "scripts/install.sh does not mention $source"
done

for heading in '## 状态' '## 适用范围' '## 观察到的问题' '## 证据' '## 根因' '## 建议改进' '## 目标事实源' '## 验证方式'; do
	grep -Fx "$heading" experience/template.md >/dev/null || fail "experience template is missing: $heading"
	for candidate in experience/candidates/*.md; do
		[ -f "$candidate" ] || continue
		grep -Fx "$heading" "$candidate" >/dev/null || fail "$candidate is missing: $heading"
	done
done

if git ls-files .local-backups/ | grep . >/dev/null 2>&1; then
	fail '.local-backups/ must not be tracked'
fi

grep -F '.local-backups/' .gitignore >/dev/null || fail '.gitignore must exclude .local-backups/'
grep -F 'experience/candidates/' engineering-workflow.md >/dev/null || fail 'workflow does not define candidate promotion'

printf 'yuanshi233 repository validation passed.\n'
