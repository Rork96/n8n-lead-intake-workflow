#!/usr/bin/env bash
# Usage: WEBHOOK_URL=https://your-n8n/webhook/lead-intake INTAKE_KEY=... ./samples/send.sh alpha
# Requires: jq, curl
set -euo pipefail
: "${WEBHOOK_URL:?set WEBHOOK_URL}" "${INTAKE_KEY:?set INTAKE_KEY}"
lead="${1:?lead name, e.g. alpha}"
if [ "$lead" = "delta" ]; then
  body=$(jq -c --arg m "$(python3 -c "print('Need a quote for a kitchen remodel. ' * 80)")" '.delta | .message = $m' "$(dirname "$0")/payloads.json")
else
  body=$(jq -c ".${lead}" "$(dirname "$0")/payloads.json")
fi
curl -sS -w '\nHTTP %{http_code}\n' -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" -H "x-intake-key: ${INTAKE_KEY}" -d "$body"
