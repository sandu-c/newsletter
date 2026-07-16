#!/bin/sh
# ============================================================================
# Fortris Newsletter Builder
#
# Compiles .typ files to PDF and generates the newsletter index.
#
# Usage:
#   ./build.sh              → build all articles
#   ./build.sh 202507       → build only this one (+ regenerate index)
#   ./build.sh --changed    → build only git-changed .typ files (for CI)
#
# Output: dist/
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

DIST="dist"
PDF_DIR="$DIST/pdfs"
IMG_DIR="$DIST/images/logos"

mkdir -p "$PDF_DIR" "$IMG_DIR"

# Ensure symlinks for all year directories
for year_dir in 20*/; do
  [ -d "$year_dir" ] || continue
  ln -sf ../graceful-genetics "${year_dir}graceful-genetics" 2>/dev/null || true
  ln -sf ../banners "${year_dir}banners" 2>/dev/null || true
  ln -sf ../logos "${year_dir}logos" 2>/dev/null || true
  ln -sf ../fonts "${year_dir}fonts" 2>/dev/null || true
  ln -sf ../team "${year_dir}team" 2>/dev/null || true
  ln -sf ../team/platform/platform.jpg "${year_dir}platform.jpg" 2>/dev/null || true
done

# Copy logos to dist
cp logos/*.png "$IMG_DIR/" 2>/dev/null || true

# ============================================================================
# Determine which files to build
# ============================================================================
FILES_TO_BUILD=""

case "${1:-all}" in
  --changed)
    # Only files changed in the last commit (for CI)
    CHANGED=$(git diff --name-only HEAD~1 HEAD -- '20*/*.typ' 2>/dev/null || echo "")
    if [ -z "$CHANGED" ]; then
      echo "No .typ files changed in last commit."
    else
      FILES_TO_BUILD="$CHANGED"
    fi
    ;;
  all)
    for f in 20*/*.typ; do
      [ -f "$f" ] && FILES_TO_BUILD="$FILES_TO_BUILD $f"
    done
    ;;
  *)
    # Try: exact path, then search in any year dir
    if [ -f "$1" ]; then
      FILES_TO_BUILD="$1"
    else
      FOUND=$(find 20*/ -name "${1}.typ" 2>/dev/null | head -1)
      if [ -n "$FOUND" ]; then
        FILES_TO_BUILD="$FOUND"
      else
        echo "✗ Not found: $1"
        exit 1
      fi
    fi
    ;;
esac

# ============================================================================
# Compile PDFs
# ============================================================================
echo "═══ Building PDFs ═══"
for f in $FILES_TO_BUILD; do
  BASENAME=$(basename "$f" .typ)
  printf "  → %s " "$BASENAME"
  if typst compile --root . "$f" "$PDF_DIR/${BASENAME}.pdf" 2>/dev/null; then
    echo "✓"
  else
    echo "✗ (failed)"
  fi
done

echo ""

