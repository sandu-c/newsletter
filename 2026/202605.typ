#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Swarm Lost Its Last Excuse],
  authors: (
    (
      name: "May 2026",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "May",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Docker Swarm",
    "Kubernetes",
    "MongoDB",
    "Kafka",
    "Strimzi",
    "Vault",
    "SonarQube",
  ),
  doi: "10.0000/fortris.platform.2026.05",
  abstract: [
    Docker Swarm is no longer a deployment target. The last databases migrated,
    the customer-facing Vault moved to Kubernetes, Kafka topic management became
    native, and CI/CD pipelines dropped Swarm support entirely. Five months of
    disciplined execution — from "ready to migrate" in January to "cannot deploy
    there anymore" in May. Legacy infrastructure retirement is no longer a plan.
    It is done.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= 24 Out of 24

The final MongoDB migration stage completed. All remaining databases — the ones rated "Very High" risk — are now running on Kubernetes.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[STAGE 4 — THE HARDEST BATCH]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 3mm,
      [
        treasury\_services ·  #text(fill: red)[Very High]\
        cams\_psp ·  #text(fill: red)[Very High]\
        order\_services ·  #text(fill: red)[Very High]\
        orion ·  #text(fill: red)[Very High]
      ],
      [
        blockchain\_transaction · High\
        bows · High\
        btc\_send\_order\_batch · High\
        fortris\_balances · Medium
      ],
    )
  ]
  #v(2mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    All migrated with planned downtime windows. These are the financial core — payments, balances, orders, blockchain transactions.
  ]
]

#v(4mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  // Full progress bar
  rect((0, 0), (78, 6), fill: red, stroke: none, radius: 3pt)
  content((39, 3), [#text(size: 6pt, weight: "bold", fill: white)[24 / 24 databases on Kubernetes]])
})

#v(2mm)
#align(center)[
  #text(size: 7pt, weight: "bold", fill: red)[100% complete.]
  #text(size: 6.5pt, fill: gray)[ Docker Swarm no longer hosts any MongoDB data.]
]

#v(4mm)

What started in January as "sync enabled, ready to migrate" reached its conclusion in May. Four stages. Zero data loss. The financial core of the system now runs entirely on Kubernetes.

= The Customer Vault Moved Too

The C3/C3X Vault — the customer-facing secure custody infrastructure where clients sign transactions — migrated from Docker Swarm to Kubernetes.

This was not an internal platform concern. This is client infrastructure. The requirements were absolute: zero data loss, minimal downtime, and a positive customer experience throughout.

The migration succeeded. The customer now operates on Kubernetes, self-managing their environment based on Fortris documentation. One of the oldest Docker Swarm dependencies — and the most sensitive — is gone.

= Kafka Topics Became Code

Kafka topic management moved from a custom Swarm-based operator to Kubernetes-native resources managed by the Strimzi Topic Operator.

The old `swarm-kafka-topics-operator` has been archived.

Now, managing Kafka topics works like any other infrastructure change:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[HOW KAFKA TOPICS ARE MANAGED NOW]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr),
      gutter: 2mm,
      [1. Edit a YAML file — define topic name, partitions, retention, replication],
      [2. Open a merge request — pipeline shows a diff of topic changes across environments],
      [3. Get approval from Platform + code owners],
      [4. Merge — pipeline applies the change automatically via ArgoCD],
    )
  ]
  #v(2mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    Critical changelog topics are separated from standard topics. Partition changes require explicit opt-in.
  ]
]

#v(4mm)

A Kafka UI was also deployed in the development environment — giving developers visual access to topic state, consumer groups, and cluster health without CLI tools.

This approach is forward-compatible: it works with the current Swarm-hosted Kafka cluster and will work identically when the future move to managed Kafka (MSK) happens.

= The Pipeline Forgot How to Deploy to Swarm

CI/CD pipelines no longer support Docker Swarm as a deployment target.

This is not a deprecation notice. It is removal. The deployment mechanism itself has been updated — services physically cannot be deployed to Swarm even if someone attempted it.

Combined with the MongoDB migration completing and the Vault moving to Kubernetes, Docker Swarm has lost every reason to exist:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 6mm,
    [
      #text(size: 7pt, weight: "bold", fill: lightgray)[SWARM HOSTED (Jan 2026)]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        24 MongoDB databases\
        C3/C3X Vault\
        Kafka topic operator\
        CI/CD deployment support\
        Active services
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[SWARM HOSTS (May 2026)]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        Nothing new deploys here\
        Kafka cluster (managed externally)\
        Pending final decommission
      ]
    ],
  )
]

#v(4mm)

Five months. From "the legacy runtime" to "unsupported."

= SonarQube Found Its Home

SonarQube — the static code analysis tool used by all engineering teams — migrated to the platform production cluster at `codereview.hub.codecraft.tools`.

Another tool previously living on corporate IT infrastructure, now owned and operated by the platform team. Same pattern as every other migration: predictable domain, platform-managed lifecycle, isolated from unrelated systems.

= Cleaning Up the Remains

With Swarm no longer receiving deployments, the cleanup began:

- Legacy Swarm management tools removed from infrastructure (Portainer, DeployD API, apps-config-crypt)
- Swarm-related platform operator repositories archived
- Legacy deployment container images (`tn-deploy`) deprecated and removed — these used insecure user impersonation that no longer has a reason to exist
- apps-config repositories archived

What cannot deploy also should not exist in the codebase. Dead code attracts confusion.

= What May Means

May is the month the legacy retirement plan stopped being a plan.

Docker Swarm no longer hosts databases. It no longer runs customer infrastructure. It no longer receives deployments. The CI/CD system has forgotten it exists.

What remains on Swarm is Kafka (migrating to MSK) and HashiCorp Vault (migrating to Kubernetes). Both have plans. Neither is blocked. The platform stopped deploying applications to Swarm — what is left is infrastructure being retired on its own timeline.

The platform team delivered what it promised in January: Kubernetes as the only runtime that matters. It took five months of disciplined, staged execution. No shortcuts. No incidents during migration. No data lost.

Done.
