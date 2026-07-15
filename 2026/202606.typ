#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Every Front Advancing],
  authors: (
    (
      name: "June 2026",
      department: "Infrastructure and Reliability",
      institution: "",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "June",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "AWS MSK",
    "Kafka",
    "Harbor",
    "Backstage",
    "Cost Optimization",
    "Security",
    "Change Management",
  ),
  doi: "10.0000/fortris.platform.2026.06",
  abstract: [
    The container registry began its migration to platform-owned
    infrastructure. Clearing — a regulated global payments provider — started
    onboarding through a merger. The developer portal took shape. Change
    management automation laid its foundations. Two security vulnerabilities
    were patched within days. All advancing.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

#v(2mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[JUNE 2026 — INITIATIVE STATUS]
  #v(4mm)
  #grid(
    columns: (1fr, auto, auto),
    gutter: 3mm,
    [#text(size: 7pt, weight: "bold", fill: gray)[Initiative]],
    [#text(size: 7pt, weight: "bold", fill: gray)[State]],
    [#text(size: 7pt, weight: "bold", fill: gray)[What Shipped]],

    [#text(size: 7pt, fill: gray)[Harbor Registry]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[ADVANCING]],
    [#text(size: 6.5pt, fill: gray)[Syncing, pipelines switched]],

    [#text(size: 7pt, fill: gray)[Developer Portal]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[FOUNDATION]],
    [#text(size: 6.5pt, fill: gray)[Autodiscovery, service pages]],

    [#text(size: 7pt, fill: gray)[CHG Orchestrator]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[FOUNDATION]],
    [#text(size: 6.5pt, fill: gray)[API deployed, logic complete]],

    [#text(size: 7pt, fill: gray)[Clearing Onboarding]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[STARTING]],
    [#text(size: 6.5pt, fill: gray)[GitLab, AWS bootstrap begun]],

    [#text(size: 7pt, fill: gray)[Security Response]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[DONE]],
    [#text(size: 6.5pt, fill: gray)[2 CVEs patched in days]],
  )
]

#v(6mm)

= Every Container Image Is Moving

Harbor — the registry that stores every container image in the company — is migrating from corporate legacy infrastructure to platform-owned AWS. Without this, a single Docker Hub outage or rate limit could freeze every deployment in every environment.

The new instance is live at `registry.hub.codecraft.tools`. Replication runs continuously from old to new. GitLab runners, Helm charts, ArgoCD, and TestContainers have all switched to the new source.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[HARBOR MIGRATION PROGRESS]
  #v(3mm)
  #text(size: 6.5pt, fill: gray)[
    ● New instance live — HA, Keycloak SSO, RDS database, S3 storage\
    ● Replication running — old instance pushes everything to new\
    ● GitLab runners switched to new instance\
    ● Helm charts and ArgoCD pointed to new registry\
    ● TestContainers configured for new source\
    #text(fill: lightgray)[○ Robot accounts — pending]\
    #text(fill: lightgray)[○ Full pipeline cutover — pending]\
    #text(fill: lightgray)[○ Zero-pull verification — pending]
  ]
]

#v(4mm)

Same pattern as every migration this year: sync first, switch progressively, verify, then cut the old. The old instance stays up until pull metrics hit zero for a week.

= The Developer Portal Started Taking Shape

An internal developer portal is being built on Backstage. The goal: a single place where engineers see everything about their services — versions deployed across environments, pipeline status, sync state, alerts — without jumping between five different tools.

#v(3mm)

#block(
  width: 100%,
  stroke: 1pt + lightgray,
  radius: 6pt,
  inset: 4pt,
  clip: true,
)[
  #image("images/eidp.png", width: 100%)
]
#v(1mm)
#align(center)[#text(size: 6pt, style: "italic", fill: gray)[Early design of the Engineering Developer Internal Portal]]

#v(3mm)

What is getting shaped today aims for: autodiscovery of services from repositories, auto-generated overview pages, and live version tracking across environments. When it ships, onboarding will be as simple as dropping a file in your repo.

Not there yet. Getting closer.

= Change Tickets Will Write Themselves

Today, every production deployment requires someone to manually create a change ticket, collect approvals, and close it after deployment. It works, but it is toil.

The foundation for eliminating that toil was built this month: a dedicated API that can create change tickets, validate approvals, block unauthorized deployments, and close tickets after success — all programmatically.

#v(3mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let box-h = 7
  let box-w = 14
  let gap = 2

  rect((0, 0), (box-w, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[Merge]])

  line((box-w, box-h / 2), (box-w + gap, box-h / 2), mark: (end: ">", fill: lightgray), stroke: 0.6pt + lightgray)

  rect((box-w + gap, 0), (2 * box-w + gap, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((box-w + gap + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[CHG]])

  line((2 * box-w + gap, box-h / 2), (2 * box-w + 2 * gap, box-h / 2), mark: (end: ">", fill: lightgray), stroke: 0.6pt + lightgray)

  rect((2 * (box-w + gap), 0), (3 * box-w + 2 * gap, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((2 * (box-w + gap) + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[Approve]])

  line((3 * box-w + 2 * gap, box-h / 2), (3 * box-w + 3 * gap, box-h / 2), mark: (end: ">", fill: lightgray), stroke: 0.6pt + lightgray)

  rect((3 * (box-w + gap), 0), (4 * box-w + 3 * gap, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((3 * (box-w + gap) + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[Deploy]])

  line((4 * box-w + 3 * gap, box-h / 2), (4 * box-w + 4 * gap, box-h / 2), mark: (end: ">", fill: red), stroke: 0.6pt + red)

  rect((4 * (box-w + gap), 0), (5 * box-w + 4 * gap, box-h), fill: red, stroke: none, radius: 2pt)
  content((4 * (box-w + gap) + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: white)[Close]])
})

#v(2mm)
#align(center)[
  #text(size: 6pt, style: "italic", fill: gray)[The target flow. The API is built. Pipeline wiring comes next.]
]

#v(4mm)

The API is tested, authenticated, and deployed. It is not yet plugged into pipelines — that is the next step. When it connects, no developer will create a change ticket by hand again.

= Two Vulnerabilities, Two Days

OpenBao disclosed a HIGH-severity vulnerability — cross-namespace lease revocation bypassing access controls. Without the patch, any authenticated user could revoke secrets belonging to other teams.

Patched and deployed within days.

Separately, the DigitalOcean Harbor cluster's Nginx ingress controller had an unpatched CVE and was no longer maintained upstream. Replaced with Traefik — zero downtime, DNS repointed, old controller removed.

Both responses followed the same pattern: detect, assess, act, verify. Days, not weeks.

= A New Product Stack Arrived

Clearing — a regulated global payment infrastructure provider — is merging into the Fortris ecosystem. Their engineering stack needs a home: source control, CI/CD pipelines, cloud accounts, runners, and deployment infrastructure.

The platform started the onboarding work this month. Early steps: source repositories mirrored into GitLab, AWS account bootstrapping, initial pipeline configuration. Most of the work is still ahead — but the process is underway and the path is defined.

This is what a platform is for — making the next team as productive as the first, without reinventing infrastructure.

= Also This Month

Preview environments became self-service — any team onboards with a single script. A paid user account that CI pipelines used to automate Git operations was replaced with a free, purpose-built service account — EUR 400/year saved, permissions reduced from broad to minimal. Production Apple certificates were configured for macOS code signing — customers now receive properly signed binaries. Container image signing (cosign) was updated to fix the signing method. PACT contract testing was removed (unused). Temporal's Helm chart moved to official upstream. Bitnami chart proxies prevent rate-limit failures. Monitoring label limits protect the metrics pipeline. Desktop artifacts now publish to GitLab Releases with SHA checksums. A BTC block explorer was provisioned for the blockchain team's development environments.

Fewer surprises. Faster recovery. More trust by default.


