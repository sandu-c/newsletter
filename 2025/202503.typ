#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Became Structurally Ready],
  authors: (
    (
      name: "March 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "March",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "StatefulSets",
    "Grafana",
    "Resource Limits",
    "CI/CD",
    "ArgoCD",
    "Vault Backups",
    "Java Runtime",
    "Logging",
  ),
  doi: "10.0000/fortris.platform.2025.03",
  abstract: [
    March 2025 gave the platform its structural shape: stateful workloads became
    first-class, monitoring centralized, resource limits enforced, and CI/CD
    pipelines hardened. Security backups matured, runtime support evolved, and
    log signals became operational inputs. This is where the platform became a
    stable foundation to build on.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When the Platform Became Structurally Ready
Before production wins, before migrations, before confidence -- a platform
needs the right shape.

March was about giving the platform that shape.

This is the month where the foundations stopped being implicit and became
explicit: state, limits, monitoring, and operational discipline all moved from
assumed to designed.

= Stateful Workloads Become First-Class Citizens
Until March, Kubernetes supported a lot -- but not everything that mattered.

StatefulSets changed that.

By adding StatefulSet support to the base application chart, the platform
unlocked an entire class of workloads that could not safely run before. This
was not a generic feature -- it was driven by real migrations waiting behind
it, including financial systems and order processing services.

This is where Kubernetes stopped being suitable only for stateless APIs and
became capable of running real systems with memory.

= Centralized Monitoring as a Platform Capability
Dashboards scattered across teams are not observability. They are archaeology.

March centralized Grafana dashboards into a single, version-controlled
repository owned by the platform. Monitoring stopped being something each team
curated independently and became something shared, reviewed, and evolved
together.

This mattered because it established a principle: visibility is a platform
responsibility, not an afterthought.

From here on, signals could be trusted -- and compared -- across services.

= Resource Limits That Protect Everyone
One noisy workload can ruin an entire cluster.

March introduced overridable resource quotas and limit ranges across all
namespaces. This was not about restriction -- it was about fairness and
predictability.

Teams gained clear boundaries. Clusters gained stability. Incidents caused by
accidental overconsumption quietly disappeared.

The platform learned how to say "this is enough" -- automatically.

= CI/CD That Fails Fast and Explains Itself
March hardened Kubernetes pipelines where it mattered most.

ArgoCD sync jobs were refactored to be easier to troubleshoot. Stuck
deployments were actively prevented by terminating pending syncs before new
ones started. Chart.lock files became mandatory, removing ambiguity from
dependency resolution.

Pipelines stopped hanging. Deployments stopped piling up. Failures became
understandable instead of mysterious.

This is where CI/CD stopped being tolerant of ambiguity.

= Vault Backup 2.0: Security as an Operational System
Security teams do not ask for features lightly.

When SecOps asked for stronger backup guarantees, the platform responded with a
unified, production-grade tool.

The new Vault backup solution introduced:

- consistent health checks and alerting
- support for additional secure transfer protocols
- multiple encryption signatures
- a single, maintainable codebase

Backups stopped being "something that runs" and became something you can trust
during an incident.

= Application Runtime Evolves with the Platform
The Java runtime was extended to support newer application definitions,
ensuring that modern Spring applications could integrate cleanly with platform
deployment standards.

This mattered because it aligned application evolution with platform evolution
-- instead of forcing teams to choose between the two.

= Logs Become Signals, Not Noise
March also laid the groundwork for proactive monitoring.

Log-based alerts were added to the base chart, allowing teams to surface
meaningful conditions directly from application behavior -- not just
infrastructure metrics.

This was an early but important shift: from reacting to outages to detecting
degradation.

== What March Enabled
March did not ship to production. It did something more important.

By the end of the month:

- stateful workloads were supported
- monitoring was centralized
- resource usage was controlled
- pipelines were deterministic
- security tooling was production-ready

This is the month where the platform stopped being a collection of
capabilities and became an environment you could safely build on.
