#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Platform Engineering Newsletter],
  authors: (
    (
      name: "December 2025",
      department: "Platform Engineering",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2025,
    month: "December",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Kubernetes Migration",
    "Argo Rollouts",
    "Progressive Delivery",
    "OpenTelemetry",
    "Tempo",
    "Distributed Tracing",
    "CI/CD",
    "GitLab Runners",
    "SDLC",
    "Staged Rollouts",
  ),
  doi: "10.0000/fortris.platform.2025.02",
  abstract: [
    December 2025 marks the shift from fast-but-fragile delivery to confident,
    observable shipping. This update captures the platform work that made that
    possible: production Kubernetes migrations, progressive delivery with canary
    rollouts and time-based traffic shifting, distributed tracing with
    OpenTelemetry and Tempo, dedicated CI/CD runners on Kubernetes, and staged
    rollouts for platform tooling. The result is a platform that reduces risk,
    shortens incidents, and makes speed sustainable.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

== December 2025 Update
There’s a moment every engineering organization hits where speed becomes
dangerous.

Not because teams move too fast — but because the system can’t tell you when
you’re wrong.

This month, Platform Engineering changed that system.

= Kubernetes Migration (Production Workloads)
Some systems don’t forgive mistakes. They demand consistency, predictability,
and fast recovery when things go wrong.

That’s why moving critical production workloads to Kubernetes mattered. Not as
a checkbox, but as a line in the sand: this is now how software runs here.

With this shift, applications stopped behaving differently depending on where
they ran. Scaling became automatic. Failures became isolated instead of
contagious. Operational work moved from manual intervention to platform
guarantees.

The platform didn’t just get more modern — it became repeatable.

= Canary Deployments with Argo Rollouts
Releases used to be an event. Now they’re a process.

By introducing canary deployments through Argo Rollouts, we changed the shape
of risk. New versions no longer appear everywhere at once. They arrive quietly,
serve a fraction of real traffic, and prove themselves before moving forward.

When something looks wrong, the system pauses — automatically. No emergency
calls. No rollbacks under pressure. Just controlled progression based on real
behavior.

This is how high-performing teams ship daily without drama.

= Progressive Traffic Shifting (Time-Based Rollouts)
Not every change deserves the same speed.

Some features move fast. Others need time to breathe.

Time-based rollouts gave teams that control. Traffic now increases in measured
steps, creating natural observation windows where behavior can be validated
instead of assumed.

The effect is subtle but powerful: releases feel calmer. Decisions are
informed. Engineers trust the platform to watch their back.

= Distributed Tracing with OpenTelemetry and Tempo
Most outages don’t fail loudly. They slow down. They cascade. They hide.

Distributed tracing changed that.

For the first time, requests can be followed across services, databases, and
external calls — end to end. No guesswork. No stitching logs together at 2 a.m.
The path is visible.

Latency has a location. Errors have a source. Conversations shift from “what
happened?” to “here’s exactly where it broke.”

That’s not observability as a dashboard.
That’s observability as understanding.

= CI/CD Execution on Kubernetes-Based GitLab Runners
Delivery speed is often lost long before production.

This year, CI/CD pipelines stopped competing for the same shared resources.
Dedicated Kubernetes-based runners, backed by purpose-built node pools, now
execute workloads according to their real needs.

Heavy jobs run where they belong. Small jobs finish fast. Pipelines behave
predictably.

The invisible tax of waiting — and retrying — quietly disappeared.

= SDLC Staged Rollouts for Platform Tooling
Platform tools are no longer treated as “internal utilities.” They are
production systems.

By introducing staged rollouts between platform environments, we applied the
same discipline to our own work that we expect from application teams.

Changes are tested, promoted, and observed. Stability compounds. Trust builds.

This is how a platform earns credibility — not through promises, but through
behavior over time.

= Spot Instances Were More Expensive Than On-Demand
A counterintuitive discovery: with AWS Savings Plans active, spot instances cost *more* than on-demand for the same instance type.

The numbers were clear — \$0.115/hr for spot versus \$0.095/hr for on-demand with Savings Plans applied. The platform had been paying a 17% premium for less stability.

#v(3mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let bar-h = 7
  let max-w = 45

  // Spot bar (full width = more expensive)
  rect((0, bar-h + 3), (max-w, 2 * bar-h + 3), fill: lightgray, stroke: none, radius: 2pt)
  content((max-w + 2, bar-h + 3 + bar-h / 2), anchor: "west", [#text(size: 5.5pt, weight: "bold", fill: gray)[Spot · \$0.115/hr]])

  // On-demand bar (shorter = cheaper)
  let od-w = max-w * 0.095 / 0.115
  rect((0, 0), (od-w, bar-h), fill: red, stroke: none, radius: 2pt)
  content((od-w + 2, bar-h / 2), anchor: "west", [#text(size: 5.5pt, weight: "bold", fill: red)[On-Demand · \$0.095/hr]])
})

#v(2mm)
#align(center)[
  #text(size: 6pt, style: "italic", fill: gray)[17% cheaper. More stable. Previous assumption reversed.]
]

#v(4mm)

Persistent workloads moved back to on-demand. Only short-lived jobs — CI builds, data pipelines — remain on spot where interruption is acceptable.

The platform reversed its own decision based on data. That takes more discipline than making the decision in the first place.

== The Shift You Can Feel
None of these changes announce themselves loudly.

But together, they change how engineering feels:

- Releases are calmer
- Incidents are shorter
- Debugging is factual, not emotional
- Speed no longer fights safety

The platform stopped being something teams work around.
It became something they work with.

This wasn’t about tools.
It was about control, confidence, and momentum.

And it set the tone for everything that followed.
