#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Zero Downtime, Twenty Databases],
  authors: (
    (
      name: "February 2026",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "February",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "MongoDB",
    "MongoShake",
    "Kubernetes",
    "Docker Swarm",
    "Rolling Migration",
    "ArgoCD",
    "Infisical",
  ),
  doi: "10.0000/fortris.platform.2026.02",
  abstract: [
    The MongoDB production migration began — and kept going. Three stages
    of rolling cutover moved 17 out of 24 databases from Docker Swarm to
    Kubernetes with zero downtime. MongoShake handled live replication,
    ArgoCD triggered the switchover, and a tested rollback plan was never
    needed. The legacy runtime started losing its last reason to exist.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= The Migration That Did Not Break Anything

January proved that MongoDB on Kubernetes was production-ready. February proved it at scale.

Three migration stages ran in production over ten days. Each followed the same disciplined process. Each completed with zero downtime. Not because the team was lucky — because MongoShake had been replicating data live for weeks before the cutover happened.

The procedure was deliberate:

+ Sync MongoDB indexes between Swarm and Kubernetes using a custom validation script
+ Update connection details in Infisical and Helm charts
+ Trigger ArgoCD sync — services start reading from Kubernetes MongoDB
+ Disable the database user on the Swarm source
+ Remove network policies that allowed Swarm connectivity

Each step was reversible. Each stage had a tested rollback plan. None required it.

= Three Stages, Zero Surprises

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[MIGRATION STAGES — PRODUCTION (CLOUD1)]
  #v(3mm)
  #grid(
    columns: (1fr),
    gutter: 4mm,
    [
      #text(size: 7pt, weight: "bold", fill: red)[Stage 1 · Feb 25]
      #text(size: 7pt, fill: gray)[
        14 databases: account-services, fortris-accounts, user-devices, coinbase-\*, gov-send-orders, governance-gateway, gov-receive-order, gov-account, gov-business, gov-addr-pool, psp-propine\
        _Covers: account details, login & 2FA, governance functionality_
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[Stage 2 · Mar 2]
      #text(size: 7pt, fill: gray)[
        4 databases: fortris-user-actions, fortris-receive-orders, fortris-send-orders, fortris-statements\
        _Covers: balances, statements, send & receive order lists_
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[Stage 3 · Mar 5]
      #text(size: 7pt, fill: gray)[
        4 databases + data platform: data-services, journal-report-services, bitcoin-watching-wallet, data-analytics (including kafka-connect, accounting-api, dashboards-api)\
        _Covers: crypto accounting dashboards, journal reports, wallet recovery_\
        _Note: kafka-connect paused ~5 min during cutover_
      ]
    ],
  )
]

#v(4mm)

Every stage went through formal change management, with security approval from the Product Security team and platform team sign-off before execution.

= Where It Stands

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[DATABASE LOCATION — AFTER STAGE 3]
  #v(3mm)
  #grid(
    columns: (1fr, 1fr),
    gutter: 4mm,
    [
      #text(size: 7pt, weight: "bold", fill: red)[Kubernetes (17)]
      #text(size: 6.5pt, fill: gray)[
        account\_services\
        bitcoin\_watching\_wallet\
        coinbase\_accounts\
        coinbase\_integration\
        coinbase\_receive\_orders\
        coinbase\_send\_orders\
        data\_analytics\
        data\_services\
        fortris\_accounts\
        fortris\_receive\_orders\
        fortris\_send\_orders\
        fortris\_statements\
        fortris\_user\_actions\
        journal\_report\_services\
        psp\_propine\
        user\_devices\
        gov\_\* (all new)
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: rgb("#8a919c"))[Swarm (7 remaining)]
      #text(size: 6.5pt, fill: gray)[
        blockchain\_transaction\
        bows\
        btc\_send\_order\_batch\
        cams\_psp\
        fortris\_balances\
        order\_services\
        orion\
        treasury\_services
      ]
    ],
  )
]

