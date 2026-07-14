---
name: newsletter-writer
description: Write Fortris platform engineering newsletter articles. Transforms raw engineering highlights into compelling, tech-credible narratives formatted as Typst (.typ) files ready for PDF compilation and newsletter publishing. Use when creating new monthly articles, editing existing ones, or when given raw bullet points of engineering work to turn into a newsletter chapter.
---

# Fortris Newsletter Writer

You write platform engineering newsletter articles for Fortris.

## Writing Style & Rules

The complete writing prompt is defined in `prompt.md` in this skill directory (.kiro/skills/newsletter-writer/prompt.md). **Read that file before writing any article content.** It contains all narrative rules, style constraints, psychological techniques, and quality tests that must be followed exactly.

## Project Structure

```
fotris-template/
├── prompt.md          ← WRITING RULES (read this first!)
├── 2025/              ← Year directories with .typ articles
│   ├── 2025.typ       ← Yearly summary (featured in index)
│   ├── 202501.typ     ← Monthly chapters
│   └── ...
├── 2026/              ← New year directories as needed
├── graceful-genetics/ ← Typst template (do not modify)
├── banners/           ← Section banners
├── logos/             ← Fortris logos
├── team/              ← Team photos
├── build.sh           ← Compiles PDFs + generates newsletter index
├── viewer.html        ← PDF viewer page
└── dist/              ← Generated output (gitignored)
```

## Important Rules

1. **Never reference Jira ticket IDs** (FENG-186, PLAT-2470, etc.) in article text. Readers have no context for these. Describe the work, not the ticket.

2. **Article titles must be creative and non-repetitive.**
   - Before choosing a title, check all existing `.typ` files in all year directories to see what patterns have been used
   - Do NOT repeat "When..." structures — the 2025 monthly articles already overused this pattern
   - Titles should be almost click-bait: intriguing, specific, and make the reader curious
   - Good examples: "The Migration That Did Not Break Anything", "Secrets Stopped Costing Money", "75% and Counting", "Zero Downtime, Twenty Databases"
   - Bad examples: "When the Platform Did X", "When Data Started Moving", "When Systems Changed" (repetitive, boring)
   - The title should hint at the outcome or tension, not describe the category of work
   - Be smart, catchy, and specific — make people want to click

3. **Write for readers without internal context** — assume the reader knows nothing about internal project structure, team names, or ticket systems. Describe what changed and why it matters.

1. Read `prompt.md` for writing rules
2. Create a `.typ` file in the appropriate year directory (e.g. `2026/202607.typ`)
3. Use the Typst template structure below
4. Run `./build.sh all` to compile and preview

## Typst File Template

Every article must follow this structure:

```typ
#import "graceful-genetics/src/lib.typ" as graceful-genetics

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [CHAPTER TITLE HERE — NOT THE MONTH NAME],
  authors: (
    (
      name: "Month Year",
      department: "Infrastructure and Reliability",
      institution: "Fortris",
      city: "Remote",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "July",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    // Add relevant technical keywords
  ),
  doi: "10.0000/fortris.platform.YYYY.MM",
  abstract: [
    2-3 sentence summary of what this month delivered and why it matters.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

// Article content starts here — use = for H1 and == for H2
```

## Workflow

### Research Phase (before writing)

When given Jira tickets or epics as source material:

1. **Follow each epic/ticket in Jira** — read the description, comments, and linked issues
2. **Follow subtasks** — understand what was actually done, not just what was planned
3. **Read comments** — they often contain the real technical decisions, blockers, and context
4. **Follow links** — issue links, blockers, related tasks reveal the dependency graph
5. **Follow GitLab links** — merge requests, pipelines, and code changes show the actual implementation
6. **Infer technical details** — use your engineering knowledge to understand what the work implies architecturally (e.g. a MongoDB migration implies StatefulSets, PVCs, operator patterns, data sync strategies)
7. **Search online if needed** — for context on tools, patterns, or industry practices referenced

The goal is to understand:
- What was the *before* state (the problem, the risk, the technical debt)
- What was the *after* state (what changed in the system)
- Why it matters (reduced risk, eliminated toil, enabled future work)
- What's honest about the current state (done, in-progress, experimental)

### Writing Phase

1. User provides raw engineering highlights (bullet points, notes, Jira tickets, etc.)
2. Read `prompt.md` for the narrative rules
3. Transform highlights into a narrative following all rules in `prompt.md`
4. Include graphics where they aid comprehension (bar charts, diagrams, architecture illustrations using cetz or Typst native drawing)
5. Output as a complete `.typ` file using the template above
6. User runs `./build.sh all` to compile PDF and update newsletter index

## Build Commands

```bash
./build.sh all         # Build all articles + regenerate index
./build.sh 202607      # Build single article (finds it in any year dir)
open dist/index.html   # Preview newsletter
```

