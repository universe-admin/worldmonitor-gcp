#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Universe Monitor — instance patch (build-time reskin + rebrand)
#
# Applied by Cloud Build to the cloned upstream app (koala73/worldmonitor) BEFORE
# docker build. Run with the app checkout as the working directory. Keeps us
# fork-free: every rebuild reapplies this over fresh upstream source. Each step
# no-ops if its target is absent, so it survives upstream drift.
#
# Only the human-facing display name "World Monitor" is renamed — lowercase
# `worldmonitor`, the `worldmonitor.app` domains, and `WORLDMONITOR_*`
# identifiers are left untouched so nothing in code/config breaks.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

LINKEDIN="https://www.linkedin.com/in/shivashish-borah/"
GH_REPO="github.com/universe-admin/worldmonitor-gcp"

echo "[patch] 1/3 rebrand text (name / author / handle / github / profile link)"

# Each replace is guarded with `|| true` so a no-match grep (exit 1) can't abort
# the script under `set -e` and leave a half-applied patch.

# Display name — capitalized, space-separated only.
grep -rlZ --include='*.ts' --include='*.tsx' --include='*.html' --include='*.json' --include='*.css' \
  'World Monitor' . 2>/dev/null | xargs -0 -r sed -i 's/World Monitor/Universe Monitor/g' || true

# Author name + visible social handle.
grep -rlZ 'Elie Habib' . 2>/dev/null | xargs -0 -r sed -i 's/Elie Habib/Shivashish Borah/g' || true
grep -rlZ '@eliehabib' . 2>/dev/null | xargs -0 -r sed -i 's/@eliehabib/@ShivashishBorah/g' || true

# Author profile link (href + JSON-LD sameAs) -> LinkedIn.
grep -rlZ 'eliehabib' . 2>/dev/null | xargs -0 -r sed -i \
  "s|https://x\.com/eliehabib|${LINKEDIN}|g; s|https://twitter\.com/eliehabib|${LINKEDIN}|g" || true

# GitHub links -> our deployment repo (leaves third-party github.com/* alone).
grep -rlZ 'github.com/koala73' . 2>/dev/null | xargs -0 -r sed -i \
  "s|github\.com/koala73/worldmonitor|${GH_REPO}|g; s|github\.com/koala73|github.com/universe-admin|g" || true

echo "[patch] 2/3 inject Universe Monitor theme into index.html"

# Cosmic indigo/violet palette overriding the app's :root custom properties.
# !important on custom properties wins regardless of stylesheet load order, so
# this is robust without touching any component CSS. No external assets/fonts.
cat > /tmp/uvm-theme.html <<'THEME'
    <!-- Universe Monitor instance theme (build-time reskin) -->
    <style id="universe-monitor-theme">
      :root {
        --bg:#05060f !important; --bg-secondary:#0a0c1a !important;
        --surface:#0f1230 !important; --surface-hover:#181c46 !important; --surface-active:#221f5c !important;
        --border:#262a55 !important; --border-strong:#3d3f79 !important; --border-subtle:#161936 !important;
        --text:#e9ecff !important; --text-secondary:#c3c7ee !important; --text-dim:#8b8fc7 !important;
        --accent:#8b7bff !important;
        --panel-bg:#0f1230 !important; --panel-border:#262a55 !important; --input-bg:#141637 !important;
        --scrollbar-thumb:#2c2f63 !important; --scrollbar-thumb-hover:#4a4d97 !important;
        --map-bg:#04030c !important; --map-grid:#1b1650 !important; --map-country:#0c0a2c !important; --map-stroke:#4b3fbf !important;
        --font-body-base:'Inter','Segoe UI',system-ui,-apple-system,'Helvetica Neue',sans-serif !important;
      }
      body { background:radial-gradient(1200px 820px at 72% -12%, #161d55 0%, #07070f 58%) fixed, #05060f !important; }
      ::selection { background:#5a4bd6; color:#fff; }
      /* Remove the community "open Discord channel" invite link(s) */
      a[href*="discord.gg"] { display:none !important; }
    </style>
THEME

# Insert the theme just before </head> (awk avoids sed delimiter issues with the CSS).
awk 'FNR==NR { t = t $0 ORS; next }
     /<\/head>/ && !done { printf "%s", t; done = 1 }
     { print }' /tmp/uvm-theme.html index.html > index.html.uvm && mv index.html.uvm index.html

echo "[patch] 3/3 summary"
echo "  Universe Monitor occurrences in index.html: $(grep -c 'Universe Monitor' index.html || true)"
echo "  theme block present: $(grep -c 'universe-monitor-theme' index.html || true)"
echo "  linkedin refs: $(grep -rl 'linkedin.com/in/shivashish-borah' . 2>/dev/null | wc -l)"
echo "  remaining x.com/eliehabib: $(grep -rl 'x.com/eliehabib' . 2>/dev/null | wc -l)"
echo "[patch] done"
