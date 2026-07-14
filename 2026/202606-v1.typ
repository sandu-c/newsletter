#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Six Migrations, One Month],
  authors: (
    (
      name: "June 2026",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
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
    "Kafka",
    "MSK",
    "Harbor",
    "Container Registry",
    "Developer Portal",
    "Backstage",
    "Change Management",
    "Spot Instances",
    "Security",
  ),
  doi: "10.0000/fortris.platform.2026.06",
  abstract: [
    June had no single headline. Instead, five major initiatives advanced in
    parallel: Kafka began its move to managed cloud, the container registry
    migrated to platform-owned infrastructure, the developer portal started
    taking shape, and change management automation laid its main building
    blocks. The platform got cheaper by reversing a previous cost assumption,
    and security patched two urgent vulnerabilities within days. Every thread
    moved forward with measurable progress. This is what a healthy platform
    looks like when it stops firefighting and starts building.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

// Status overview visual
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

    [#text(size: 7pt, fill: gray)[Kafka → MSK]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[ADVANCING]],
    [#text(size: 6.5pt, fill: gray)[Dual-mode tooling live]],

    [#text(size: 7pt, fill: gray)[Harbor Registry]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[ADVANCING]],
    [#text(size: 6.5pt, fill: gray)[Syncing, pipelines switched]],

    [#text(size: 7pt, fill: gray)[Developer Portal (EDIP)]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[FOUNDATION]],
    [#text(size: 6.5pt, fill: gray)[Service panels, autodiscovery]],

    [#text(size: 7pt, fill: gray)[CHG Orchestrator]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[FOUNDATION]],
    [#text(size: 6.5pt, fill: gray)[API deployed, logic complete]],

    [#text(size: 7pt, fill: gray)[Cost Optimization]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[DONE]],
    [#text(size: 6.5pt, fill: gray)[Spot reversed, savings active]],

    [#text(size: 7pt, fill: gray)[Security Response]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[DONE]],
    [#text(size: 6.5pt, fill: gray)[2 CVEs patched in days]],
  )
]

#v(6mm)

= Kafka Is Leaving Swarm

Part of a cross-team initiative to replace self-hosted Kafka with AWS Managed Streaming for Kafka (MSK). The platform shipped the tooling layer that makes the transition invisible to developers.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[WHAT SHIPPED FOR MSK READINESS]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr),
      gutter: 2mm,
      [*Topic management (Strimzi) now works across both Swarm and MSK* — topics propagated to LDT and PROD],
      [*AKHQ deployed* — unified monitoring UI showing both clusters side by side],
      [*mTLS certificates delivered* — JKS/PKCS12 formats with full Amazon CA chain. Java services can authenticate to MSK],
      [*Strimzi CRDs managed independently* — ArgoCD with proper sync ordering],
    )
  ]
]

#v(4mm)

The MSK cluster itself is managed by Infrastructure. Platform provides the developer experience. The tooling is dual-mode — when MSK goes live, services will not notice the change. That is the point: migrations should be invisible to application teams.

= The Container Registry Is Moving

Harbor — where every container image in the organization lives — is migrating from corporate legacy infrastructure to platform-owned at `registry.hub.codecraft.tools`.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[HARBOR MIGRATION PROGRESS]
  #v(3mm)
  #grid(
    columns: (auto, 1fr),
    gutter: 2mm,
    [#text(size: 7pt, fill: red)[●]],
    [#text(size: 7pt, fill: gray)[New instance live — HA, Keycloak SSO, RDS database, S3 storage]],
    [#text(size: 7pt, fill: red)[●]],
    [#text(size: 7pt, fill: gray)[Replication running — old instance pushes everything to new]],
    [#text(size: 7pt, fill: red)[●]],
    [#text(size: 7pt, fill: gray)[GitLab runners switched to new instance]],
    [#text(size: 7pt, fill: red)[●]],
    [#text(size: 7pt, fill: gray)[Helm charts and ArgoCD pointed to new registry]],
    [#text(size: 7pt, fill: red)[●]],
    [#text(size: 7pt, fill: gray)[TestContainers configured for new source]],
    [#text(size: 7pt, fill: lightgray)[○]],
    [#text(size: 7pt, fill: gray)[Robot accounts — pending]],
    [#text(size: 7pt, fill: lightgray)[○]],
    [#text(size: 7pt, fill: gray)[Full pipeline cutover — pending]],
    [#text(size: 7pt, fill: lightgray)[○]],
    [#text(size: 7pt, fill: gray)[Zero-pull verification — pending]],
  )
]

#v(4mm)

Same careful pattern as MongoDB: sync, switch progressively, verify, then cut the old. The old instance remains active until pull metrics confirm nothing reads from it anymore.

= The Developer Portal Took Shape

The Backstage-based internal developer portal (EDIP) went from concept to functional foundation:

- *Service overview panels* auto-generated from GitLab metadata — owner, team, repository links, labels
- *Autodiscovery*: drop a `catalog-info.yaml` file in any repo, get a portal page automatically
- *k8s-versions backend* fetches service versions across environments in background

This is the foundation layer. Kubernetes status, ArgoCD sync state, Grafana alerts, and architecture views come next. But the pattern is established: metadata in, visibility out.

= Change Management Will Automate Itself

A lightweight API was built to orchestrate Jira change tickets from pipelines — the CHG Orchestrator:

#v(3mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let box-h = 7
  let box-w = 14
  let gap = 2

  // 5 boxes in a row, compact
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
  #text(size: 6pt, style: "italic", fill: gray)[Fully automated: merge → ticket → approval gate → deploy → close. Zero manual CHG creation.]
]

#v(4mm)

The engine is deployed. All actions are logged and token-authenticated. Pipeline integration is the next step — when connected, production deployments will require zero manual change ticket creation. Compliance without friction.

= Spot Instances Were More Expensive Than On-Demand

A counterintuitive discovery: with AWS Savings Plans active, spot instances (\$0.115/hr) cost *more* than on-demand (\$0.095/hr) for the same instance type.

#v(3mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let bar-h = 7
  let max-w = 45

  // Spot bar (full width = more expensive)
  rect((0, bar-h + 3), (max-w, 2 * bar-h + 3), fill: lightgray, stroke: none, radius: 2pt)
  content((max-w + 2, bar-h + 3 + bar-h / 2), anchor: "west", [#text(size: 5.5pt, weight: "bold", fill: gray)[Spot · \$0.115/hr]])

  // On-demand bar (shorter = cheaper)
  let od-w = max-w * 0.095 / 0.115
  rect((0, 0), (od-w, bar-h), fill: red, stroke: none, radius: 2pt)
  content((od-w + 2, bar-h / 2), anchor: "west", [#text(size: 5.5pt, weight: "bold", fill: red)[On-Demand · \$0.095/hr]])
})

#v(2mm)
#align(center)[
  #text(size: 6pt, style: "italic", fill: gray)[With Savings Plans, on-demand is 17% cheaper than spot. Previous assumption reversed.]
]

#v(4mm)

Persistent workloads moved back to on-demand. Only short-lived jobs — CI builds, data pipelines — remain on spot where interruption is acceptable. The platform reversed a previous decision based on new data. Cheaper *and* more stable.

= Security Moved Fast

Two urgent security responses in one month:

*OpenBao HIGH vulnerability* — cross-namespace lease revocation could bypass access controls. Upgraded to 2.5.4 within days of disclosure. No exploitation detected.

*DigitalOcean ingress replaced with Traefik* — the Nginx controller had an unpatched CVE and was no longer maintained upstream. Zero-downtime switchover to Traefik completed. No service interruption.

Both responses followed the same pattern: detect, assess severity, patch or replace, verify, document. Days, not weeks.

= Also Shipped

Preview environments became extensible — any service can onboard via a script. The `@gitlab-runner` user was replaced with a scoped service account (saves EUR~400/year, tighter permissions). PACT contract testing infrastructure was removed after Tech Leads confirmed it is unused. Temporal's Helm chart moved to the official upstream under platform ownership. Bitnami chart proxy caches prevent Docker Hub rate limits from breaking builds. Monitoring label limits protect the metrics pipeline from cardinality explosions. Desktop build artifacts now publish to GitLab Release pages with SHA checksums for reproducible builds.

= What June Means

June had no single climax. It was the month where five migrations advanced simultaneously, security responded within days, and the platform got cheaper without getting less reliable.

Every initiative advanced with measurable evidence of progress. The finish lines are in sight.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 6.5pt, fill: gray)[
    *MSK*: tooling ready, dual-mode live #h(4mm)
    *Harbor*: syncing, pipelines switched #h(4mm)
    *Portal*: foundation live #h(4mm)
    *CHG*: API deployed #h(4mm)
    *Cost*: reversed and saved #h(4mm)
    *Security*: patched in days
  ]
]

#v(3mm)

This is what a platform looks like when it stops reacting and starts building. Multiple fronts. Measurable progress. Nothing on fire.
