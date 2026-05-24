#!/bin/bash
# Shared test infrastructure — source this from test files.

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit

__pass=0
__fail=0

work=$(mktemp -d)
# shellcheck disable=SC2064 # intentional: expand path now so cleanup uses the right dir
trap "rm -rf ${work:?}" EXIT

assert() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "  OK: $label"
    ((__pass++)) || true
  else
    echo "FAIL: $label"
    echo "  expected: $expected"
    echo "    actual: $actual"
    ((__fail++)) || true
  fi
}

assert_file() {
  local label="$1" file="$2" expected="$3"
  local actual
  actual=$(cat "$file")
  assert "$label" "$expected" "$actual"
}

assert_match() {
  local label="$1" pattern="$2" actual="$3"
  if echo "$actual" | grep -q "$pattern"; then
    echo "  OK: $label"
    ((__pass++)) || true
  else
    echo "FAIL: $label (expected match: $pattern)"
    echo "    actual: $actual"
    ((__fail++)) || true
  fi
}

assert_empty() {
  local label="$1" actual="$2"
  if [ -z "$actual" ]; then
    echo "  OK: $label"
    ((__pass++)) || true
  else
    echo "FAIL: $label (expected empty)"
    echo "    actual: $actual"
    ((__fail++)) || true
  fi
}

assert_fails() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "FAIL: $label (expected non-zero exit)"
    ((__fail++)) || true
  else
    echo "  OK: $label"
    ((__pass++)) || true
  fi
}

test_summary() {
  echo ""
  local total=$((__pass + __fail))
  if [ "$__fail" -eq 0 ]; then
    echo "All $total tests passed.${1:+ ($1)}"
  else
    echo "$__pass/$total passed, $__fail failed.${1:+ ($1)}"
    exit 1
  fi
}
