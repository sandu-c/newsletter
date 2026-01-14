#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Where the Direction Was Set],
  authors: (
    (
      name: "January 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "January",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Kubernetes",
    "MongoDB",
    "Infisical",
    "Sentinel",
    "Security",
    "CI/CD",
    "Reliability",
  ),
  doi: "10.0000/fortris.platform.2025.01",
  abstract: [
    January 2025 set the direction. Kubernetes moved from possibility to plan
    as MongoDB control shifted into the cluster, real services ran in LDT
    environments, Infisical centralized secrets, and Sentinel entered
    production Kubernetes. CI/CD reliability improved while legacy paths were
    removed. The platform chose its path and aligned around it.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== Where the Direction Was Set
Every transformation has a moment where a decision quietly changes the future.

January was that moment.

This is where the platform stopped asking whether Kubernetes would be the
future -- and started acting as if it already was.

= MongoDB Control Moves Into Kubernetes
Kubernetes adoption does not start with stateless services. It starts when
teams trust it with data.

January migrated the functionality of the Swarm MongoDB operator into
Kubernetes, giving developers direct, supported control over MongoDB users and
databases inside the cluster.

This was not about moving databases yet. It was about moving authority.

From this point on:

- MongoDB lifecycle actions were Kubernetes-native
- developers did not need bespoke operational help
- data stopped being the blocker to adoption

It was the first signal that Kubernetes was not a sandbox anymore.

= Real Services, Real Environments
Services were pushed to run in the LDT Kubernetes environment -- not as
experiments, but as part of real delivery flows.

For the first time, teams could see:

- what was running
- where it was running
- and in what state

The platform introduced clarity early, making visibility a default instead of
something added later under pressure.

= Secrets Stop Living in Environment Variables
January also drew a hard line on security posture.

Infisical was adopted as the central secret manager for Kubernetes. Secrets
stopped being scattered across environment variables, files, and pipeline
configs.

Even before full binary support arrived, the direction was clear: secrets
belong to the platform, not to individual deployments.

This single decision underpins almost every security improvement that follows
later in the year.

= Sentinel Enters Production Kubernetes
Security enforcement did not wait.

The Sentinel release charts were extended to a production Kubernetes
environment, proving that policy controls could live where workloads live --
not alongside them.

This closed a critical loop early: Kubernetes adoption without security would
have been a dead end.

= CI/CD Reliability Over Novelty
While Kubernetes work progressed, CI/CD reliability was quietly reinforced.

The CI reports system was replaced with a more robust, platform-managed
solution -- removing a brittle dependency and improving confidence in delivery
feedback.

At the same time, obsolete environments were deliberately removed from
pipelines. Trinity Vault support was dropped, not because it was broken, but
because it no longer belonged.

This was the first sign of a pattern that repeats all year: if it is not part
of the future, it does not stay.

== What January Established
January did not deliver outcomes. It delivered alignment.

By the end of the month:

- Kubernetes was the clear direction
- data management was no longer an obstacle
- secrets had a single home
- security controls ran on the platform
- CI/CD favored reliability over legacy

Nothing here was accidental.

January is where the platform chose its path -- and every month that followed
simply made that choice irreversible.
