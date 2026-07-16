#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Claimed Its Own],
  authors: (
    (
      name: "January 2026",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "January",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "MongoDB",
    "MCK Operator",
    "Kubernetes",
    "Docker Swarm",
    "AWS",
    "MongoShake",
    "CyberChef",
    "GitLab Runners",
  ),
  doi: "10.0000/fortris.platform.2026.01",
  abstract: [
    January 2026 drew two boundaries. MongoDB became production-ready on
    Kubernetes — backed by the MCK operator, S3 backups, MongoShake live sync,
    and a critical security patch — unlocking the final migration path away
    from legacy infrastructure. Simultaneously, platform tooling moved from a
    shared staging cluster into a dedicated production AWS account under the
    `hub.codecraft.tools` domain, making ownership explicit and access
    predictable.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= Data Finally Belongs to the Cluster

MongoDB on Kubernetes is no longer experimental.

The MongoDB Community Kubernetes (MCK) operator now manages all database lifecycle operations — provisioning, scaling, and failover — inside the cluster. Atlas was evaluated and rejected: the security model did not meet requirements for workloads handling financial data. The platform chose to own the problem instead of renting a compromise.

MongoShake — an open-source change-stream replication tool — now synchronises data continuously from Docker Swarm into Kubernetes. It runs as a StatefulSet with explicit database whitelisting, connecting to Swarm's MongoDB cluster over TLS with a custom CA. A dedicated Prometheus exporter feeds MongoShake replication lag and status into existing Grafana dashboards, making sync health visible without guessing.

The `mongodb_exporter` was integrated directly into the MongoDB Helm chart, providing per-instance metrics and a dedicated Grafana dashboard. Observability is no longer bolted on — it ships with every MongoDB deployment.

A security patch was applied across all environments: MongoDB was upgraded to version 7.0.28 to mitigate MongoBleed (SERVER-115508), a memory disclosure vulnerability that could leak sensitive data from server memory. The product security team was notified, and both frontend and backend Helm charts were updated within days of disclosure.

What shipped:

- MCK operator deployed across all environments
- Centralised S3 backup bucket for automated MongoDB dumps
- MongoShake live sync from Docker Swarm to Kubernetes (all environments)
- `mongodb_exporter` integrated into the Helm chart with Grafana dashboards
- MongoBleed security patch (MongoDB 7.0.28) applied cluster-wide
- Backend services validated against Kubernetes-hosted MongoDB in DEV

#v(4mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[MIGRATION PATH]
  #v(2mm)
  #cetz.canvas(length: 1mm, {
    import cetz.draw: *

    // Swarm box
    rect((0, 0), (28, 18), stroke: 0.6pt + lightgray, fill: rgb("#f5f5f5"), name: "swarm")
    content((14, 15), [#text(size: 6pt, weight: "bold", fill: gray)[Docker Swarm]])
    content((14, 10), [#text(size: 5.5pt, fill: gray)[MongoDB]])
    content((14, 7), [#text(size: 5pt, fill: lightgray)[(legacy)]])

    // Arrow
    line((30, 9), (42, 9), stroke: 1pt + red, mark: (end: ">", fill: red))
    content((36, 12), [#text(size: 5pt, style: "italic", fill: red)[MongoShake]])

    // K8s box
    rect((44, 0), (78, 18), stroke: 0.8pt + red, fill: rgb("#fef8f7"), name: "k8s")
    content((61, 15), [#text(size: 6pt, weight: "bold", fill: gray)[Kubernetes]])
    content((61, 10), [#text(size: 5.5pt, fill: gray)[MongoDB (MCK)]])
    content((61, 7), [#text(size: 5pt, fill: lightgray)[(production-ready)]])

    // S3 box
    rect((50, -8), (72, -2), stroke: 0.5pt + lightgray, fill: rgb("#f9f9f9"))
    content((61, -5), [#text(size: 5pt, fill: gray)[S3 Backup Bucket]])

    // Arrow down to S3
    line((61, 0), (61, -2), stroke: 0.5pt + lightgray, mark: (end: ">", fill: lightgray))
  })
  #v(1mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    MongoShake replicates state from Swarm into Kubernetes over TLS. Once validated, the direction reverses irreversibly.
  ]
]

#v(4mm)

This is the precondition for the backend MongoDB migration. The sync is running. The operator is proven. The security posture is current. What remains is team-by-team cutover — a coordination problem, not a platform one.

= Engineering Tools Found Their Home

Developer tooling no longer lives on borrowed infrastructure.

Every platform service previously ran on corporate IT infrastructure — the same cluster that hosted IT service desk tools and unrelated internal applications. These are engineering tools. They belong with the platform team, in infrastructure the platform team controls.

They now run on the platform team's own production AWS account, deployed via ArgoCD Helm charts, under a single predictable domain. The full inventory of migrated services:

#v(3mm)

#block(width: 100%, stroke: 1pt + red, radius: 8pt, inset: 12pt)[
  #align(center)[
    #text(size: 9pt, weight: "bold", fill: gray)[`<service>.hub.codecraft.tools`]
  ]
  #v(4mm)
  #text(size: 7pt, fill: gray)[
    #table(
      columns: (1fr, 2fr),
      stroke: none,
      inset: 4pt,
      [*Service*], [*URL*],
      [CyberChef], [`cyberchef.hub.codecraft.tools`],
      [Kubeseal GUI], [`kubeseal.hub.codecraft.tools`],
      [Backstage], [`backstage.hub.codecraft.tools`],
      [CI Reports], [`ci-reports.hub.codecraft.tools`],
      [TestRail], [`testrail.hub.codecraft.tools`],
      [Wiremock], [`wiremock.hub.codecraft.tools`],
      [GitLab Runners], [Network-isolated in PROD cluster],
      [RDS Databases], [Internal, PROD AWS account],
    )
  ]
]

#v(4mm)

CyberChef — a browser-based tool for encoding, encryption, compression, and data analysis — was the first to move. It ensures all sensitive data processing remains confidential within the user's browser, never leaving the client. The platform hosts it internally to avoid third-party data exposure.

Kubeseal GUI followed immediately, giving engineers a visual interface for encrypting Kubernetes secrets without touching the CLI. Both were the first services locked behind BasicAuth on the old staging environment after migration, forcing teams toward the production URLs.

GitLab Runners moved to the production cluster with a deliberate security boundary: staging runners were network-restricted to corporate, DEV, and LDT ranges only — they cannot reach production environments under any circumstances. Production runners became the default queue for all CI/CD pipelines, with IAM roles bootstrapped via Terraform.

RDS databases were provisioned in the new production AWS account, managed through the same Helm-chart-driven pipeline as every other platform resource.

#v(4mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 6mm,
    [
      #text(size: 7pt, weight: "bold", fill: rgb("#8a919c"))[BEFORE]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        Engineering tools mixed with IT tools\
        Upgrades required cross-team coordination\
        Unrelated outages affected developers\
        No safe place to test changes\
        Ownership was unclear\
        Runners shared with unrelated workloads
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[AFTER]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        Engineering tools run independently\
        Platform team owns the full lifecycle\
        Isolated from corporate IT failures\
        STG locked with BasicAuth after migration\
        One domain, clear ownership\
        Runners network-restricted by environment
      ]
    ],
  )
]

#v(4mm)

This is not a domain change. It is an ownership change. The platform team now controls uptime, patching, security posture, and cost of the tools engineers depend on daily. Staging still exists — but behind a BasicAuth wall, reserved exclusively for testing platform changes before they reach production.

= What This Unlocks

Both moves serve the same strategic arc: the platform owning what it operates.

MongoDB on Kubernetes removes the last hard dependency on Docker Swarm for stateful workloads. MongoShake keeps the data flowing while teams prepare to cut over. The MongoBleed patch demonstrates that the platform can respond to security disclosures within days, not weeks — because it owns the deployment pipeline end-to-end.

The tooling migration removes the last dependency on corporate IT for engineering tools. Eight services — from CI Reports to RDS databases — now live in infrastructure the platform team provisions, monitors, and patches without external coordination.

What remains is execution — not architecture decisions. The foundations are in place. The path is one-way.
