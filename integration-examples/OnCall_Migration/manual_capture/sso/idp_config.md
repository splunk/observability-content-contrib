# SSO / IdP configuration (source org)

Document identity-provider settings for Splunk On-Call SSO. Backend SSO configuration in Splunk On-Call is coordinated with Splunk support — capture IdP-side settings only.

## Org context

| Field | Value |
| --- | --- |
| Source org slug | [TBD] |
| Target org slug | [TBD] |
| IdP vendor | [TBD] (e.g. Okta, Azure AD, Ping) |

## Splunk On-Call constants

| Setting | Value |
| --- | --- |
| ACS / Reply URL | `https://sso.victorops.com/sp/ACS.saml2` |
| Entity ID / Audience | `victorops.com` |
| Relay state | `https://portal.victorops.com/auth/sso/{org_slug}` |

Replace `{org_slug}` with the org slug for each environment (source vs target may differ).

## IdP application settings

| Setting | Source org value | Target org value | Notes |
| --- | --- | --- | --- |
| Application name | | | |
| Entity ID / Issuer | | | |
| ACS / Single sign-on URL | | | |
| Name ID format | | | |
| Attribute: email | | | |
| Attribute: username | | | |
| Attribute: display name | | | |
| Groups / role mapping | | | |

## SAML metadata

- **Do not commit** private keys, signing certificates with private material, or full metadata XML containing secrets.
- Store metadata in vault: `[vault path TBD]`
- Record metadata URL (if used): `[TBD]`

## Target org cutover notes

| Item | Plan | Owner | Notes |
| --- | --- | --- | --- |
| IdP app for target org | [TBD] | | Separate app vs shared app |
| Relay state for target | `https://portal.victorops.com/auth/sso/{target_org_slug}` | | |
| Splunk support ticket | [TBD] | | If backend SSO config required |

## Related documentation

- [Splunk On-Call SSO documentation](https://help.splunk.com/en/splunk-enterprise/alert-and-respond/splunk-on-call/introduction-to-splunk-on-call/single-sign-on)