# ============================================================================
# Generate languages.json manifest
# ============================================================================
echo "  → generating languages.json"
echo "{" > "$DIST/languages.json"
FIRST_LANG="true"
for pdf in $PDF_DIR/*.pdf; do
  BASENAME=$(basename "$pdf" .pdf)
  # Skip _es variants themselves
  case "$BASENAME" in *_es) continue ;; esac
  # Check if _es version exists
  if [ -f "$PDF_DIR/${BASENAME}_es.pdf" ]; then
    LANGS="[\"en\",\"es\"]"
  else
    LANGS="[\"en\"]"
  fi
  if [ "$FIRST_LANG" = "true" ]; then
    FIRST_LANG="false"
  else
    echo "," >> "$DIST/languages.json"
  fi
  printf "  \"%s\": %s" "$BASENAME" "$LANGS" >> "$DIST/languages.json"
done
echo "" >> "$DIST/languages.json"
echo "}" >> "$DIST/languages.json"
echo "  ✓ languages.json generated"

echo ""

# ============================================================================
# Generate index.html from all .typ files
# ============================================================================
echo "═══ Generating index ═══"

# Parse metadata from all .typ files, sorted newest first
generate_cards() {
  local is_first_month="true"

  # Process year directories in reverse order (2026, 2025, ...)
  for year_dir in $(ls -rd 20*/ 2>/dev/null); do
    local year_name="${year_dir%/}"

    # Year label
    echo "    <div class=\"year-label\">${year_name}</div>"

    # Coming next placeholder (only before the first year's first month)
    if [ "$is_first_month" = "true" ]; then
      # Determine next month name
      LATEST_FILE=$(ls -r ${year_dir}[0-9][0-9][0-9][0-9][0-9][0-9].typ 2>/dev/null | head -1)
      if [ -n "$LATEST_FILE" ]; then
        LATEST_BASENAME=$(basename "$LATEST_FILE" .typ)
        LATEST_MONTH_NUM=$(echo "$LATEST_BASENAME" | cut -c5-6)
        NEXT_MONTH_NUM=$(printf "%02d" $((${LATEST_MONTH_NUM#0} + 1)))
        NEXT_YEAR=$(echo "$LATEST_BASENAME" | cut -c1-4)
        case "$NEXT_MONTH_NUM" in
          01) NEXT_MONTH="January" ;; 02) NEXT_MONTH="February" ;; 03) NEXT_MONTH="March" ;;
          04) NEXT_MONTH="April" ;; 05) NEXT_MONTH="May" ;; 06) NEXT_MONTH="June" ;;
          07) NEXT_MONTH="July" ;; 08) NEXT_MONTH="August" ;; 09) NEXT_MONTH="September" ;;
          10) NEXT_MONTH="October" ;; 11) NEXT_MONTH="November" ;; 12) NEXT_MONTH="December" ;;
          13) NEXT_MONTH="January"; NEXT_YEAR=$((NEXT_YEAR + 1)) ;;
          *) NEXT_MONTH="Next" ;;
        esac
        cat <<NEXTCARD

    <div class="article-card coming-next">
      <div class="card-date"><span class="coming-next-badge">Baking</span></div>
      <div class="card-title">${NEXT_MONTH} ${NEXT_YEAR}</div>
      <div class="card-abstract"><span class="loading-dots">🔥 Baking at 200°C. Still in the oven</span></div>
    </div>
NEXTCARD
      fi
    fi

    # Yearly summary first (featured) — e.g. 2025.typ
    for f in ${year_dir}[0-9][0-9][0-9][0-9].typ; do
      [ -f "$f" ] || continue
      BASENAME=$(basename "$f" .typ)
      [ -f "$PDF_DIR/${BASENAME}.pdf" ] || continue
      emit_card "$f" "$BASENAME" "featured" ""
    done

    # Monthly files in reverse order (202512, 202511, ...)
    for f in $(ls -r ${year_dir}[0-9][0-9][0-9][0-9][0-9][0-9].typ 2>/dev/null); do
      BASENAME=$(basename "$f" .typ)
      [ -f "$PDF_DIR/${BASENAME}.pdf" ] || continue
      if [ "$is_first_month" = "true" ]; then
        emit_card "$f" "$BASENAME" "" "latest"
        is_first_month="false"
      else
        emit_card "$f" "$BASENAME" "" ""
      fi
    done
  done
}

emit_card() {
  local f="$1"
  local BASENAME="$2"
  local FEATURED="$3"
  local BADGE="$4"

  TITLE=$(grep -m1 'title:' "$f" | sed 's/.*title: \[//;s/\],.*//')
  ABSTRACT=$(sed -n '/abstract: \[/,/\]/p' "$f" | sed '1s/.*abstract: \[//;$s/\].*//' | tr '\n' ' ' | sed 's/  */ /g' | head -c 300)

  YEAR=$(echo "$BASENAME" | cut -c1-4)
  if [ ${#BASENAME} -eq 4 ]; then
    DATE_LABEL="${YEAR} Annual Report"
    FEATURED="featured"
  else
    MONTH_NUM=$(echo "$BASENAME" | cut -c5-6)
    case "$MONTH_NUM" in
      01) MONTH="January" ;; 02) MONTH="February" ;; 03) MONTH="March" ;;
      04) MONTH="April" ;; 05) MONTH="May" ;; 06) MONTH="June" ;;
      07) MONTH="July" ;; 08) MONTH="August" ;; 09) MONTH="September" ;;
      10) MONTH="October" ;; 11) MONTH="November" ;; 12) MONTH="December" ;;
      *) MONTH="Unknown" ;;
    esac
    DATE_LABEL="${MONTH} ${YEAR}"
  fi

  BADGE_HTML=""
  LATEST_CLASS=""
  if [ "$BADGE" = "latest" ]; then
    BADGE_HTML="<span class=\"badge-latest\">Latest</span>"
    LATEST_CLASS=" latest"
  fi

  # Check for translations
  LANG_PILLS="<span class=\"lang-pill\">EN</span>"
  ES_FILE=$(echo "$f" | sed 's/\.typ$/_es.typ/')
  if [ -f "$ES_FILE" ]; then
    LANG_PILLS="<span class=\"lang-pill\">EN</span><span class=\"lang-pill available\">ES</span>"
  fi

  # Check for TLDR
  TLDR_FILE=$(echo "$f" | sed 's/\.typ$/_tldr.md/')
  CARD_CLICK=""
  if [ -f "$TLDR_FILE" ]; then
    CARD_CLICK="onclick=\"event.preventDefault(); openTldr('${BASENAME}')\""
  fi

  cat <<CARD

    <a href="viewer.html?pdf=pdfs/${BASENAME}.pdf" class="article-card ${FEATURED}${LATEST_CLASS}" ${CARD_CLICK}>
      <div class="card-date">${DATE_LABEL}${BADGE_HTML}</div>
      <div class="card-title">${TITLE}</div>
      <div class="card-abstract">${ABSTRACT}</div>
      <span class="card-cta card-cta-article" onclick="event.stopPropagation(); window.location.href='viewer.html?pdf=pdfs/${BASENAME}.pdf'">Read full article →</span>
      <div class="card-langs">${LANG_PILLS}</div>
    </a>
