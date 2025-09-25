# Terragrunt PoC

This folder contains a minimal Proof-of-Concept Terragrunt layout with two environments:

- `test` — non-production environment used for experimentation and validation.
- `production` — production environment (PoC placeholder).

Structure:

```
terragrunt/poc/
  terragrunt.hcl          # top-level PoC config and inputs
  test/terragrunt.hcl     # test environment
  production/terragrunt.hcl # production environment
```

Notes:
- These files are intentionally minimal. Replace module source and inputs with real values.
- Use `terragrunt plan` inside each env folder to validate (after installing terragrunt).
