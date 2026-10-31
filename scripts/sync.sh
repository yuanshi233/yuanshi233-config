#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
remote=origin
branch=main
mode=${1:-sync}

case "$mode" in
	sync | --check) ;;
	*)
		printf 'usage: %s [--check]\n' "$0" >&2
		exit 2
		;;
esac

cd "$repo_dir"
git fetch "$remote" "$branch"
upstream="$remote/$branch"
current_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || printf 'DETACHED')
counts=$(git rev-list --left-right --count "HEAD...$upstream")
set -- $counts
ahead=$1
behind=$2

if [ -n "$(git status --porcelain)" ]; then
	worktree=dirty
else
	worktree=clean
fi

if ./scripts/install.sh --check >/dev/null 2>&1; then
	adapter=current
else
	adapter=stale
fi

printf 'branch: %s\n' "$current_branch"
printf 'worktree: %s\n' "$worktree"
printf 'ahead: %s\n' "$ahead"
printf 'behind: %s\n' "$behind"
printf 'adapters: %s\n' "$adapter"

if [ "$mode" = "--check" ]; then
	[ "$current_branch" = "$branch" ] && [ "$worktree" = clean ] && [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ] && [ "$adapter" = current ]
	exit
fi

[ "$current_branch" = "$branch" ] || {
	printf 'sync requires branch %s\n' "$branch" >&2
	exit 1
}
[ "$worktree" = clean ] || {
	printf 'sync requires a clean worktree\n' >&2
	exit 1
}

if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ]; then
	:
elif git merge-base --is-ancestor HEAD "$upstream"; then
	git pull --ff-only "$remote" "$branch"
elif git merge-base --is-ancestor "$upstream" HEAD; then
	printf 'local branch is ahead of %s; push or reconcile it before syncing\n' "$upstream" >&2
	exit 1
else
	printf 'local branch and %s have diverged; reconcile history explicitly\n' "$upstream" >&2
	exit 1
fi

./scripts/validate.sh
./scripts/install.sh
./scripts/install.sh --check
