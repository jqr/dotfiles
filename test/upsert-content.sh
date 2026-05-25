#!/bin/bash
set -euo pipefail
# shellcheck source=test/helpers.sh
source "$(dirname "$0")/helpers.sh"

# Source file for tests
cat > "$work/source" <<'EOF'
# START GENERATED
alpha
bravo
# END GENERATED
EOF

# --- replace existing block ---
cat > "$work/target" <<'EOF'
user pre
# START GENERATED
old content
# END GENERATED
user post
EOF
stderr=$(bin/upsert-content "$work/source" "$work/target" 2>&1 >/dev/null || true)
assert_file "replace existing block" "$work/target" "user pre
# START GENERATED
alpha
bravo
# END GENERATED
user post"
assert_empty "replace existing block: no warning" "$stderr"

# --- no existing block (appends) ---
cat > "$work/target" <<'EOF'
user config
more config
EOF
stderr=$(bin/upsert-content "$work/source" "$work/target" 2>&1 >/dev/null || true)
assert_file "no existing block appends" "$work/target" "user config
more config
# START GENERATED
alpha
bravo
# END GENERATED"
assert_match "no existing block warns" "first time" "$stderr"

# --- no existing file ---
rm -f "$work/target"
stderr=$(bin/upsert-content "$work/source" "$work/target" 2>&1 >/dev/null || true)
assert_file "no existing file" "$work/target" "# START GENERATED
alpha
bravo
# END GENERATED"
assert_match "no existing file warns" "first time" "$stderr"

# --- empty target file ---
true > "$work/target"
stderr=$(bin/upsert-content "$work/source" "$work/target" 2>&1 >/dev/null || true)
assert_file "empty target file" "$work/target" "# START GENERATED
alpha
bravo
# END GENERATED"
assert_match "empty target warns" "first time" "$stderr"

# --- idempotent (run twice) ---
cat > "$work/target" <<'EOF'
user pre
# START GENERATED
old content
# END GENERATED
user post
EOF
bin/upsert-content "$work/source" "$work/target" 2>/dev/null
bin/upsert-content "$work/source" "$work/target" 2>/dev/null
assert_file "idempotent after two runs" "$work/target" "user pre
# START GENERATED
alpha
bravo
# END GENERATED
user post"

# --- custom markers ---
cat > "$work/target" <<'EOF'
before
# BEGIN dotfiles
old stuff
# END dotfiles
after
EOF
stderr=$(bin/upsert-content "$work/source" "$work/target" "# BEGIN dotfiles" "# END dotfiles" 2>&1 >/dev/null || true)
assert_file "custom markers" "$work/target" "before
# START GENERATED
alpha
bravo
# END GENERATED
after"
assert_empty "custom markers: no warning" "$stderr"

# --- source with trailing blank lines ---
cat > "$work/source-trailing" <<EOF
# START GENERATED
content
# END GENERATED

EOF
cat > "$work/target" <<'EOF'
user pre
# START GENERATED
old
# END GENERATED
user post
EOF
stderr=$(bin/upsert-content "$work/source-trailing" "$work/target" 2>&1 >/dev/null || true)
assert_file "trailing blank lines in source" "$work/target" "user pre
# START GENERATED
content
# END GENERATED
user post"
assert_empty "trailing blank lines: no warning" "$stderr"

# --- start marker only, no end ---
cat > "$work/target" <<'EOF'
user pre
# START GENERATED
old content
user post
EOF
cp "$work/target" "$work/target-backup"
stderr=$(bin/upsert-content "$work/source" "$work/target" 2>&1 >/dev/null) && status=0 || status=$?
assert "start only errors" "1" "$status"
assert_match "start only mentions start marker" "start marker but no end" "$stderr"
assert_file "start only leaves target unchanged" "$work/target" "$(cat "$work/target-backup")"

# --- end marker only, no start ---
cat > "$work/target" <<'EOF'
user pre
old content
# END GENERATED
user post
EOF
cp "$work/target" "$work/target-backup"
stderr=$(bin/upsert-content "$work/source" "$work/target" 2>&1 >/dev/null) && status=0 || status=$?
assert "end only errors" "1" "$status"
assert_match "end only mentions end marker" "end marker but no start" "$stderr"
assert_file "end only leaves target unchanged" "$work/target" "$(cat "$work/target-backup")"

# --- content only before block ---
cat > "$work/target" <<'EOF'
user pre
# START GENERATED
old
# END GENERATED
EOF
bin/upsert-content "$work/source" "$work/target" 2>/dev/null
assert_file "content only before block" "$work/target" "user pre
# START GENERATED
alpha
bravo
# END GENERATED"

# --- content only after block ---
cat > "$work/target" <<'EOF'
# START GENERATED
old
# END GENERATED
user post
EOF
bin/upsert-content "$work/source" "$work/target" 2>/dev/null
assert_file "content only after block" "$work/target" "# START GENERATED
alpha
bravo
# END GENERATED
user post"

test_summary ""
