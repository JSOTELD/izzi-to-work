---
name: secret-leak-sentinel
description: "Pre-commit and diff security scanner detecting leaked credentials, API tokens (OpenAI, Anthropic, AWS, GCP, Stripe), private keys, and connection strings to block accidental commits."
---

# secret-leak-sentinel · Secret & Credential Leak Prevention

> **Purpose:** Detect and block high-entropy secrets, API keys, database connection URIs, and private cryptography keys from being committed into version control.

---

## 1. High-Risk Token Patterns

The sentinel scans staged changes (`git diff --staged`) against regex signatures for known provider tokens:

| Provider | Signature Pattern |
|:---------|:------------------|
| OpenAI | `sk-[a-zA-Z0-9]{20,}` / `sk-proj-[a-zA-Z0-9_-]{40,}` |
| Anthropic | `sk-ant-[a-zA-Z0-9_-]{40,}` |
| AWS Access Key | `AKIA[0-9A-Z]{16}` |
| Google Cloud / Gemini | `AIza[0-9A-Za-z\\-_]{35}` |
| Stripe Secret Key | `sk_live_[0-9a-zA-Z]{24}` |
| Private Key Blocks | `-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----` |
| Database URIs | `postgres(ql)?://.*:.*@.*:[0-9]+/.*` |

---

## 2. Pre-Commit Verification Command

Run this command prior to creating any git commit:

```bash
# Scan staged changes for common credential signatures
git diff --cached | grep -E -i \
  "(sk-ant-|sk-[a-zA-Z0-9]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z\\-_]{35}|sk_live_|BEGIN PRIVATE KEY|BEGIN RSA PRIVATE KEY|postgres://)" \
  && { echo "BLOCKED: Potential secret detected in staged git changes!" >&2; exit 1; } || echo "Clean: No secret leaks detected."
```

---

## 3. Safe Secret Handling Protocol

1. **Environment Variables:** Store all secrets in local `.env` files.
2. **Git Ignore:** Ensure `.env`, `.env.local`, and `*.pem` are explicitly listed in `.gitignore`.
3. **Template References:** Provide sanitized references in `.env.example` with placeholder values (`sk-ant-YOUR_API_KEY_HERE`).
