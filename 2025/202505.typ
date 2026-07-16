#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Proved It Could Run Real Money],
  authors: (
    (
      name: "May 2025",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "May",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Kubernetes",
    "bcoin",
    "Swarm Deprecation",
    "Backup Resilience",
    "Security",
    "IAM Roles",
    "Secrets",
    "Kafka",
  ),
  doi: "10.0000/fortris.platform.2025.05",
  abstract: [
    May 2025 was the proof point. bcoin went live in production on Kubernetes,
    Swarm deprecation began for frontend delivery, support backups gained
    resilience, and security started shifting away from long-lived credentials.
    Secrets were unified under a single system, and Kafka moved toward
    declarative, GitOps-friendly workflows. The platform became real.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When the Platform Proved It Could Run Real Money
Every platform story needs a moment where theory meets consequence.

May was that moment.

This is when systems that actually move value went live -- and the platform had
to earn trust, not ask for it.

= bcoin Goes Live in Production
bcoin was not a test case.

It went live in multiple production environments, running on the platform,
backed by Kubernetes, and delivered through the new Helm-based workflows.

This mattered because it was not infrastructure for infrastructure's sake. It
was a real financial system, with real impact, running on the platform by
design.

From this point forward, Kubernetes was not "ready soon." It was already
carrying the load.

= Frontend Swarm Deprecation Begins
Legacy systems do not disappear in one move -- they get displaced.

May marked the start of that displacement.

Swarm deployments for frontend projects were deprecated, signaling a clear
direction: Kubernetes is where modern delivery happens. Production was not
disrupted -- it already relied on configuration-driven deployments -- but the
path forward became unambiguous.

No more split futures. No more hedging.

= Support Systems Catch Up to Production Reality
Support workflows quietly improved.

Backup tooling became more resilient, with better error handling and clearer
failure behavior. Customer-facing support gained more reliable infrastructure
without depending on fragile manual processes.

This was not flashy -- but it reduced the blast radius when things go wrong.

And that matters more than dashboards.

= Security Stops Relying on Long-Lived Credentials
May also exposed a truth the platform could not ignore anymore: static AWS
credentials are a liability.

Vault and Sentinel backups were migrated away from IAM keys toward native EKS
IAM roles, reducing exposure and aligning access with runtime identity instead
of stored secrets.

This was an early move -- not the final one -- but it set the direction
clearly: credentials should expire, rotate, and scope themselves.

June would finish what May started.

= Cost Discipline: One Source of Truth for Secrets
Secrets sprawl creates cost sprawl.

Cluster credentials were unified under a single secrets management system,
removing duplication and reducing the number of places sensitive data lived.

This was one of those changes that does not announce itself -- but it tightens
everything around it.

= Kafka as a Declarative Platform Concern
Finally, May asked a forward-looking question: how do we let teams create Kafka
topics and schemas without turning messaging into a ticket-driven bottleneck?

Instead of scripts and manual steps, the answer leaned into Kubernetes-native,
declarative workflows -- embedding Kafka resources into the same Helm and GitOps
flows teams already used.

This was not about implementing everything immediately. It was about aligning
event infrastructure with the platform's operating model before scale made it
painful.

== What May Established
May did not optimize. It validated.

By the end of the month:

- real production workloads were live on the platform
- Kubernetes was trusted with critical systems
- legacy paths began closing
- security posture started shifting away from static secrets
- future infrastructure decisions were framed declaratively

This is where the platform stopped being an internal initiative and became
something the business actually ran on.

Everything that followed -- Kubernetes as default, security hardening, preview
environments, AI, cost control -- only mattered because May proved the platform
could carry weight.

And once that happened, there was no turning back.
