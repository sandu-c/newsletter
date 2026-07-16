#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [The Month Nobody Could Read the Backups],
  authors: (
    (
      name: "March 2026",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "March",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "OpenBao",
    "Infisical",
    "Security",
    "GPG",
    "Kubernetes",
    "Mac Runner",
    "Cypress",
    "VRT",
  ),
  doi: "10.0000/fortris.platform.2026.03",
  abstract: [
    March closed the Infisical chapter permanently — every service now runs on
    OpenBao with zero license cost. The platform deliberately reduced its own
    power: backup encryption keys moved to Corporate Security, root access to
    the secrets platform was revoked, and emergency access now requires a
    three-person ceremony. Meanwhile, a bare-metal Mac runner unlocked desktop
    application delivery, and developer experience improvements removed hidden
    friction from CI pipelines.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= Infisical Is Dead

Every remaining service migrated to OpenBao. The transition is complete.

Frontend, Atlas, Gemini, Pegasus — the final holdouts moved their secrets to OpenBao during March, joining Platform, Data, Vault, and Orion who migrated in February. The MongoDB Helm chart itself — the last Infisical dependency — was also cut over.

Infisical environments are being progressively disconnected by Corporate Security. Full shutdown happens next month. The license renewal question is now irrelevant.

What also shipped: ExternalSecrets now works from local minikube environments. Developers can run services locally with the same secret provisioning path used in production — no more mock secrets or manual environment variable files.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[OPENBAO MIGRATION — FINAL STATUS]
  #v(3mm)
  #grid(
    columns: (1fr, 1fr),
    gutter: 4mm,
    [
      #text(size: 7pt, weight: "bold", fill: red)[Migrated (all)]
      #text(size: 6.5pt, fill: gray)[
        Platform services\
        Data services\
        Vault services\
        Orion services\
        Frontend services\
        Atlas services\
        Gemini services\
        Pegasus services\
        MongoDB Helm chart\
        RDS applications
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: rgb("#8a919c"))[Infisical status]
      #text(size: 6.5pt, fill: gray)[
        ✓ All environments disabled\
        ✓ Progressive disconnection in progress\
        ✓ Full shutdown: April 2026\
        ✓ License cost: eliminated
      ]
    ],
  )
]

#v(4mm)

One secret manager. Zero license cost. Every team. Done.

= The Platform Lost Its Own Keys

Two deliberate security decisions reduced the platform team's access to production data.

*Backup encryption moved to Corporate Security.* The GPG key used to encrypt Vault, Sentinel, and MongoDB backups was replaced with one provided by Corporate Security. The platform team can no longer decrypt production backups. In an emergency, only Corporate Security can restore encrypted data.

This is separation of duties made real: the team that operates the backup system cannot read what it backs up.

*Root access to the secrets platform was revoked.* No permanent root token exists on OpenBao. Day-to-day operations use Keycloak OIDC roles — admin and super-admin — which are sufficient for all normal work.

If an emergency requires root access (for example, if Keycloak itself goes down), a three-person ceremony is required:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[EMERGENCY ROOT TOKEN GENERATION]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr),
      gutter: 2mm,
      [1. Operator initiates root token generation request],
      [2. Three unseal key holders each input their key independently],
      [3. Encoded token is produced — decoded with a one-time password],
      [4. Root token is used for the emergency operation],
      [5. Root token is *immediately revoked* after use],
    )
  ]
  #v(2mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    No single person can generate a root token alone. Keys are held by the Platform lead and Corporate Security.
  ]
]

#v(4mm)

The platform chose to be less powerful. That made it more trustworthy.

= A Mac Joined the Fleet

A bare-metal Mac ARM machine entered the GitLab runner pool.

This is not a general-purpose improvement. It exists for one reason: to build, sign, and distribute the Custody Manager Tool — a cross-platform desktop application that customers use to onboard their Key Management System to the Fortris Vault platform.

macOS code signing requires native hardware. Containers cannot do it. The runner enables a full release pipeline: build on ARM, sign with Apple production certificates, and publish artifacts ready for secure distribution to clients.

The platform now supports desktop application delivery alongside containerised services — a capability that did not exist before.

= Thirty Seconds Nobody Noticed

Cypress end-to-end tests in CI had a hidden problem: Chrome would stall for thirty seconds before navigating to the first page.

The root cause was `/dev/shm` — the shared memory filesystem used by Chrome for tab rendering. The default allocation in GitLab runner pods was too small, causing Chrome to fall back to disk-based operations and stall during initialisation.

The fix was a runner configuration change. Test execution is now stable and consistent. Thirty seconds removed from every E2E test suite run — invisible to developers, but compounding across every merge request, every day.

= Visual Testing Found Its Home

The Visual Regression Tracker migrated to the platform production cluster at `vrt.hub.codecraft.tools`, now with S3-backed image storage.

VRT performs pixel-by-pixel comparison of UI screenshots against accepted baselines. When a frontend change introduces an unexpected visual difference — a misaligned button, a shifted margin, a wrong colour — it catches it before the change reaches production.

The migration to platform infrastructure means faster image storage (S3 replaces local disk), proper backups, and the same operational standards as every other platform service. Another tool that no longer depends on infrastructure managed by someone else.

= What March Established

March was about reducing privilege and completing transitions.

Infisical is gone — not deprecated, not "mostly migrated," but fully replaced and scheduled for shutdown. The platform team deliberately limited its own access to production secrets and backup data. Desktop application delivery became a supported capability.

Every change made the platform harder to misuse and easier to trust.
