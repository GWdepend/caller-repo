# caller-repo

Top-level experiment repository for OIDC claim propagation and canary secret exposure tests.

Included experiments:

- `exp02_local_oidc_baseline`
- `exp03_untrusted_action_oidc_probe`
- `exp04_canary_secret_exposure`
- `exp06_cross_owner_reusable_oidc_probe`

Required GitHub configuration:

- repository secret `CANARY_SECRET`
- optional AWS repository variables later if you extend to cloud federation
