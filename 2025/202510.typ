#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When Optimization Became Intentional],
  authors: (
    (
      name: "October 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "October",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Cost Optimization",
    "Spot Instances",
    "MongoDB Migration",
    "Vault",
    "CI/CD",
    "Pipeline Gates",
    "Monorepo",
    "Runtime Modernization",
    "Renovate",
    "Observability",
  ),
  doi: "10.0000/fortris.platform.2025.10",
  abstract: [
    October 2025 marked a shift from reactive tuning to deliberate optimization.
    The platform reduced waste without fragility: spot instance adoption for
    dev workloads, a validated MongoDB migration path, Vault on Kubernetes, more
    deterministic CI/CD behavior, and stronger pipeline gates. Runtime and
    dependency modernization removed hidden risk, while environment visibility
    improved shared understanding of what runs where.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When Optimization Became Intentional
By this point, the platform was stable. It was predictable. It was lighter.

That is when optimization stopped being reactive and became deliberate.

October was about proving that scale does not have to mean waste, and that even
the hardest systems -- data, state, and legacy -- could be modernized without
betting the company.

= Kubernetes Cost Optimization with Spot Instances
Cost efficiency is easy to talk about. Harder to execute without breaking
things.

We enabled Spot Instances in development environments across a wide range of
services -- spanning core APIs, data pipelines, vault components, and
frontends -- in close collaboration with Infrastructure.

This was not a blind switch. Services were selected carefully. Failure
tolerance was understood. The platform absorbed volatility so teams did not
have to.

The outcome was not just lower cloud spend. It was a working proof that the
platform can dynamically trade price for capacity without sacrificing developer
experience.

That confidence matters because it unlocks the same patterns at larger scale.

= MongoDB Migration Path: Swarm to Kubernetes (Live Replication)
Stateless workloads are easy. Databases are not.

We needed a path to move a Swarm-backed MongoDB cluster with ~30 databases into
Kubernetes, without a long, downtime-heavy backup/restore window. The team
treated this as a risk analysis problem and evaluated multiple approaches:

- Extend the Swarm replica set into Kubernetes (near-zero downtime, but blocked
  by tooling constraints, expertise requirements, and operational complexity)
- MongoSync (official tooling, but not supported on Community Edition)
- MongoShake (open-source oplog-based sync, community-friendly)
- Dump/restore (simple, but requires a write pause per database)

The proposal is to proceed with MongoShake for a one-way Swarm → Kubernetes
sync. It fits our constraints: Community support, continuous oplog tailing, and
a clear operational boundary. A full end-to-end sync was validated in DEV and
tracked in PLAT-2631.

This was not the migration yet. It was something more important: a viable,
low-risk escape plan from legacy gravity.

= Vault on Kubernetes (HS Vault Helm Chart)
Security infrastructure tends to get frozen in time because nobody wants to
touch it.

That changed.

Vault was deployed into Kubernetes using a dedicated Helm chart, backed by a
managed database and manual unseal. The goal was not automation for its own
sake -- it was control, clarity, and recoverability.

Auto-unseal options are still being evaluated carefully, with recovery and
transfer scenarios taken seriously rather than assumed.

This is how you modernize security systems: cautiously, visibly, and with
reversibility built in.

= CI/CD Logic That Matches Reality (Monorepo Awareness)
Monorepos move fast and break subtly.

A long-standing issue was fixed where applications that should have been
deployed simply disappeared from pipelines if they were not touched again. The
platform now remembers what has not reached production yet and refuses to
forget it.

The logic is precise, deterministic, and environment-aware:

- production history defines the comparison baseline
- fallbacks are explicit
- nothing gets silently skipped

This change does not announce itself. But it quietly prevents partial releases,
inconsistent states, and "how did this miss prod" conversations.

= Stronger Pipeline Gates
Progression through environments now means something.

If post-deployment tests fail, the pipeline stops. No more silent promotions.
No more optimism-based delivery.

This was not about slowing teams down. It was about making failure visible
early, when it is cheap.

= Runtime and Dependency Modernization
Support for outdated Node.js versions was removed across CAMS applications.

Not because upgrades are fun, but because carrying obsolete runtimes is a tax
on security, tooling, and velocity.

At the same time, frontend dependency management became automated. Renovate now
handles controlled upgrades, preview environments, and safe version bumps,
freeing teams from manual maintenance and reducing surprise regressions.

Even small details mattered:

- service accounts replaced licensed users
- previews replaced guesswork
- upgrades became routine instead of disruptive

= Platform Visibility: Environment Comparison
As systems grow, one question keeps coming back:

"What is actually running where?"

An initial dashboard was released to compare running versions across
environments, giving teams a shared source of truth instead of Slack
archaeology.

This is the beginning of operational transparency -- where differences are
visible by default, not discovered during incidents.

= Tooling Ownership: Wiremock Migration
Wiremock was moved into the Platform staging cluster, aligning it with the same
reliability and ownership model as the rest of the platform.

The trade-off was intentional: dynamic, ad-hoc API mutation gave way to
declarative, versioned configuration.

Less flexibility in the moment. More stability over time.

That is a platform decision.

== What October Really Proved
October was not about shipping features.

It was about answering harder questions:

- Can we reduce cost without fragility?
- Can we modernize data without downtime?
- Can we tighten delivery guarantees without slowing teams down?

The answer, repeatedly, was yes.

By now, the platform was not just enabling teams to move fast. It was actively
protecting them from the consequences of scale.

And with cost under control, data migration paths defined, and pipelines
enforcing reality instead of hope, the platform was ready to accelerate even
further.