#v(4mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  // Progress bar background
  rect((0, 0), (78, 6), fill: rgb("#f0f0f0"), stroke: 0.5pt + lightgray, radius: 3pt)

  // Progress bar fill (17/24 = ~71%)
  rect((0, 0), (55, 6), fill: red, stroke: none, radius: 3pt)

  // Label
  content((39, 3), [#text(size: 6pt, weight: "bold", fill: white)[17 / 24 databases]])
  content((67, 3), [#text(size: 5pt, fill: gray)[7 left]])
})

#v(2mm)
#align(center)[
  #text(size: 6.5pt, style: "italic", fill: gray)[
    Migration progress: ~75% of production databases now run on Kubernetes
  ]
]

#v(4mm)

The remaining seven databases are scheduled after the C3x Vault migration to Kubernetes completes. The pattern is proven. What remains is sequencing.

Any new database now deploys directly to Kubernetes. The platform provides self-service provisioning through Helm chart configuration — developers declare a database name and user, and an init container handles the rest. No tickets, no waiting.

= Secrets Stopped Costing Money

Infisical is gone. OpenBao replaced it.

The decision was straightforward: Infisical was a paid tool providing functionality that OpenBao — an open-source Vault fork — delivers for free. Same access controls. Same auditability. Same centralised secret storage. Zero license cost.

OpenBao is now live in production at `secrets.hub.codecraft.tools`, serving four teams: Platform, Data, Vault, and Orion. Secrets are managed through a web UI with OIDC single sign-on — the same credentials engineers already use.

The architecture is Kubernetes-native. Services never touch secrets directly:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[HOW SECRETS REACH APPLICATIONS]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr),
      gutter: 2mm,
      [1. Application deploys with an ExternalSecret resource],
      [2. External Secrets Operator authenticates to OpenBao via Kubernetes ServiceAccount],
      [3. OpenBao returns the secret from its KV v2 store],
      [4. ESO creates a native Kubernetes Secret],
      [5. Pod consumes the secret — no SDK, no sidecar, no agent],
    )
  ]
]

#v(4mm)

No application code changes were required. The migration was a Helm chart update — switching the `ExternalSecret` reference from Infisical to OpenBao. A `migrate-secrets` tool synced content between the two systems as a safety net before each cutover.

The production changes went through formal change management for Data and RDS services. Vault services required no change request — they were not yet live in production. Platform services were migrated directly since they are owned by the team performing the migration.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 6mm,
    [
      #text(size: 7pt, weight: "bold", fill: rgb("#8a919c"))[INFISICAL (before)]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        Paid SaaS license\
        Proprietary secret injection\
        Vendor-managed availability\
        Cost scaled with usage
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[OPENBAO (after)]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        Open source, zero license cost\
        Kubernetes-native via ESO\
        Platform-owned availability\
        Policies provisioned via Terraform
      ]
    ],
  )
]

#v(4mm)

The remaining teams will migrate progressively. The pattern is proven, the tooling exists, and the documentation is published. Infisical's license renewal date is now irrelevant.

The migration succeeded without incident because the hard work happened months before the cutover:

- MongoShake ran live replication across all environments, validated under production load
- Connection strings lived in Infisical — a single change, deployed via Helm, triggered by ArgoCD
- Network policies ensured no service could accidentally reach Swarm after migration
- A custom Python script validated index parity between source and target before each stage

The migration was not an event. It was a configuration change — made safe by months of preparation.

= Less Constraint, Less Waste

Two changes reduced friction and cost simultaneously.

*CPU limits removed.* ResourceQuotas and LimitRanges were removed from all application namespaces. CPU limits are no longer enforced or required in Helm charts.

This reverses a decision from early 2025. In practice, CPU limits caused more problems than they solved — healthy services were throttled during traffic spikes while idle services held unused capacity. Memory limits remain as a safety net. CPU is now unbounded. One less thing to configure. One less reason for a deployment to fail.

*A production environment shut down.* The PROD3 environment was disabled in CI/CD pipelines. Infrastructure is decommissioning it entirely for cost savings — the environment served a specific client deployment that is no longer required. Removing it from the pipeline prevents wasted build time and eliminates deploying to an environment nobody monitors.

The platform got smaller. That made it cheaper and easier to reason about.

= What This Means

Docker Swarm is no longer the authority for production data in most of the system. The remaining databases are not blocked by technology. They are blocked by sequencing — the Vault migration takes priority.

Once it completes, the final seven databases will follow the same proven pattern. Swarm's last operational dependency will be removed.

The platform did not rush. It did not guess. It moved data at scale, with zero downtime, and a rollback plan that was never needed.
