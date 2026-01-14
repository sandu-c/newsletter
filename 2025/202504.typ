#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Learned to Hold Steady],
  authors: (
    (
      name: "April 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "April",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Registry Configuration",
    "PDB",
    "Rolling Updates",
    "ArgoCD",
    "Server-Side Apply",
    "Vault",
    "Sentinel",
    "Security",
  ),
  doi: "10.0000/fortris.platform.2025.04",
  abstract: [
    April 2025 stabilized the platform. Registry configuration was centralized,
    deployment safety controls were tightened, stateful systems were protected
    from reckless automation, ArgoCD diffs became meaningful, and customer
    runtime access paths were secured. This is the month the platform learned
    to stay stable while changing.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When the Platform Learned to Hold Steady
Before speed, before scale, before ambition -- a platform has to stay upright.

April was about that discipline.

This was the month where instability was hunted down, centralized assumptions
replaced local hacks, and critical systems were protected from "helpful"
automation.

It was not glamorous. It was essential.

= Centralized Registry Configuration (One Way In)
Image pulls are a deceptively dangerous surface area.

Different charts managing their own registry configuration meant drift,
inconsistency, and unnecessary risk -- especially in security-sensitive
environments like Vault and Sentinel.

April shut that door.

Registry configuration was centralized into a single platform-managed chart,
and per-service overrides were deliberately disabled. From that point on,
workloads consumed images through one controlled, auditable path.

The platform stopped trusting every chart to do the right thing. It enforced it
once -- correctly.

= Deployment Safety: PDBs and Rolling Updates That Match Reality
Availability is not achieved by defaults.

PodDisruptionBudgets and rolling update strategies were revisited across
services using the base chart. The goal was not theoretical uptime -- it was
practical survivability during upgrades, node drains, and configuration
changes.

These adjustments did not speed anything up. They made sure that when change
happened, the platform did not flinch.

= Protecting Stateful Systems from Accidental Restarts
Automation is powerful -- and sometimes reckless.

Reloaders are useful for stateless workloads. They are dangerous around
stateful ones.

April drew a clear boundary: automatic reloads were disabled for critical
StatefulSets in Vault and Sentinel. Configuration changes no longer triggered
unintended restarts, removing a whole class of avoidable instability.

This was a hard-earned lesson turned into policy.

= ArgoCD Comparison: Fewer False Positives, More Signal
GitOps only works if diffs are meaningful.

Changes were made to how ArgoCD compares desired and live state, reducing noise
and preventing spurious drift detection. Server-Side Apply was enabled,
aligning Kubernetes ownership with reality instead of fighting it.

The platform stopped arguing with the cluster and started collaborating with
it.

= Customer Runtime (CR) Moves Closer to Production
April also moved customer-facing workloads forward.

CR gained controlled access to production Treasury systems under a dedicated
domain, with ingress explicitly designed to enforce mutual TLS.

This was not a shortcut. It was a carefully isolated path that respected
production security constraints while unblocking real customer workflows.

To support this, parts of the frontend stack were forked deliberately -- not
duplicated carelessly -- creating a clear separation of concerns without
entanglement.

= Secure Database Initialization by Default
Even the first connection matters.

The base chart was extended to support SSL during database initialization for
MongoDB and Postgres, ensuring that security was not something applied after
the system was already live.

This removed an entire class of "we will fix it later" risks.

== What April Locked Down
April did not accelerate delivery. It made acceleration safe.

By the end of the month:

- critical configuration was centralized
- stateful systems were shielded from automation fallout
- deployments respected availability constraints
- GitOps diffs became trustworthy
- customer access paths were secured by design

This is the month where the platform learned to stay stable while changing.

Without April, May could not have gone live. Without April, June would not have
crossed the point of no return.

April is where the platform earned the right to move fast.