CARD
}

CARDS=$(generate_cards)

cat > "$DIST/index.html" <<'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Fortris Platform Engineering — Newsletter</title>
  <style>
    @font-face {
      font-family: 'Manrope';
      src: url('https://fonts.gstatic.com/s/manrope/v15/xn7_YHE41ni1AdIRqAuZuw1Bx9mbZk79FN_C-bg.woff2') format('woff2');
      font-weight: 200 800;
      font-display: swap;
    }

    :root {
      --gray: #2f3849;
      --red: #F07C70;
      --white: #F8F7F8;
      --lightgray: #C9CED8;
      --dark: #1a1f2b;
      --card-bg: #ffffff;
      --font: 'Manrope', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: var(--font);
      background: var(--dark);
      color: var(--white);
      min-height: 100vh;
      line-height: 1.5;
      position: relative;
    }

    #particles-canvas {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: 0;
      pointer-events: none;
    }

    .site-header, .container, .site-footer {
      position: relative;
      z-index: 1;
    }

    .site-header {
      background: var(--gray);
      border-bottom: 3px solid var(--red);
      padding: 2rem 2rem;
      text-align: center;
    }

    .site-header img { height: 28px; margin-bottom: 1rem; }

    .site-header h1 {
      font-size: 1.4rem;
      font-weight: 300;
      color: var(--white);
      letter-spacing: 0.5px;
    }

    .site-header h1 strong { font-weight: 700; color: var(--red); }

    .site-header .subtitle {
      font-size: 0.8rem;
      color: var(--lightgray);
      margin-top: 0.4rem;
      letter-spacing: 2px;
      text-transform: uppercase;
    }

    .reader-guide {
      margin-top: 1rem;
      padding-top: 0.8rem;
      border-top: 1px solid rgba(255,255,255,0.08);
      font-size: 0.7rem;
      color: var(--lightgray);
      opacity: 0.8;
    }

    .reader-guide .guide-item {
      display: inline;
    }

    .reader-guide .guide-separator {
      margin: 0 0.5rem;
      opacity: 0.4;
    }

    @media (max-width: 600px) {
      .reader-guide .guide-item { display: block; margin-bottom: 0.3rem; }
      .reader-guide .guide-separator { display: none; }
    }

    .container {
      max-width: 900px;
      margin: 0 auto;
      padding: 3rem 1.5rem;
    }

    .year-label {
      font-size: 0.7rem;
      font-weight: 700;
      color: var(--red);
      letter-spacing: 3px;
      text-transform: uppercase;
      margin-bottom: 1.5rem;
      padding-left: 4px;
    }

    .article-card {
      background: var(--card-bg);
      border-radius: 12px;
      padding: 2rem 2.2rem;
      margin-bottom: 1.2rem;
      cursor: pointer;
      transition: transform 0.15s ease, box-shadow 0.15s ease;
      text-decoration: none;
      display: block;
      position: relative;
      overflow: hidden;
    }

    .article-card::before {
      content: '';
      position: absolute;
      left: 0; top: 0; bottom: 0;
      width: 4px;
      background: var(--red);
      border-radius: 12px 0 0 12px;
      opacity: 0;
      transition: opacity 0.15s ease;
    }

    .article-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(240, 124, 112, 0.15);
    }

    .article-card:hover::before { opacity: 1; }

    .article-card .card-date {
      font-size: 0.7rem; font-weight: 600; color: var(--red);
      letter-spacing: 1px; text-transform: uppercase; margin-bottom: 0.5rem;
    }

    .article-card .card-title {
      font-size: 1.2rem; font-weight: 700; color: var(--gray);
      margin-bottom: 0.6rem; line-height: 1.3;
    }

    .article-card .card-abstract {
      font-size: 0.85rem; color: #555; line-height: 1.6;
    }

    .article-card .card-cta {
      display: inline-block; margin-top: 1rem;
      font-size: 0.75rem; font-weight: 700; color: var(--red);
      letter-spacing: 0.5px; text-transform: uppercase;
    }

    .article-card .card-cta-article {
      position: relative;
      z-index: 2;
    }

    .article-card .card-cta-article:hover {
      text-decoration: underline;
    }

    /* Sidebar panel */
    .tldr-overlay {
      display: none;
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 1000;
      opacity: 0;
      transition: opacity 0.3s ease;
      overscroll-behavior: contain;
    }

    .tldr-overlay.active {
      display: block;
      opacity: 1;
    }

    .tldr-panel {
      position: fixed;
      top: 0;
      right: -480px;
      width: 480px;
      height: 100%;
      background: #1a1f2b;
      z-index: 1001;
      overflow-y: auto;
      overscroll-behavior: contain;
      transition: right 0.35s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: -8px 0 30px rgba(0,0,0,0.4);
    }

    .tldr-panel.active {
      right: 0;
    }

    .tldr-panel-header {
      position: sticky;
      top: 0;
      background: #222832;
      padding: 1rem 1.5rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
      z-index: 2;
      border-bottom: 1px solid rgba(255,255,255,0.06);
    }

    .tldr-panel-header .close-btn {
      background: none;
      border: none;
      color: #888;
      font-size: 1.5rem;
      cursor: pointer;
      padding: 0.3rem;
      line-height: 1;
    }

    .tldr-panel-header .close-btn:hover { color: var(--red); }

    .tldr-panel-header span {
      font-size: 0.7rem;
      font-weight: 700;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: var(--red);
    }

    .tldr-read-article {
      color: #F07C70;
      font-size: 0.65rem;
      font-weight: 700;
      text-decoration: none;
      letter-spacing: 0.5px;
      text-transform: uppercase;
      animation: heartbeat 3s ease-in-out infinite;
    }

    @keyframes heartbeat {
      0%, 80%, 100% { transform: scale(1); opacity: 0.85; }
      85% { transform: scale(1.12); opacity: 1; }
      90% { transform: scale(1); opacity: 0.85; }
      95% { transform: scale(1.08); opacity: 1; }
    }

    .tldr-panel-content {
      padding: 0;
      position: relative;
      height: calc(100vh - 56px);
    }

    .tldr-panel-content iframe {
      width: 100%;
      height: calc(100% - 52px);
      border: none;
    }

    .tldr-bottom-bar {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      padding: 1rem 1.5rem;
      background: linear-gradient(to top, rgba(26, 31, 43, 1) 60%, rgba(26, 31, 43, 0));
      color: var(--red);
      text-align: center;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.5px;
      text-decoration: none;
      display: block;
      padding-top: 2rem;
    }

    .tldr-bottom-bar span {
      display: inline-block;
      padding: 0.6rem 1.5rem;
      border: 1.5px solid var(--red);
      border-radius: 24px;
      transition: all 0.2s ease;
      animation: heartbeat 3s ease-in-out infinite;
    }

    .tldr-bottom-bar:hover span {
      background: var(--red);
      color: #fff;
      animation: none;
    }

    @media (max-width: 500px) {
      .tldr-panel { width: 100%; right: -100%; }
    }

    .article-card .card-langs {
      position: absolute;
      bottom: 1.2rem;
      right: 1.5rem;
      display: flex;
      gap: 0.3rem;
    }

    .article-card .card-langs .lang-pill {
      font-size: 0.55rem;
      font-weight: 700;
      letter-spacing: 0.5px;
      padding: 0.15rem 0.4rem;
      border-radius: 3px;
      background: rgba(201, 206, 216, 0.15);
      color: var(--lightgray);
    }

    .article-card .card-langs .lang-pill.available {
      background: rgba(240, 124, 112, 0.1);
      color: var(--red);
    }

    .article-card:hover .card-cta { text-decoration: none; }

    .article-card .card-cta-article:hover {
      text-decoration: underline;
    }

    .article-card.featured {
      background: var(--gray);
      border: 1px solid rgba(240, 124, 112, 0.3);
    }

    .article-card.featured .card-title { color: var(--white); font-size: 1.5rem; }
    .article-card.featured .card-abstract { color: var(--lightgray); }
    .article-card.featured::before { opacity: 1; }

    /* Latest badge */
    .badge-latest {
      display: inline-block;
      font-size: 0.55rem;
      font-weight: 700;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      background: var(--gray);
      color: #fff;
      padding: 0.2rem 0.5rem;
      border-radius: 4px;
      margin-left: 0.6rem;
      vertical-align: middle;
      animation: badge-glow 2s ease-in-out infinite;
    }

    @keyframes badge-glow {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.7; }
    }

    /* Latest card highlight */
    .article-card.latest {
      background: #fbedea;
      border: 1px solid rgba(240, 124, 112, 0.25);
      box-shadow: 0 6px 24px rgba(240, 124, 112, 0.12);
      animation: float 3s ease-in-out infinite;
    }

    .article-card.latest:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 35px rgba(240, 124, 112, 0.2);
      animation: none;
    }

    .article-card.latest::before { opacity: 1; }

    @keyframes float {
      0%, 100% { transform: translateY(0px); }
      50% { transform: translateY(-4px); }
    }

    /* Coming next card */
    .article-card.coming-next {
      background: rgba(240, 124, 112, 0.04);
      border: 1.5px dashed rgba(240, 124, 112, 0.3);
      cursor: default;
    }

    .article-card.coming-next:hover {
      transform: none;
      box-shadow: none;
    }

    .article-card.coming-next::before { display: none; }

    .article-card.coming-next .card-title {
      color: var(--lightgray);
      font-size: 1rem;
    }

    .article-card.coming-next .card-abstract {
      color: #666;
    }

    .coming-next-badge {
      display: inline-block;
      font-size: 0.55rem;
      font-weight: 600;
      letter-spacing: 1px;
      text-transform: uppercase;
      color: var(--red);
      border: 1px solid rgba(240, 124, 112, 0.4);
      padding: 0.15rem 0.5rem;
      border-radius: 4px;
      animation: pulse-border 2.5s ease-in-out infinite;
    }

    @keyframes pulse-border {
      0%, 100% { border-color: rgba(240, 124, 112, 0.4); opacity: 1; }
      50% { border-color: rgba(240, 124, 112, 0.15); opacity: 0.6; }
    }

    .loading-dots::after {
      content: '';
      animation: dots 1.5s steps(3, end) infinite;
    }

    @keyframes dots {
      0% { content: ''; }
      33% { content: '.'; }
      66% { content: '..'; }
      100% { content: '...'; }
    }

    .site-footer {
      text-align: center; padding: 2rem;
      font-size: 0.7rem; color: #555;
      border-top: 1px solid rgba(255,255,255,0.05);
    }

    @media (max-width: 600px) {
      .container { padding: 2rem 1rem; }
      .article-card { padding: 1.5rem; }
      .article-card .card-title { font-size: 1rem; }
      .article-card.featured .card-title { font-size: 1.2rem; }
    }
  </style>
