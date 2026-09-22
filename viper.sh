#!/usr/bin/env bash

# ============================================================
#                    🐍 VIPER FINDER 🐍
#                     URL FINDER TOOL
# ============================================================

# -------------------- COLORS --------------------

BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
MAGENTA='\033[95m'
CYAN='\033[96m'
WHITE='\033[97m'

# -------------------- INTERRUPT --------------------

trap 'echo -e "\n${RED}${BOLD}[!] VIPER FINDER INTERRUPTED.${RESET}"; exit 130' INT

clear

# ============================================================
#                    LARGE VIPER BANNER
# ============================================================

echo -e "${GREEN}${BOLD}"

cat << 'EOF'
██╗   ██╗██╗██████╗ ███████╗██████╗
██║   ██║██║██╔══██╗██╔════╝██╔══██╗
██║   ██║██║██████╔╝█████╗  ██████╔╝
╚██╗ ██╔╝██║██╔═══╝ ██╔══╝  ██╔══██╗
 ╚████╔╝ ██║██║     ███████╗██║  ██║
  ╚═══╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
EOF

echo -e "${CYAN}${BOLD}"

cat << 'EOF'
███████╗██╗███╗   ██╗██████╗ ███████╗██████╗
██╔════╝██║████╗  ██║██╔══██╗██╔════╝██╔══██╗
█████╗  ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝
██╔══╝  ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗
██║     ██║██║ ╚████║██████╔╝███████╗██║  ██║
╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝
EOF

echo -e "${RESET}"

echo -e "${YELLOW}${BOLD}"
echo "                    🐍 VIPER FINDER 🐍"
echo "                       URL FINDER"
echo -e "${RESET}"

echo -e "${MAGENTA}${BOLD}"
echo "════════════════════════════════════════════════════════════════════"
echo -e "${RESET}"

# ============================================================
#                    DEPENDENCY CHECK
# ============================================================

if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED}${BOLD}[✗] curl is not installed.${RESET}"
    echo -e "${YELLOW}Install curl and try again.${RESET}"
    exit 1
fi

echo -e "${GREEN}${BOLD}[✓] curl detected${RESET}"

# ============================================================
#                       URL INPUT
# ============================================================

echo
echo -ne "${MAGENTA}${BOLD}[?] ENTER TARGET URL → ${RESET}"
read -r TARGET

# Add HTTPS if no scheme was supplied
if [[ "$TARGET" != http://* && "$TARGET" != https://* ]]; then
    TARGET="https://$TARGET"
fi

# Remove trailing slash
TARGET="${TARGET%/}"

# ============================================================
#                       BASIC VALIDATION
# ============================================================

if [[ -z "$TARGET" ]]; then
    echo -e "${RED}${BOLD}[✗] No URL entered.${RESET}"
    exit 1
fi

if [[ ! "$TARGET" =~ ^https?://[^[:space:]]+$ ]]; then
    echo -e "${RED}${BOLD}[✗] Invalid URL format.${RESET}"
    exit 1
fi

# ============================================================
#                     OUTPUT SETUP
# ============================================================

OUTPUT_DIR="results"
mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
OUTPUT_FILE="${OUTPUT_DIR}/urls_${TIMESTAMP}.txt"
TEMP_FILE=$(mktemp)

# ============================================================
#                         SCAN INFO
# ============================================================

echo
echo -e "${CYAN}${BOLD}"
echo "┌────────────────────────────────────────────────────────────────────┐"
echo "│                         VIPER TARGET                              │"
echo "├────────────────────────────────────────────────────────────────────┤"
echo -e "│ ${WHITE}Target     :${RESET} ${GREEN}${TARGET}${CYAN}                    │"
echo -e "│ ${WHITE}Engine     :${RESET} ${YELLOW}curl${CYAN}                                   │"
echo -e "│ ${WHITE}Output     :${RESET} ${MAGENTA}${OUTPUT_FILE}${CYAN}       │"
echo -e "│ ${WHITE}Started    :${RESET} ${DIM}$(date '+%Y-%m-%d %H:%M:%S')${CYAN}                  │"
echo "└────────────────────────────────────────────────────────────────────┘"
echo -e "${RESET}"

# ============================================================
#                     DOWNLOAD PAGE
# ============================================================

START_TIME=$(date +%s)

echo
echo -ne "${YELLOW}${BOLD}[~] FETCHING PAGE"

for _ in {1..5}; do
    sleep 0.15
    echo -ne "."
done

echo -e "${RESET}"
echo

if ! curl \
    --silent \
    --show-error \
    --location \
    --max-time 20 \
    --user-agent "ViperFinder/1.0" \
    "$TARGET" > "$TEMP_FILE"; then

    rm -f "$TEMP_FILE"

    echo -e "${RED}${BOLD}[✗] Failed to fetch target URL.${RESET}"
    exit 1
fi

# ============================================================
#                       EXTRACT LINKS
# ============================================================

echo -e "${BLUE}${BOLD}[~] EXTRACTING LINKS...${RESET}"

grep -Eoi \
    'href=["'\''][^"'\'']+["'\'']' \
    "$TEMP_FILE" 2>/dev/null |
    sed -E 's/^href=["'\'']//; s/["'\'']$//' |
    sed '/^#/d' |
    sed '/^javascript:/Id' |
    sed '/^mailto:/Id' |
    sed '/^tel:/Id' |
    sort -u > "$OUTPUT_FILE"

rm -f "$TEMP_FILE"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

# ============================================================
#                     RESULT CHECK
# ============================================================

if [[ ! -s "$OUTPUT_FILE" ]]; then
    echo
    echo -e "${RED}${BOLD}[✗] No links found.${RESET}"
    rm -f "$OUTPUT_FILE"
    exit 0
fi

COUNT=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')

# ============================================================
#                      DISPLAY RESULTS
# ============================================================

echo
echo -e "${GREEN}${BOLD}"
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                     🐍 FOUND URLS 🐍                             ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

INDEX=1

while IFS= read -r URL; do

    if (( INDEX % 2 == 0 )); then
        COLOR="$CYAN"
    else
        COLOR="$WHITE"
    fi

    printf "  ${GREEN}${BOLD}%4d${RESET} ${YELLOW}➜${RESET} ${COLOR}%s${RESET}\n" \
        "$INDEX" "$URL"

    ((INDEX++))

done < "$OUTPUT_FILE"

# ============================================================
#                         SUMMARY
# ============================================================

echo
echo -e "${MAGENTA}${BOLD}"
echo "════════════════════════════════════════════════════════════════════"
echo -e "${RESET}"

echo -e "${GREEN}${BOLD}"
echo "                    🐍 VIPER FINDER COMPLETE"
echo -e "${RESET}"

echo
echo -e "${WHITE}${BOLD}  TARGET       :${RESET} ${CYAN}${TARGET}${RESET}"
echo -e "${WHITE}${BOLD}  URLS FOUND   :${RESET} ${GREEN}${COUNT}${RESET}"
echo -e "${WHITE}${BOLD}  TIME         :${RESET} ${YELLOW}${ELAPSED}s${RESET}"
echo -e "${WHITE}${BOLD}  SAVED TO     :${RESET} ${MAGENTA}${OUTPUT_FILE}${RESET}"

echo
echo -e "${MAGENTA}${BOLD}"
echo "════════════════════════════════════════════════════════════════════"
echo -e "${RESET}"

echo -e "${CYAN}${BOLD}"
echo "                🐍 VIPER FINDER — FINISHED 🐍"
echo -e "${RESET}"

echo
