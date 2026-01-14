#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [When the Platform Started Working With Humans],
  authors: (
    (
      name: "July 2025",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "July",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Keycloak",
    "Kubernetes",
    "CI/CD",
    "Preview Environments",
    "ArgoCD",
    "SDLC",
    "TestRail",
    "AI",
  ),
  doi: "10.0000/fortris.platform.2025.07",
  abstract: [
    July 2025 turned platform reliability into human leverage. Identity routing
    scaled without manual ALB changes, Kubernetes deployments began explaining
    themselves, preview environments became sustainable collaboration tools,
    and SDLC ownership shifted onto the platform. AI moved from hype to utility
    with measurable help inside the delivery flow.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== When the Platform Started Working With Humans
By July, the platform was already reliable.

But reliability alone does not create leverage.

July was about removing friction at the exact points where humans interact with
systems: deployments, previews, authentication, feedback loops, and support
boundaries.

This is where engineering productivity stopped being theoretical and became
tangible.

= Keycloak Routing at Scale (ALB Capture Groups)
Growth exposes limits you did not know you had.

Keycloak realms were one of them.

Previously, every new realm required new ALB routes -- a design that quietly
capped how far identity could scale. July removed that ceiling by introducing
capture-group-based routing and explicitly blocking access to the master realm.

The result was deceptively simple:

- realms can grow without infrastructure changes
- routing complexity stopped scaling linearly
- security rules became explicit instead of implicit

This was not just a fix. It was future-proofing identity at platform level.

The same pattern was prepared for UI authentication flows -- ensuring
consistency across the stack.

= Kubernetes CI/CD: Making Deployments Understandable
Deployments used to succeed or fail -- often without telling you why.

That changed.

July dramatically improved the Kubernetes CI/CD experience:

- deployment notifications now appear automatically
- failures surface meaningful reasons directly in job logs
- ArgoCD state is no longer a black box

The platform stopped assuming everyone knew how to debug Kubernetes. Instead,
it started explaining itself.

= Preview Environments That Do Not Rot
Preview environments are only valuable if they disappear when no longer needed.

July introduced structure where there used to be chaos:

- consistent branch prefixes
- automatic namespace cleanup
- reduced Keycloak realm sprawl
- shared ALBs instead of per-preview overhead

This was not about adding previews -- it was about making them sustainable.

By tightening lifecycle management, preview environments became safe to scale,
not something teams had to babysit.

= Ephemeral UI Environments: Collaboration Without Meetings
This was one of the most human shifts of the year.

Frontend preview environments unlocked a new way of working:

- reviewers can see changes instantly
- QA can test before merge
- product owners can approve features without demos

Code stopped being something you described. It became something you shared.

This removed entire categories of meetings, screenshots, and screen
recordings -- replacing them with living, disposable environments.

For trunk-based development and continuous delivery, this is a force
multiplier.

= Decoupling Pipelines from Legacy Environments
Legacy environments do not just cost money. They distort pipelines.

July began the deliberate removal of STG dependencies from CI/CD flows,
simplifying pipelines and preparing the ground for cleaner environment
progression.

At the same time, Support gained full ownership of their own Vault instance --
connected to production, managed independently, and no longer coupled to
platform release cycles.

This was a boundary-setting moment. Ownership became clear. Responsibility
followed.

= Tooling Overhaul: Taking Control of the SDLC
TestRail was migrated off legacy hardware into the Platform staging cluster,
bringing a core SDLC tool under the same reliability and governance standards
as everything else.

This mattered because it sent a signal: If it is part of how we build software,
it belongs on the platform. No exceptions.

= AI Enters the SDLC (For Real)
July was not about AI hype. It was about measurement and usefulness.

The platform introduced:

- ways to measure AI-generated code quality
- a Claude-based GitLab bot that works inside merge requests
- early experiments in AI-assisted troubleshooting

AI was not positioned as a replacement for engineers. It was positioned
exactly where it belongs: as an assistant in the flow of work.

== What July Changed
July did not add the most infrastructure. It removed the most friction.

By the end of the month:

- identity could scale without rework
- deployments explained themselves
- previews became a collaboration tool, not a novelty
- ownership boundaries were clearer
- AI stopped being experimental and started being practical

This is the month where the platform stopped feeling like infrastructure and
started feeling like an operating system for engineering.

Everything that followed built on this shift.
