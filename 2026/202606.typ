#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Cheaper Than Spot],
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
    Spot instances cost more than on-demand. That was the discovery that
    rewrote a cost assumption held since 2025. Meanwhile, Kafka quietly
    prepared to leave Docker Swarm, the container registry began its final
    migration, and the internal developer portal started taking shape in
    staging. Two security vulnerabilities were patched within days
    of disclosure. Five initiatives advanced. None stalled. Every finish
    line moved closer.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= The Assumption That Cost Us Money

Spot instances were supposed to be cheaper. They were not.

With AWS Savings Plans active, on-demand pricing dropped to \$0.095/hr — while spot remained at \$0.115/hr for the same instance type. The platform had been paying a 17% premium for *less* stability.

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
  #text(size: 6pt, style: "italic", fill: gray)[17% cheaper. More stable. Previous assumption reversed.]
]

#v(4mm)

Persistent workloads moved back to on-demand the same week. Only short-lived jobs — CI builds, data pipelines — remain on spot where interruption is acceptable.

The platform reversed its own decision based on data. That takes more discipline than making the decision in the first place.

= Kafka Started Packing

Self-hosted Kafka on Docker Swarm is being replaced by AWS Managed Streaming for Kafka. The platform's job: make sure developers don't notice when it happens.

That required building a tooling layer that works identically across both clusters — so the actual cutover becomes a configuration change, not a migration project for every team.

What shipped:

- Strimzi Topic Operator manages topics as Kubernetes resources — deployed to LDT and PROD with proper sync ordering
- AKHQ provides a single monitoring UI showing *both* Swarm and MSK clusters simultaneously
- mTLS certificates delivered in JKS and PKCS12 formats — Java services can now authenticate to MSK without code changes
- Topic definitions work across both clusters from the same Helm chart

The Kafka cluster itself moves when Infrastructure flips the switch. The tooling is already dual-mode. Services will not need to change.

= Every Container Image Is Moving

Harbor — the registry that stores every container image in the company — is migrating from corporate legacy infrastructure to platform-owned AWS. Without this, a single Docker Hub outage or rate limit could freeze every deployment in every environment.

The new instance is live at `registry.hub.codecraft.tools`. Replication runs continuously from old to new. GitLab runners, Helm charts, ArgoCD, and TestContainers have all switched to the new source.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[HARBOR MIGRATION — WHERE IT STANDS]
  #v(2mm)
  #grid(
    columns: (1fr, 1fr),
    gutter: 4mm,
    [
      #text(size: 6.5pt, weight: "bold", fill: red)[Switched]
      #v(1mm)
      #text(size: 6.5pt, fill: gray)[
        GitLab runners push here\
        Helm chart dependencies\
        ArgoCD credentials\
        TestContainers\
        Documentation updated
      ]
    ],
    [
      #text(size: 6.5pt, weight: "bold", fill: lightgray)[Remaining]
      #v(1mm)
      #text(size: 6.5pt, fill: gray)[
        Robot accounts per cluster\
        Full pipeline push cutover\
        Old instance deprecation\
        Zero-pull verification
      ]
    ],
  )
]

#v(4mm)

Same pattern as every migration this year: sync first, switch progressively, verify, then cut the old. The old instance stays up until pull metrics hit zero for a week.

= The Developer Portal Started Taking Shape

An internal developer portal is being built on Backstage. The goal: a single place where engineers see everything about their services — versions deployed across environments, pipeline status, sync state, alerts — without jumping between five different tools.

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

= Also This Month

Preview environments became self-service — any team onboards with a single script. The `@gitlab-runner` user was replaced with a scoped service account: EUR 400/year saved, permissions tightened. PACT contract testing was removed (unused). Temporal's Helm chart moved to official upstream. Bitnami chart proxies prevent rate-limit failures. Monitoring label limits protect the metrics pipeline. Desktop artifacts now publish to GitLab Releases with SHA checksums.

= What Comes Next

Next month: the old Harbor goes dark. The HashiCorp Vault moves to Kubernetes production. MSK gets closer to its first real traffic. The developer portal gains its first Kubernetes integration.

The finish lines are in sight. Every one of them.
