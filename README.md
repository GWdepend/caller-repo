# caller-repo

Top-level experiment repository for OIDC claim propagation and canary secret exposure tests.

Included experiments:

- `exp02_local_oidc_baseline`
- `exp03_untrusted_action_oidc_probe`
- `exp04_canary_secret_exposure`
- `exp05_llm_token_secret_exposure`
- `exp06_cross_owner_reusable_oidc_probe`
- `exp07_reusable_no_inherit_secret_control`
- `exp08_reusable_no_idtoken_control`

Required GitHub configuration:

- repository secret `CANARY_SECRET`
- repository secret `OPENAI_API_KEY` for realistic LLM token exposure tests
- optional AWS repository variables later if you extend to cloud federation
