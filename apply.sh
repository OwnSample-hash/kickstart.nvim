#!/usr/bin/env bash
# git-branch-manager.sh
# Manages an "active" branch with auto-archiving and cleanup.
# Usage: ./git-branch-manager.sh [new-branch-name]
#   new-branch-name defaults to "active"

set -euo pipefail

ACTIVE_BRANCH="${1:-active}"
MAX_ARCHIVES=3
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# ── Helpers ────────────────────────────────────────────────────────────────────

info()    { printf '\033[0;34m[INFO]\033[0m  %s\n' "$*"; }
success() { printf '\033[0;32m[OK]\033[0m    %s\n' "$*"; }
warn()    { printf '\033[0;33m[WARN]\033[0m  %s\n' "$*"; }
error()   { printf '\033[0;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

# ── Sanity checks ──────────────────────────────────────────────────────────────

git rev-parse --git-dir &>/dev/null || error "Not inside a git repository."

# Make sure there is at least one commit so branch ops work.
if ! git rev-parse HEAD &>/dev/null; then
    error "Repository has no commits yet. Create an initial commit first."
fi

# ── Does the "active" branch already exist? ────────────────────────────────────

if git show-ref --verify --quiet "refs/heads/${ACTIVE_BRANCH}"; then
    ARCHIVE_NAME="archive-${TIMESTAMP}"
    info "Branch '${ACTIVE_BRANCH}' exists — renaming to '${ARCHIVE_NAME}'."

    # If we are currently ON the active branch, we must switch away first.
    CURRENT=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
    if [[ "$CURRENT" == "$ACTIVE_BRANCH" ]]; then
        # Switch to a detached HEAD so we can rename/delete the branch.
        git checkout --detach HEAD --quiet
        info "Detached HEAD from '${ACTIVE_BRANCH}' temporarily."
    fi

    git branch -m "$ACTIVE_BRANCH" "$ARCHIVE_NAME"
    success "Renamed '${ACTIVE_BRANCH}' → '${ARCHIVE_NAME}'."

    # ── Prune old archive branches (keep only MAX_ARCHIVES) ───────────────────
    # List archive branches sorted oldest-first (by reflog / creation order).
    mapfile -t ARCHIVES < <(
        git for-each-ref \
            --sort=creatordate \
            --format='%(refname:short)' \
            'refs/heads/archive-*'
    )

    ARCHIVE_COUNT=${#ARCHIVES[@]}
    info "Found ${ARCHIVE_COUNT} archive branch(es) (keeping at most ${MAX_ARCHIVES})."

    if (( ARCHIVE_COUNT > MAX_ARCHIVES )); then
        DELETE_COUNT=$(( ARCHIVE_COUNT - MAX_ARCHIVES ))
        for (( i=0; i<DELETE_COUNT; i++ )); do
            BRANCH_TO_DELETE="${ARCHIVES[$i]}"
            git branch -D "$BRANCH_TO_DELETE"
            warn "Deleted old archive branch '${BRANCH_TO_DELETE}'."
        done
    fi
else
    info "No '${ACTIVE_BRANCH}' branch found — creating a fresh one."
fi

# ── Create the new active branch from current HEAD ────────────────────────────

git checkout -b "$ACTIVE_BRANCH" --quiet
success "Created and switched to new branch '${ACTIVE_BRANCH}'."

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
info "Current archive branches:"
git for-each-ref \
    --sort=creatordate \
    --format='  %(refname:short)  (%(creatordate:relative))' \
    'refs/heads/archive-*' \
    || true
echo ""
success "Done. You are now on branch '$(git symbolic-ref --short HEAD)'."
info "Applying patches from 'patches/' directory"
git am patches/*.patch
