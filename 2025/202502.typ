#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When Kubernetes Stopped Being an Experiment],
  authors: (
    (
      name: "February 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "February",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Kubernetes",
    "MongoDB",
    "Redis",
    "Infisical",
    "Sentinel",
    "Vault",
    "CI/CD",
    "Secrets",
  ),
  doi: "10.0000/fortris.platform.2025.02",
  abstract: [
    February 2025 shifted Kubernetes from experiment to standard. Production-
    ready MongoDB and Redis charts landed, Infisical centralized secrets, Vault
    and Sentinel became Kubernetes-ready, and CI/CD gained full awareness of
    staging and production environments. Cleanup of legacy canary resources
    closed the loop, turning Kubernetes into the default path forward.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When Kubernetes Stopped Being an Experiment
January asked if Kubernetes could work here. February answered how.

This is the month where the platform stopped improvising and started
standardizing the hardest parts first: data, secrets, and delivery paths.

= Datastores Become Kubernetes-Native
Stateless services are easy. Databases decide whether a platform is serious.

February introduced production-ready Helm charts for MongoDB and Redis -- not
as one-off recipes, but as supported platform components with clear operating
models.

MongoDB gained:

- repeatable cluster deployments
- documented database lifecycle management
- a clear path for application teams to self-serve safely

Redis followed the same pattern, qualified for production use and aligned with
Kubernetes conventions instead of ad-hoc setups.

This mattered because it removed the most common excuse to stay off
Kubernetes: "We cannot move because of the data."

From February onward, that stopped being true.

= Secrets Become a Platform Concern
Security only works when it is boring.

With Infisical adopted as the central secret manager for Kubernetes, secrets
stopped living in scattered values files, environment variables, and one-off
configurations.

This was not just a tooling switch. It introduced:

- a single source of truth for secrets
- binary secret support (a long-standing blocker)
- clear ownership and access boundaries

Secrets stopped being copied. They started being managed.

This decision echoes through the rest of the year -- every security improvement
that follows depends on it.

= Sentinel Enters Kubernetes
Vault alone is not enough. Policy enforcement matters just as much.

February extended the Vault release charts to support Sentinel on Kubernetes,
completing the security control plane from a platform perspective.

The work was done. The system was ready. Go-live was scheduled.

This was an important pattern: the platform delivered capability before
pressure forced shortcuts.

= CI/CD Learns About Real Environments
Kubernetes adoption fails quickly if delivery pipelines lag behind.

February closed that gap.

CI/CD pipelines gained full awareness of staging and production Kubernetes
environments. Deployment flows were no longer experimental or special case.
They became documented, repeatable, and supported.

From this point on, deploying to Kubernetes was not a favor the platform did
for early adopters. It was the standard path.

= Cleaning Up Before Moving Faster
February also removed what no longer served a purpose.

Canary Vault resources -- once useful, now redundant -- were decommissioned.
Not abandoned. Not forgotten. Cleanly removed.

This mattered because it showed discipline. The platform was not just adding
capabilities. It was curating them.

== What February Changed
February did not generate excitement. It generated credibility.

By the end of the month:

- core datastores had Kubernetes-native support
- secrets were centralized and secured
- security enforcement could run on the platform
- CI/CD understood production Kubernetes
- experimental leftovers were cleaned up

This is the month where Kubernetes stopped being a side path and became the
road everything else would follow.
