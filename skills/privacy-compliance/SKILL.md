---
name: privacy-compliance
description: "Consumer protection and privacy compliance (GDPR, CCPA, local data laws): unbundled consent without pre-checked boxes, analytics/pixels gated behind Consent Mode v2, and PII masking in application logs."
---

# privacy-compliance · Consumer Privacy & Regulatory Standards

> **Purpose:** Implement and verify legal compliance for user data protection (GDPR, California CCPA/CPRA, and international data privacy statutes). Ensures user consent is unbundled and logs are free of Personally Identifiable Information (PII).

---

## 1. Golden Rules of Privacy Compliance

1. **No Pre-Checked Consent Boxes:** Consent must be an explicit, affirmative action. Checkboxes for marketing, terms, or newsletter subscriptions must default to unchecked (`checked=false`).
2. **Consent Mode v2 Gate for Analytics:** Never load Google Analytics (GA4), Meta Pixel, or marketing beacons before the visitor grants explicit consent in the cookie banner.
3. **Never Log Raw PII:** Application logs, exception trackers (Sentry), and error dumps must mask or strip customer names, email addresses, credit card numbers, national identification numbers (DNI/SSN), and phone numbers.
4. **Data Subject Rights (DSR):** Provide accessible user endpoints to request full data export (Right of Access) and complete account/data deletion (Right to be Forgotten).

---

## 2. PII Sanitization in Application Logging

```typescript
export function sanitizeLogData<T extends Record<string, unknown>>(data: T): Record<string, unknown> {
  const sensitiveKeys = new Set(['password', 'token', 'secret', 'email', 'phone', 'ssn', 'dni', 'card']);
  const sanitized: Record<string, unknown> = {};

  for (const [key, value] of Object.entries(data)) {
    if (sensitiveKeys.has(key.toLowerCase())) {
      sanitized[key] = '[REDACTED_PII]';
    } else if (typeof value === 'object' && value !== null) {
      sanitized[key] = sanitizeLogData(value as Record<string, unknown>);
    } else {
      sanitized[key] = value;
    }
  }
  return sanitized;
}
```

---

## 3. Cookie & Beacon Consent Gate Pattern

```javascript
// Block initialization until consent is recorded
function onConsentGranted() {
  gtag('consent', 'update', {
    'analytics_storage': 'granted',
    'ad_storage': 'granted',
    'ad_user_data': 'granted',
    'ad_personalization': 'granted'
  });
  loadAnalyticsScripts();
}
```