</head>
<body>

  <div id="particles-canvas"></div>

  <header class="site-header">
    <img src="images/logos/Fortris-white-logo---dark-background.png" alt="Fortris">
    <h1>Platform <strong>Engineering</strong></h1>
    <div class="subtitle">Newsletter</div>
  </header>

  <main class="container">
HEADER

# Inject cards
echo "$CARDS" >> "$DIST/index.html"

cat >> "$DIST/index.html" <<'FOOTER'

  </main>

  <footer class="site-footer">
    Fortris · Infrastructure and Reliability · 2026
  </footer>

  <script>
  (function() {
    var script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js';
    script.onload = function() {
      particlesJS('particles-canvas', {
        "particles": {
          "number": { "value": 120, "density": { "enable": true, "value_area": 800 } },
          "color": { "value": "#C9CED8" },
          "shape": { "type": "circle", "stroke": { "width": 0, "color": "#000000" } },
          "opacity": { "value": 0.25, "random": false, "anim": { "enable": false, "speed": 1, "opacity_min": 0.1, "sync": false } },
          "size": { "value": 3, "random": true, "anim": { "enable": false, "speed": 40, "size_min": 0.1, "sync": false } },
          "line_linked": { "enable": true, "distance": 150, "color": "#C9CED8", "opacity": 0.18, "width": 0.7 },
          "move": { "enable": true, "speed": 0.2, "direction": "none", "random": true, "straight": false, "out_mode": "out", "attract": { "enable": false, "rotateX": 600, "rotateY": 1200 } }
        },
        "interactivity": {
          "detect_on": "canvas",
          "events": { "onhover": { "enable": true, "mode": "repulse" }, "onclick": { "enable": true, "mode": "push" }, "resize": true },
          "modes": { "grab": { "distance": 200, "line_linked": { "opacity": 0.6 } }, "bubble": { "distance": 400, "size": 40, "duration": 2, "opacity": 8, "speed": 3 }, "repulse": { "distance": 80 }, "push": { "particles_nb": 4 }, "remove": { "particles_nb": 2 } }
        },
        "retina_detect": true
      });
    };
    document.head.appendChild(script);
  })();
  </script>

  <!-- TLDR Sidebar Panel -->
  <div class="tldr-overlay" id="tldr-overlay" onclick="closeTldr()"></div>
  <div class="tldr-panel" id="tldr-panel">
    <div class="tldr-panel-header">
      <span>Quick Look</span>
      <button class="close-btn" onclick="closeTldr()">✕</button>
    </div>
    <div class="tldr-panel-content" id="tldr-panel-content"></div>
  </div>

  <script>
  function openTldr(basename) {
    var panel = document.getElementById('tldr-panel');
    var overlay = document.getElementById('tldr-overlay');
    var content = document.getElementById('tldr-panel-content');
    var header = document.querySelector('.tldr-panel-header');
    // Lock body scroll
    document.body.style.overflow = 'hidden';
    // Reset header
    header.innerHTML = '<span>Quick Look</span>' +
      '<button class="close-btn" onclick="closeTldr()">✕</button>';
    content.innerHTML = '<iframe src="tldr/' + basename + '_tldr.html"></iframe>' +
      '<a href="viewer.html?pdf=pdfs/' + basename + '.pdf" class="tldr-bottom-bar"><span>Want the full story? →</span></a>';
    setTimeout(function() {
      overlay.classList.add('active');
      panel.classList.add('active');
    }, 10);
  }

  function closeTldr() {
    document.getElementById('tldr-panel').classList.remove('active');
    document.getElementById('tldr-overlay').classList.remove('active');
    // Unlock body scroll
    document.body.style.overflow = '';
    setTimeout(function() {
      document.getElementById('tldr-panel-content').innerHTML = '';
    }, 350);
  }

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeTldr();
  });
  </script>

