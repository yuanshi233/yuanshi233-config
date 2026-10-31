#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
timestamp=$(date '+%Y%m%d-%H%M%S')
backup_dir="$repo_dir/.local-backups/$timestamp"
canonical_sources="identity.md engineering-contract.md engineering-workflow.md"
bootstrap_checksum=$(cksum <"$repo_dir/bootstrap.md")

check_target() {
	target=$1

	for marker in 'yuanshi233' '始终使用中文' 'yuanshi233-bootstrap:start' "yuanshi233-bootstrap-cksum: $bootstrap_checksum"; do
		if ! grep -F "$marker" "$target" >/dev/null 2>&1; then
			printf 'stale or incomplete personality bootstrap: %s (%s)\n' "$target" "$marker" >&2
			return 1
		fi
	done

	for source in $canonical_sources; do
		if ! grep -F "$repo_dir/$source" "$target" >/dev/null 2>&1; then
			printf 'missing source pointer: %s -> %s\n' "$target" "$source" >&2
			return 1
		fi
	done
}

if [ "${1:-}" = "--check" ]; then
	for target in "$HOME/AGENTS.md" "$HOME/.codex/AGENTS.md" "$HOME/.claude/CLAUDE.md"; do
		[ -f "$target" ] && check_target "$target" || exit 1
	done
	printf 'yuanshi233 adapters are installed.\n'
	exit 0
fi

write_adapter() {
	target=$1
	label=$2

	mkdir -p "$(dirname -- "$target")"
	{
		printf '# yuanshi233 %s自动加载入口\n\n' "$label"
		printf '<!-- yuanshi233-bootstrap:start -->\n'
		printf '<!-- yuanshi233-bootstrap-cksum: %s -->\n\n' "$bootstrap_checksum"
		cat "$repo_dir/bootstrap.md"
		printf '\n<!-- yuanshi233-bootstrap:end -->\n\n'
		printf '开始实质工作前，按顺序读取并遵守以下 canonical 文件：\n\n'
		printf '1. `%s/identity.md`\n' "$repo_dir"
		printf '2. `%s/engineering-contract.md`\n' "$repo_dir"
		printf '3. `%s/engineering-workflow.md`\n\n' "$repo_dir"
		printf '内嵌 bootstrap 负责让身份与执行习惯立即生效；链接文件仍是完整规则的唯一事实源。项目级规则只补充产品、架构、命令和验证细节，不复制 canonical 正文。\n\n'
		printf '当前用户指令定义本次目标和范围。项目差异按最近的项目规则处理；除非用户明确改变，否则保留全局自主执行、证据边界、工作树保护、验证和自迭代规则。\n'
	} >"$target"
}

home_target="$HOME/AGENTS.md"
codex_target="$HOME/.codex/AGENTS.md"
claude_target="$HOME/.claude/CLAUDE.md"
home_tmp="$home_target.apts-install.$$"
codex_tmp="$codex_target.apts-install.$$"
claude_tmp="$claude_target.apts-install.$$"

cleanup() {
	rm -f "$home_tmp" "$codex_tmp" "$claude_tmp"
}
trap cleanup EXIT HUP INT TERM

# Prepare every adapter before replacing any active configuration. A permission
# failure therefore leaves the previous installation intact.
write_adapter "$home_tmp" '目录'
write_adapter "$codex_tmp" 'Codex '
write_adapter "$claude_tmp" 'Claude '

for target in "$home_target" "$codex_target" "$claude_target"; do
	if [ -f "$target" ]; then
		relative=${target#"$HOME"/}
		mkdir -p "$backup_dir/$(dirname -- "$relative")"
		cp -p "$target" "$backup_dir/$relative"
	fi
done

mv "$home_tmp" "$home_target"
mv "$codex_tmp" "$codex_target"
mv "$claude_tmp" "$claude_target"
trap - EXIT HUP INT TERM

printf 'Installed yuanshi233 adapters.\n'
printf 'Backups: %s\n' "$backup_dir"
