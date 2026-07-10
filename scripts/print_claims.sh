#!/usr/bin/env bash
set -euo pipefail

echo "[probe] checking OIDC request capability"

if [[ -z "${ACTIONS_ID_TOKEN_REQUEST_URL:-}" || -z "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-}" ]]; then
  echo "[probe] OIDC request environment not available"
  exit 0
fi

AUDIENCE="${1:-sts.amazonaws.com}"
RESP_FILE="$(mktemp)"

curl -sS \
  -H "Authorization: Bearer ${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" \
  "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=${AUDIENCE}" \
  -o "${RESP_FILE}"

TOKEN="$(python - <<'PY' "${RESP_FILE}"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as fh:
    data = json.load(fh)
print(data.get("value", ""))
PY
)"

if [[ -z "${TOKEN}" ]]; then
  echo "[probe] OIDC token request returned no token"
  exit 0
fi

python - <<'PY' "${TOKEN}"
import base64, json, sys
token = sys.argv[1]
parts = token.split(".")
if len(parts) < 2:
    print("[probe] malformed token")
    raise SystemExit(0)
payload = parts[1] + "=" * (-len(parts[1]) % 4)
claims = json.loads(base64.urlsafe_b64decode(payload.encode()).decode())
interesting = {
    "iss": claims.get("iss"),
    "sub": claims.get("sub"),
    "aud": claims.get("aud"),
    "repository": claims.get("repository"),
    "repository_owner": claims.get("repository_owner"),
    "ref": claims.get("ref"),
    "sha": claims.get("sha"),
    "event_name": claims.get("event_name"),
    "job_workflow_ref": claims.get("job_workflow_ref"),
}
print("[probe] OIDC claim summary")
print(json.dumps(interesting, indent=2, sort_keys=True))
PY