</body>
</html>
FOOTER

echo "  ✓ index.html generated"

# ============================================================================
# Copy viewer (static, no generation needed)
# ============================================================================
# Copy viewer (static template)
cp viewer.html "$DIST/viewer.html" 2>/dev/null || echo "  ⚠ viewer.html missing"

# Generate TLDRs from _tldr.md files
echo "  → generating TLDRs"
mkdir -p "$DIST/tldr"
for md in 20*/*_tldr.md; do
  [ -f "$md" ] || continue
  TLDR_OUT="$DIST/tldr/$(basename "$md" .md).html"
  sh generate_tldr.sh "$md" > /dev/null 2>&1
  # Move generated html to dist/tldr/
  GENERATED=$(echo "$md" | sed 's/\.md$/.html/')
  if [ -f "$GENERATED" ]; then
    mv "$GENERATED" "$TLDR_OUT"
    echo "    ✓ $(basename "$TLDR_OUT")"
  fi
done

# Generate SHA256 checksums for all PDFs
echo "  → generating checksums"
(cd "$DIST/pdfs" && sha256sum *.pdf > ../checksums.sha256 2>/dev/null || shasum -a 256 *.pdf > ../checksums.sha256)
echo "  ✓ checksums.sha256 generated"

echo ""
echo "═══ Done ═══"
echo "Open: open $DIST/index.html"
