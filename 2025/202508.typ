#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Became a System, Not a Collection of Parts],
  authors: (
    (
      name: "August 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "August",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Kubernetes",
    "Helm",
    "Cost Ownership",
    "MongoDB Backups",
    "Terraform",
    "Service Accounts",
    "Supply Chain",
    "Staging Hygiene",
  ),
  doi: "10.0000/fortris.platform.2025.08",
  abstract: [
    August 2025 is where the platform moved from capable to coherent. Shared
    Kubernetes templates reduced fragmentation, ownership metadata made costs
    visible, MongoDB backups established production safety on Kubernetes, and
    Terraform delivery joined the main CI/CD path. Service-account auth replaced
    tokens, dependency risk was addressed after the Bitnami change, and staging
    cleanup reduced operational drag.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When the Platform Became a System, Not a Collection of Parts
By August, delivery was working.

But working is not the same as scaling.

The platform was growing -- more teams, more services, more infrastructure --
and that exposed a deeper question: Who owns what, how much does it cost, and
how do we evolve without breaking everything?

August was about answering those questions structurally.

= Unified Kubernetes Templates (Platform Library Helm Chart)
Kubernetes gives you freedom. Too much freedom, and you get fragmentation.

Different charts. Different conventions. Different assumptions -- all doing
roughly the same thing in slightly incompatible ways.

The release of a shared Platform Helm library changed that dynamic.

Instead of rewriting patterns over and over, teams now build on a common
foundation. Platform charts and third-party charts speak the same language.
Templates align. Behavior converges.

This was not about restriction. It was about reducing entropy.

When templates are shared, improvements propagate automatically. Consistency
stops being enforced -- it emerges.

= Cost and Ownership as First-Class Metadata
Infrastructure costs do not spiral because people are careless. They spiral
because nobody can see responsibility clearly.

August made ownership explicit.

Workloads now carry structured metadata describing:

- team and department
- product and feature context
- environment and criticality

Not in spreadsheets. In Kubernetes itself.

This unlocked real cost visibility through infrastructure dashboards -- tying
spend back to teams and products without manual reconciliation.

The platform stopped asking "who is using this?" It started answering it
automatically.

= MongoDB on Kubernetes: Backups as a Non-Negotiable
Before you migrate data, you protect it.

Backup support for MongoDB running on Kubernetes was added, enabling exports to
centralized, durable storage. The mechanics were handled at platform level, so
application teams did not need to invent their own safety nets.

This was not glamorous work. But it drew a clear line: stateful workloads on
Kubernetes are production-grade or they do not exist.

This decision made later migration efforts possible -- and safe.

= Surviving the Bitnami Shock
External dependencies fail in one of two ways: loudly or suddenly.

When Bitnami repositories moved behind closed access, the platform absorbed the
blast radius.

Mitigations were put in place quickly to keep existing workloads running. More
importantly, a longer-term plan was set in motion: replacing external images
and charts with platform-backed equivalents.

This was a turning point. The platform stopped assuming upstream availability
and started planning for independence.

= Cleaning the Platform Staging Environment
Maturity shows up in maintenance.

August included deliberate cleanup of the Platform staging cluster --
consolidating charts, removing redundant components, and simplifying the layout
without requiring changes from development teams.

Nothing broke. Nothing noisy happened. Things just became cleaner.

That is the sign of a platform that is under control.

= Terraform as a First-Class Delivery Path
Infrastructure delivery stopped being a special case.

Terraform pipelines were integrated into the same CI/CD machinery as
application deployments. Environment progression, notifications, approvals --
all followed the same rules.

This mattered more than it looks.

It meant:

- infrastructure changes became reviewable like code
- deployments became observable like applications
- product teams could ship infra and app changes together, safely

Infrastructure stopped living next to the platform. It became part of it.

= Secure Cloud Authentication (Service Accounts over Tokens)
Access tokens do not scale. They leak, expire, and become liabilities.

August replaced them with service-account-based authentication for cloud
operations, including new runner configurations dedicated to Terraform
workloads.

Security was not bolted on. It was embedded into the execution model.

Pipelines now authenticate the way production systems should -- explicitly,
auditable, and scoped.

== What August Locked In
August did not move the fastest. It moved the deepest.

By the end of the month:

- Kubernetes had shared foundations
- cost and ownership were visible by design
- data had safety guarantees
- infrastructure delivery matched application delivery
- external dependency risk was acknowledged and addressed

This is the kind of work that does not show up in demos -- but without it,
everything that follows collapses under its own weight.

August is where the platform stopped being fragile under growth and started
being intentionally built to last.

And with that foundation in place, the platform was ready to evolve how teams
actually work.
