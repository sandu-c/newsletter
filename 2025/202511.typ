#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [The Platform Starts Eliminating Waste],
  authors: (
    (
      name: "November 2025",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "November",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Ingress",
    "ALB",
    "mTLS",
    "CI/CD",
    "Artifact Retention",
    "Caching",
    "Harbor",
    "Swarm Deprecation",
    "GitLab Runners",
    "Managed Databases",
    "Amazon Q",
  ),
  doi: "10.0000/fortris.platform.2025.11",
  abstract: [
    November 2025 focused on removing drag from the platform. We unified ingress
    paths, tightened CI/CD behavior, reduced storage waste, accelerated builds
    with local proxies, consolidated Docker artifacts, and retired legacy
    assumptions. The platform became lighter, clearer, and easier to operate.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== The Platform Starts Eliminating Waste
Once you control how change reaches production, a different problem becomes
visible. Waste.

Not obvious waste — but the slow, silent kind:

- duplicated traffic paths
- pipelines doing work nobody asked for
- storage growing because nothing ever cleaned up after itself
- legacy assumptions quietly taxing every release

This phase of the year was about removing that drag.

= Ingress Stack Unification (AWS ALB with mTLS)
Traffic entering the platform used to follow multiple paths, each with its own
rules and exceptions.

That complexity didn’t add flexibility — it added uncertainty.

By unifying the ingress stack and migrating key services to AWS-native mTLS
support through ALB Ingress, we simplified how services talk to the outside
world and how they trust each other.

Security stopped being an overlay and became part of the path itself.

This wasn’t done in isolation. It required tight coordination between
Infrastructure and Platform teams — and it paid off with a cleaner, more
predictable entry point into the system.

Less divergence. Fewer edge cases. Stronger defaults.

= CI/CD Resource Discipline (Maven Deploy Opt-In)
For years, pipelines deployed artifacts because they could — not because they
should.

That changed.

By making Maven deploy explicitly opt-in, we forced an important decision back
to the pipeline author: does this build actually need to publish something?

Most didn’t.

The result wasn’t just cleaner pipelines. It was a shift in mindset:

- fewer unnecessary artifacts
- clearer intent in CI configuration
- reduced load on downstream systems

Small change. Disproportionate payoff.

= Artifact Retention and Cache Control (GitLab + Nexus)
Storage doesn’t explode overnight. It grows quietly — until it hurts.

We tackled this head-on.

Retention policies were tightened across GitLab and Nexus, removing artifacts
that hadn’t been used in months. Runner caches gained expiration. Old blobs
stopped living forever “just in case.”

The numbers told the story:

- GitLab storage dropped dramatically
- Nexus blobstores shrank to a fraction of their size

But the real win was operational: systems became faster, cheaper, and easier to
reason about.

This is platform hygiene — invisible when done right, painful when ignored.

= Local APT Proxies and Image Build Acceleration
Every Docker build was paying a tax to the internet.

External repositories. Repeated downloads. Uncached dependencies.

By introducing local APT proxies for Debian and Ubuntu and updating base images
to use them, builds stopped reaching out blindly and started using
platform-local infrastructure.

At the same time, Docker layer caching was fixed properly — per project, not
shared in a way that invalidated everything on every build.

An old bug that forced full rebuilds quietly disappeared.

Builds became faster. More predictable. Less wasteful.

= Docker Artifact Unification in Harbor
Docker artifacts no longer live scattered across tools.

By moving cache storage and images into Harbor, all Docker-related assets now
sit under one roof — with consistent policies, visibility, and control.

This wasn’t just consolidation. It was the foundation for traceability and
governance around container artifacts.

= Swarm Deprecation (Reducing Legacy Gravity)
Legacy platforms don’t fail loudly. They slow you down until innovation feels
expensive.

We continued removing implicit Swarm behavior, forcing deployment logic to be
explicit and intentional. Defaults that once made sense were retired.
Configuration became clearer.

This wasn’t about removing Swarm overnight. It was about removing its gravity.

= GitLab Runner Stack Maturity (Platform STG)
The CI/CD foundation itself evolved.

A new GitLab Runner stack was deployed in the Platform staging environment,
replacing legacy infrastructure and introducing clear runner profiles —
on-demand and spot — that pipeline authors can choose deliberately.

This simplified runner creation, reduced coupling, and gave teams control
without chaos.

Infrastructure became composable instead of bespoke.

= Platform Services on Managed Databases
Even internal tools deserve production-grade foundations.

By migrating platform services like TestRail and Backstage to managed RDS
instances, we removed hidden operational risk and aligned platform tooling with
the same standards expected of customer-facing systems.

Consistency matters — especially when the platform is the product.

= Amazon Q: From Experiment to Operable Service
AI tools don’t scale on enthusiasm alone.

To make Amazon Q usable in production, we built the operational backbone around
it: metrics, usage tracking, reporting, and visibility for IT support.

What used to be opaque is now measurable. What used to be manual is now
automated.

This is how innovation survives contact with reality.

= Clearing the Last Shadows
Finally, we removed deprecated environments and legacy validation paths that no
longer belonged in the system.

Not because they were broken — but because they were no longer aligned with
where the platform is going.

Every removal made the platform clearer. Every simplification reduced
cognitive load.

== Momentum, Not Just Motion
By this point in the year, something had changed.

The platform wasn’t just safer. It wasn’t just faster.

It was lighter.

Less waste. Fewer assumptions. Cleaner paths from code to production.

This is what maturity looks like in practice:

- not more features
- not more tools
- but fewer unnecessary things slowing everyone down

And with that weight gone, the platform was ready for what came next.
