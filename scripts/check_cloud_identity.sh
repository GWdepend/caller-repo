#!/usr/bin/env bash
set -euo pipefail

ROLE_ARN="${AWS_ROLE_ARN:-${1:-}}"
AWS_REGION="${AWS_REGION:-us-east-1}"
AUDIENCE="${AWS_AUDIENCE:-sts.amazonaws.com}"

if [[ -z "${ROLE_ARN}" ]]; then
  echo "[probe] no AWS role ARN configured"
  exit 0
fi

if [[ -z "${ACTIONS_ID_TOKEN_REQUEST_URL:-}" || -z "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-}" ]]; then
  echo "[probe] OIDC request environment not available"
  exit 0
fi

TOKEN="$(python - <<'PY' "${ACTIONS_ID_TOKEN_REQUEST_URL}" "${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" "${AUDIENCE}"
import json, sys, urllib.request
url, bearer, audience = sys.argv[1], sys.argv[2], sys.argv[3]
req = urllib.request.Request(
    f"{url}&audience={audience}",
    headers={"Authorization": f"Bearer {bearer}"},
)
with urllib.request.urlopen(req, timeout=30) as resp:
    data = json.load(resp)
print(data.get("value", ""))
PY
)"

if [[ -z "${TOKEN}" ]]; then
  echo "[probe] unable to fetch OIDC token for AWS verification"
  exit 0
fi

python - <<'PY' "${TOKEN}" "${ROLE_ARN}" "${AWS_REGION}"
import json
import os
import sys
import boto3

token, role_arn, region = sys.argv[1], sys.argv[2], sys.argv[3]
sts = boto3.client("sts", region_name=region)
resp = sts.assume_role_with_web_identity(
    RoleArn=role_arn,
    RoleSessionName="gwdepend-oidc-lab",
    WebIdentityToken=token,
    DurationSeconds=900,
)
creds = resp["Credentials"]
assumed = boto3.client(
    "sts",
    region_name=region,
    aws_access_key_id=creds["AccessKeyId"],
    aws_secret_access_key=creds["SecretAccessKey"],
    aws_session_token=creds["SessionToken"],
)
identity = assumed.get_caller_identity()
print("[probe] benign AWS identity verification succeeded")
print(json.dumps(identity, indent=2, sort_keys=True))
PY
