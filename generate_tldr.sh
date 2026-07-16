#!/bin/sh
# ============================================================================
# TLDR Generator — Converts _tldr.md to styled HTML dashboard
# Usage: ./generate_tldr.sh 2026/202606_tldr.md
# Output: 2026/202606_tldr.html
# ============================================================================

set -e

INPUT="$1"
if [ -z "$INPUT" ] || [ ! -f "$INPUT" ]; then
  echo "Usage: ./generate_tldr.sh <path-to-tldr.md>"
  exit 1
fi

OUTPUT=$(echo "$INPUT" | sed 's/\.md$/.html/')
TITLE=$(head -1 "$INPUT" | sed 's/^# //')

# Start HTML
cat > "$OUTPUT" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Platform Highlights</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lucide-static@latest/font/lucide.min.css">
  <script src="https://unpkg.com/lucide@latest"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Manrope:wght@300;500;700;800&display=swap');

    :root {
      --gray: #2f3849;
      --red: #F07C70;
      --dark: #1a1f2b;
      --card: #222832;
      --lightgray: #C9CED8;
      --green: #4ade80;
      --yellow: #fbbf24;
      --blue: #60a5fa;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Manrope', sans-serif;
      background: var(--dark);
      color: #fff;
      min-height: 100vh;
      padding: 2rem;
    }

    .container { max-width: 440px; margin: 0 auto; }

    .header {
      text-align: center;
      margin-bottom: 2rem;
      padding-bottom: 1.5rem;
      border-bottom: 1px solid rgba(255,255,255,0.06);
    }

    .header .month {
      font-size: 0.7rem; font-weight: 700; letter-spacing: 3px;
      text-transform: uppercase; color: var(--red); margin-bottom: 0.3rem;
    }

    .header h1 { font-size: 1.6rem; font-weight: 800; color: #fff; }

    .header .sub {
      font-size: 0.75rem; color: var(--lightgray); margin-top: 0.4rem; opacity: 0.7;
    }

    .card {
      background: var(--card); border-radius: 16px; padding: 1.5rem;
      margin-bottom: 1rem; position: relative; overflow: hidden;
      transition: transform 0.15s ease;
    }

    .card:hover { transform: translateY(-2px); }

    .card-top {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 0.8rem;
    }

    .card-icon {
      width: 44px; height: 44px; border-radius: 50%; background: var(--gray);
      display: flex; align-items: center; justify-content: center;
    }

    .card-icon i { width: 22px; height: 22px; color: #fff; stroke: #fff; }

    .card-badge {
      font-size: 0.6rem; font-weight: 700; letter-spacing: 1px;
      text-transform: uppercase; padding: 0.25rem 0.6rem; border-radius: 20px;
    }

    .badge-done { background: rgba(74,222,128,0.15); color: var(--green); }
    .badge-advancing { background: rgba(251,191,36,0.15); color: var(--yellow); }
    .badge-foundation { background: rgba(96,165,250,0.15); color: var(--blue); }
    .badge-starting { background: rgba(201,206,216,0.1); color: var(--lightgray); }

    .card h3 { font-size: 1rem; font-weight: 700; color: #fff; margin-bottom: 0.3rem; }
    .card p { font-size: 0.78rem; color: var(--lightgray); line-height: 1.4; opacity: 0.8; }

    .card-number {
      font-size: 2.5rem; font-weight: 800; color: var(--red); line-height: 1; margin-bottom: 0.2rem;
    }

    .card-number-label { font-size: 0.75rem; color: var(--lightgray); opacity: 0.7; }

    .progress-bar {
      height: 6px; background: rgba(255,255,255,0.08);
      border-radius: 3px; margin-top: 1rem; overflow: hidden;
    }

    .progress-bar .fill { height: 100%; border-radius: 3px; }

    .fill-green { background: var(--green); }
    .fill-yellow { background: var(--yellow); }
    .fill-blue { background: var(--blue); }
    .fill-red { background: var(--red); }

    .status-row { display: flex; gap: 0.8rem; margin-top: 0.8rem; flex-wrap: wrap; }

    .status-item {
      display: flex; align-items: center; gap: 0.4rem;
      font-size: 0.72rem; color: var(--lightgray);
    }

    .status-dot { width: 8px; height: 8px; border-radius: 50%; }
    .dot-green { background: var(--green); }
    .dot-yellow { background: var(--yellow); }
    .dot-gray { background: #555; }

    .footer {
      text-align: center; margin-top: 2rem; padding-top: 1rem;
      border-top: 1px solid rgba(255,255,255,0.06);
      font-size: 0.65rem; color: #555;
    }
  </style>
</head>
<body>
<div class="container">
HEADER

# Write header
cat >> "$OUTPUT" << EOF
  <div class="header">
    <div class="month">${TITLE}</div>
    <h1>Platform Highlights</h1>
    <div class="sub">At a glance — 30 seconds to catch up</div>
  </div>
EOF

# Parse markdown and generate cards
current_title=""
current_icon=""
current_status=""
current_display=""
current_number=""
current_description=""
current_progress=""
current_dots=""

flush_card() {
  if [ -z "$current_title" ]; then return; fi

  # Status badge
  case "$current_status" in
    done) badge_class="badge-done"; badge_text="Done" ;;
    advancing) badge_class="badge-advancing"; badge_text="Advancing" ;;
    foundation) badge_class="badge-foundation"; badge_text="Foundation" ;;
    starting) badge_class="badge-starting"; badge_text="Starting" ;;
    *) badge_class="badge-done"; badge_text="Done" ;;
  esac

  # Progress bar color
  case "$current_status" in
    done) fill_class="fill-green" ;;
    advancing) fill_class="fill-yellow" ;;
    foundation) fill_class="fill-blue" ;;
    starting) fill_class="fill-red" ;;
    *) fill_class="fill-green" ;;
  esac

  # Open card
  cat >> "$OUTPUT" << EOF
  <div class="card">
    <div class="card-top">
      <div class="card-icon"><i data-lucide="${current_icon}"></i></div>
      <span class="card-badge ${badge_class}">${badge_text}</span>
    </div>
