#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Four Hours From Failure to Fix],
  authors: (
    (
      name: "April 2026",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "April",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "PodDisruptionBudget",
    "MongoDB",
    "PostgreSQL",
    "GitLab",
    "CI/CD",
    "Desktop Pipeline",
    "ALB",
    "Harbor",
  ),
  doi: "10.0000/fortris.platform.2026.04",
  abstract: [
    A routine change briefly disrupted a production database — one customer
    noticed one data discrepancy, resolved within minutes by the support team.
    The platform team traced the root cause within hours and deployed a
    structural fix that makes the failure impossible to repeat. April also
    brought faster builds through smarter caching, eliminated redundant cloud
    costs, completed desktop application delivery for all platforms, and
    upgraded core databases and tools to their latest versions.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= The Incident That Taught the Cluster a Lesson

On April 16, MongoDB production connections dropped. Every service that depended on the database experienced timeouts.

The cause: a routine Helm chart update triggered a rolling restart of the MongoDB replica set. During the restart, the Kubernetes cluster autoscaler noticed reduced resource usage and decided to reclaim nodes — evicting MongoDB pods that were still restarting. All three replicas went down simultaneously. The database refused to form a quorum.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[WHAT HAPPENED]
  #v(3mm)
  #cetz.canvas(length: 1mm, {
    import cetz.draw: *

    // Timeline
    line((0, 8), (78, 8), stroke: 0.4pt + lightgray)

    // Events
    rect((2, 10), (18, 16), fill: rgb("#f5f5f5"), stroke: 0.5pt + lightgray, radius: 2pt)
    content((10, 13), [#text(size: 4.5pt, fill: gray)[Helm update]])

    line((18, 13), (22, 13), stroke: 0.4pt + gray, mark: (end: ">", fill: gray))

    rect((22, 10), (40, 16), fill: rgb("#f5f5f5"), stroke: 0.5pt + lightgray, radius: 2pt)
    content((31, 13), [#text(size: 4.5pt, fill: gray)[Rolling restart]])

    line((40, 13), (44, 13), stroke: 0.4pt + gray, mark: (end: ">", fill: gray))

    rect((44, 10), (62, 16), fill: rgb("#fff0ee"), stroke: 0.5pt + red, radius: 2pt)
    content((53, 13), [#text(size: 4.5pt, fill: red)[Autoscaler evicts]])

    line((62, 13), (66, 13), stroke: 0.4pt + red, mark: (end: ">", fill: red))

    rect((66, 10), (78, 16), fill: rgb("#fff0ee"), stroke: 0.8pt + red, radius: 2pt)
    content((72, 13), [#text(size: 4.5pt, weight: "bold", fill: red)[All pods down]])

    // Below: fix timeline
    rect((2, 0), (22, 6), fill: rgb("#f0faf0"), stroke: 0.5pt + rgb("#4a9"), radius: 2pt)
    content((12, 3), [#text(size: 4.5pt, fill: gray)[Root cause found]])

    line((22, 3), (26, 3), stroke: 0.4pt + gray, mark: (end: ">", fill: gray))

    rect((26, 0), (50, 6), fill: rgb("#f0faf0"), stroke: 0.5pt + rgb("#4a9"), radius: 2pt)
    content((38, 3), [#text(size: 4.5pt, fill: gray)[PDB added to chart]])

    line((50, 3), (54, 3), stroke: 0.4pt + gray, mark: (end: ">", fill: gray))

    rect((54, 0), (78, 6), fill: rgb("#f0faf0"), stroke: 0.8pt + rgb("#4a9"), radius: 2pt)
    content((66, 3), [#text(size: 4.5pt, weight: "bold", fill: rgb("#2a7"))[Deployed to PROD]])

    // Labels
    content((39, 18.5), [#text(size: 5pt, style: "italic", fill: red)[The failure]])
    content((39, -2.5), [#text(size: 5pt, style: "italic", fill: rgb("#2a7"))[The response — same day]])
  })
]

#v(4mm)

The missing piece was a Pod Disruption Budget — a Kubernetes resource that tells the autoscaler "you may not evict more than one replica at a time." Without it, the autoscaler was free to drain nodes without regard for database quorum.

Customer impact was minimal — one data discrepancy in a single order, noticed days later and resolved within minutes by the support team. The database recovered on its own. But the structural gap was real: a routine change should never be able to risk database quorum.

Once the platform team was brought in to investigate, root cause was identified within 90 minutes and the permanent fix deployed to production the same afternoon:

- PDB support added to the MongoDB Helm chart
- PDB support added to the base application chart for all StatefulSet workloads
- Deployed through change management to production

It cannot happen again. The autoscaler now knows what it is not allowed to touch.

= Builds Got Faster Without Anyone Asking

CI/CD pipeline caches were growing without limit. Node projects accumulated gigabytes of NX cache. Java builds dragged multi-hundred-megabyte `.m2` directories across every job. Cache downloads became slower than fresh installs.

The fix introduced automatic cache hygiene:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[CACHE SIZE LIMITS BY LANGUAGE]
  #v(3mm)
  #cetz.canvas(length: 1mm, {
    import cetz.draw: *

    // Bars
    let bar-h = 8
    rect((0, 0), (30, bar-h), fill: lightgray, stroke: none, radius: 2pt)
    content((15, bar-h / 2), [#text(size: 6pt, weight: "bold", fill: white)[Java · 512 MB]])

    rect((0, bar-h + 3), (70, bar-h * 2 + 3), fill: red, stroke: none, radius: 2pt)
    content((35, bar-h + 3 + bar-h / 2), [#text(size: 6pt, weight: "bold", fill: white)[Node · 1500 MB]])

    rect((0, (bar-h + 3) * 2), (30, bar-h * 3 + 6), fill: lightgray, stroke: none, radius: 2pt)
    content((15, (bar-h + 3) * 2 + bar-h / 2), [#text(size: 6pt, weight: "bold", fill: white)[Python · 512 MB]])
  })
  #v(2mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    Caches exceeding these limits are automatically pruned before upload.
  ]
]

#v(4mm)

Additionally, a fallback cache key means new branches no longer start cold — they inherit the default branch cache and build incrementally from there.

Developers did not request this. They just noticed builds were faster.

= Four Load Balancers Became One

Preview environments — the ephemeral deployments created from merge requests — were each spinning up their own AWS Application Load Balancer. Four ALBs running in parallel when one would serve all of them.

A missing ingress annotation meant each new preview created isolated infrastructure instead of sharing the existing load balancer. The fix was a single annotation in the Helm values file.

Result: ongoing cloud cost eliminated, fewer resources to track, same functionality.

= Desktop Delivery Is Now Complete

The Windows GitLab Runner joined the fleet, completing the cross-platform desktop application pipeline.

The Custody Manager Tool — the application customers use to onboard their Key Management System to the Fortris Vault platform — can now be built, signed, and distributed across all three operating systems from a single CI/CD pipeline.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[DESKTOP PIPELINE — COMPLETE]
  #v(3mm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 3mm,
    [
      #align(center)[
        #text(size: 7pt, weight: "bold", fill: red)[Linux]
        #v(1mm)
        #text(size: 6pt, fill: gray)[Standard runners\ Self-signed]
      ]
    ],
    [
      #align(center)[
        #text(size: 7pt, weight: "bold", fill: red)[macOS ARM]
        #v(1mm)
        #text(size: 6pt, fill: gray)[Bare-metal Mac\ Apple certificates]
      ]
    ],
    [
      #align(center)[
        #text(size: 7pt, weight: "bold", fill: red)[Windows]
        #v(1mm)
        #text(size: 6pt, fill: gray)[Dedicated runner\ Production signed]
      ]
    ],
  )
]

#v(4mm)

The same pipeline was also extended to deploy the Next Generation Vault's Governance Gateway to Google Cloud production — multi-cloud delivery from a single CI/CD system.

= Everything Got Upgraded

Three infrastructure components moved to their latest versions:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 4mm,
    [
      #text(size: 7pt, weight: "bold", fill: red)[GitLab]
      #v(1mm)
      #text(size: 6.5pt, fill: gray)[18.0 → 18.11]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[PostgreSQL]
      #v(1mm)
      #text(size: 6.5pt, fill: gray)[14–17.4 → 17.9\ (all instances)]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[Harbor (charts)]
      #v(1mm)
      #text(size: 6.5pt, fill: gray)[External → proxied\ (resiliency)]
    ],
  )
]

#v(4mm)

The PostgreSQL upgrade is notable: the legacy corporate database jumped three major versions (14 → 17.9) in a single change window. All RDS instances across CAMS, Platform, and Corporate now run the same version. No more "it works on a different Postgres" surprises.

External Helm chart repositories are now proxied through Harbor — if an upstream registry goes down or rate-limits, cached charts keep deployments working. One less external dependency in the critical path.

= Small Enablers

*ServiceAccount support in cams-base-chart.* Applications can now declare their own cloud identity directly in their Helm configuration. This means a service can access AWS resources — like S3 buckets or message queues — without storing static credentials. The identity is tied to the running pod, not to a shared secret. Requested by the Data team for their analytics pipelines, now available to all teams.

= What April Delivered

April had a production incident. It responded in four hours with a structural fix. It made builds faster, eliminated waste, completed a cross-platform delivery capability, and brought core tools to their latest versions.

The pattern is consistent: when something breaks, it gets fixed permanently. When something costs money unnecessarily, it gets eliminated. When something is outdated, it gets upgraded — not next quarter, but now.
