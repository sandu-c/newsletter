#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Crossed the Point of No Return],
  authors: (
    (
      name: "June 2025",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "June",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Kubernetes",
    "Keycloak",
    "RDS",
    "Preview Environments",
    "CI/CD",
    "STS",
    "Security",
    "SDLC Tooling",
  ),
  doi: "10.0000/fortris.platform.2025.06",
  abstract: [
    June 2025 was the inflection point. Kubernetes became the default runtime,
    identity moved onto the platform, and managed databases reached production
    readiness for Kubernetes workloads. CI/CD responded to real-time change,
    STS replaced static keys for platform tooling, and major SDLC systems were
    upgraded without disruption. This is the month the platform became
    non-negotiable.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When the Platform Crossed the Point of No Return
Every transformation has a moment where going back stops being an option.

June was that moment.

This is when core systems moved into Kubernetes, security models were
modernized, and the platform stopped running experiments -- and started
running the company.

= Kubernetes Becomes the Default, Not the Alternative
By June, Kubernetes was no longer "where some things run." It became where
production runs.

Key systems crossed the boundary, including identity infrastructure. Keycloak
-- a cornerstone of authentication and authorization -- moved fully into
Kubernetes, removing one of the last major dependencies on legacy runtime
environments.

This was not symbolic. It was structural.

From this point on, Kubernetes was not a destination. It was the baseline.

= Managed Databases for Kubernetes Workloads (RDS Integration)
State is where platforms fail -- unless it is handled deliberately.

June completed the RDS support feature set for Kubernetes workloads, turning
managed databases into a first-class platform capability.

This was not just connectivity. It introduced:

- fine-grained user management with read/write controls
- connection limits to protect database stability
- password rotation without downtime
- Prometheus metrics for observability
- secure sidecar access for developers

Databases stopped being special snowflakes. They became operationally boring --
which is exactly what you want.

= Preview Environments Move Beyond the Frontend
Preview environments started expanding beyond UI-only use cases.

Backend services like TAPI gained preview support, proving that ephemeral
environments could handle real application flows -- not just static demos.

At the same time, cleanup and lifecycle management improved, setting the stage
for wider adoption without runaway resource usage.

This was the first signal that previews were becoming a platform primitive.

= CI/CD That Reacts to Reality
Pipelines learned to respond to change.

Merge request pipelines now cancel themselves when new commits arrive,
preventing wasted compute and misleading results. ArgoCD sync status reporting
improved, making deployment state clearer without leaving the pipeline context.

CI/CD stopped behaving like a queue. It started behaving like a conversation
with the code.

= Security Model Modernization: STS over Static Keys
Static IAM keys are convenient -- until they are not.

June marked the shift to STS assume-role strategies for platform tooling,
removing long-lived credentials from the equation.

Access became:

- temporary
- auditable
- scoped

The platform moved closer to zero-trust principles -- not in theory, but in
practice.

Where legacy tools could not yet follow, constraints were documented and
isolated, not ignored.

= Tooling Upgrades Without Drama
Major SDLC tools were upgraded in place -- GitLab, Nexus, Harbor, SonarQube --
without disruption.

This mattered more than it sounds. It meant:

- security patches landed on time
- new capabilities became available immediately
- technical debt did not quietly compound

The platform proved it could evolve its own foundations safely.

== What June Set in Motion
June was not about polish. It was about commitment.

By the end of the month:

- Kubernetes was production-critical
- identity lived on the platform
- stateful workloads had a supported model
- CI/CD responded intelligently to change
- security stopped relying on static secrets

This is the month where the platform stopped being optional.

Everything that followed -- previews, AI, cost optimization, multi-cloud --
only worked because June made the platform non-negotiable.

And from here, the pace only increased.
