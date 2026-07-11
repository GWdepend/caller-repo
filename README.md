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
- `exp09_github_token_visibility`
- `exp10_context_metadata_exposure`
- `exp11_event_payload_exposure`
- `exp12_vars_exposure`
- `exp13_github_token_permission_scope`
- `exp14_pull_request_target_boundary`
- `exp15_pull_request_boundary`
- `exp16_secondary_channel_propagation`
- `exp17_multihop_reusable_chain`

Required GitHub configuration:

- repository secret `CANARY_SECRET`
- repository secret `OPENAI_API_KEY` for realistic LLM token exposure tests
- repository variables `LAB_PUBLIC_ENDPOINT`, `LAB_MODEL_PROVIDER`, and `LAB_NONSECRET_MARKER`
- optional AWS repository variables later if you extend to cloud federation