EOF

  # Display type
  case "$current_display" in
    number)
      cat >> "$OUTPUT" << EOF
    <div class="card-number">${current_number}</div>
    <div class="card-number-label">${current_description}</div>
    <div class="progress-bar"><div class="fill fill-green" style="width: 100%"></div></div>
EOF
      ;;
    progress)
      cat >> "$OUTPUT" << EOF
    <h3>${current_title}</h3>
    <p>${current_description}</p>
    <div class="progress-bar"><div class="fill ${fill_class}" style="width: ${current_progress}%"></div></div>
EOF
      # Add dots if defined
      if [ -n "$current_dots" ]; then
        echo '    <div class="status-row">' >> "$OUTPUT"
        IFS=','
        for dot in $current_dots; do
          dot_name=$(echo "$dot" | sed 's/=.*//' | sed 's/^ *//')
          dot_color=$(echo "$dot" | sed 's/.*=//' | sed 's/ //g')
          echo "      <div class=\"status-item\"><span class=\"status-dot dot-${dot_color}\"></span>${dot_name}</div>" >> "$OUTPUT"
        done
        unset IFS
        echo '    </div>' >> "$OUTPUT"
      fi
      ;;
    dots)
      cat >> "$OUTPUT" << EOF
    <h3>${current_title}</h3>
    <p>${current_description}</p>
EOF
      if [ -n "$current_dots" ]; then
        echo '    <div class="status-row">' >> "$OUTPUT"
        IFS=','
        for dot in $current_dots; do
          dot_name=$(echo "$dot" | sed 's/=.*//' | sed 's/^ *//')
          dot_color=$(echo "$dot" | sed 's/.*=//' | sed 's/ //g')
          echo "      <div class=\"status-item\"><span class=\"status-dot dot-${dot_color}\"></span>${dot_name}</div>" >> "$OUTPUT"
        done
        unset IFS
        echo '    </div>' >> "$OUTPUT"
      fi
      ;;
    bullets)
      cat >> "$OUTPUT" << EOF
    <h3>${current_title}</h3>
    <p>${current_description}</p>
EOF
      ;;
  esac

  # Close card
  echo '  </div>' >> "$OUTPUT"

  # Reset
  current_title=""
  current_icon=""
  current_status=""
  current_display=""
  current_number=""
  current_description=""
  current_progress=""
  current_dots=""
}

# Read file line by line
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    "## "*)
      flush_card
      current_title=$(echo "$line" | sed 's/^## //')
      ;;
    "- icon: "*)
      current_icon=$(echo "$line" | sed 's/- icon: //')
      ;;
    "- status: "*)
      current_status=$(echo "$line" | sed 's/- status: //')
      ;;
    "- display: "*)
      current_display=$(echo "$line" | sed 's/- display: //')
      ;;
    "- number: "*)
      current_number=$(echo "$line" | sed 's/- number: //')
      ;;
    "- description: "*)
      current_description=$(echo "$line" | sed 's/- description: //')
      ;;
    "- progress: "*)
      current_progress=$(echo "$line" | sed 's/- progress: //')
      ;;
    "- dots: "*)
      current_dots=$(echo "$line" | sed 's/- dots: //')
      ;;
  esac
done < "$INPUT"

# Flush last card
flush_card

# Close HTML
cat >> "$OUTPUT" << 'FOOTER'
  <div class="footer">
    Platform Engineering · Fortris<br>
    Full article available at newsletter portal
  </div>
</div>
<script>lucide.createIcons();</script>
</body>
</html>
FOOTER

echo "✓ Generated: ${OUTPUT}"
