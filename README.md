# ============================================================
#                       URL FILE INPUT
# ============================================================

echo
echo -ne "${MAGENTA}${BOLD}[?] ENTER URL FILE → ${RESET}"
read -r URL_FILE

if [[ -z "$URL_FILE" || ! -f "$URL_FILE" ]]; then
    echo -e "${RED}${BOLD}[✗] File not found.${RESET}"
    exit 1
fi

echo -e "${GREEN}${BOLD}[✓] Reading URLs from: ${URL_FILE}${RESET}"

# Read each URL from the file
while IFS= read -r TARGET || [[ -n "$TARGET" ]]; do

    # Skip empty lines
    [[ -z "$TARGET" ]] && continue

    # Skip comments
    [[ "$TARGET" == \#* ]] && continue

    # Add HTTPS if no scheme was supplied
    if [[ "$TARGET" != http://* && "$TARGET" != https://* ]]; then
        TARGET="https://$TARGET"
    fi

    # Remove trailing slash
    TARGET="${TARGET%/}"

    # Basic validation
    if [[ ! "$TARGET" =~ ^https?://[^[:space:]]+$ ]]; then
        echo -e "${RED}[✗] Skipping invalid URL: ${TARGET}${RESET}"
        continue
    fi

    echo
    echo -e "${CYAN}${BOLD}[~] Processing: ${TARGET}${RESET}"

    # Create a separate output file for each target
    TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
    SAFE_NAME=$(echo "$TARGET" | sed 's#https\?://##; s#[^a-zA-Z0-9._-]#_#g')
    OUTPUT_FILE="${OUTPUT_DIR}/${SAFE_NAME}_${TIMESTAMP}.txt"
    TEMP_FILE=$(mktemp)

    if curl \
        --silent \
        --show-error \
        --location \
        --max-time 20 \
        --user-agent "ViperFinder/1.0" \
        "$TARGET" > "$TEMP_FILE"; then

        grep -Eoi \
            'href=["'\''][^"'\'']+["'\'']' \
            "$TEMP_FILE" 2>/dev/null |
            sed -E 's/^href=["'\'']//; s/["'\'']$//' |
            sed '/^#/d' |
            sed '/^javascript:/Id' |
            sed '/^mailto:/Id' |
            sed '/^tel:/Id' |
            sort -u > "$OUTPUT_FILE"

        if [[ -s "$OUTPUT_FILE" ]]; then
            COUNT=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')

            echo -e "${GREEN}${BOLD}[✓] Found ${COUNT} URLs${RESET}"
            echo -e "${MAGENTA}    Saved to: ${OUTPUT_FILE}${RESET}"
        else
            echo -e "${YELLOW}[!] No links found.${RESET}"
            rm -f "$OUTPUT_FILE"
        fi

    else
        echo -e "${RED}${BOLD}[✗] Failed to fetch: ${TARGET}${RESET}"
        rm -f "$OUTPUT_FILE"
    fi

    rm -f "$TEMP_FILE"

done < "$URL_FILE"

echo
echo -e "${GREEN}${BOLD}🐍 VIPER FINDER — FINISHED 🐍${RESET}"
