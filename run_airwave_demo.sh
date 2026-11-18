#!/bin/bash
# Project: shibuya-airwave-ghost | Autumn Momiji HUD & Pop-Up Video Demo Runner
# プロジェクト: 渋谷エアウェーブ・ゴースト | 紅葉（モミジ）HUD・ポップアップデモランチャー

MODE="${1:---demo}"
INTERFACE="wlp2s0"
MON_IFACE="${INTERFACE}mon"

# Allow root to open GUI terminal windows on the live desktop
export DISPLAY=:0
xhost +local:root >/dev/null 2>&1

# Auto-detect installed GUI terminal emulator in Parrot OS
if command -v mate-terminal >/dev/null 2>&1; then
    TERM_CMD="mate-terminal"
elif command -v qterminal >/dev/null 2>&1; then
    TERM_CMD="qterminal"
elif command -v xfce4-terminal >/dev/null 2>&1; then
    TERM_CMD="xfce4-terminal"
else
    TERM_CMD="x-terminal-emulator"
fi

# Helper function to spawn a visible pop-up terminal window
spawn_popup() {
    local title="$1"
    local geom="$2"
    local cmd="$3"

    if [ "$TERM_CMD" == "mate-terminal" ]; then
        mate-terminal --geometry="$geom" --title="$title" -e "bash -c '$cmd; exec bash'" &
    elif [ "$TERM_CMD" == "qterminal" ]; then
        qterminal -e bash -c "echo -ne '\033]0;$title\007'; $cmd; exec bash" &
    elif [ "$TERM_CMD" == "xfce4-terminal" ]; then
        xfce4-terminal --geometry="$geom" --title="$title" -e "bash -c '$cmd; exec bash'" &
    else
        x-terminal-emulator -e bash -c "$cmd; exec bash" &
    fi
}

# Autumn Palette (256-Color ANSI)
CRIMSON="\033[38;5;160m"
ORANGE="\033[38;5;208m"
AMBER="\033[38;5;214m"
GOLD="\033[38;5;220m"
RUST="\033[38;5;166m"
CREAM="\033[38;5;223m"
RESET="\033[0m"

autumn_bar() {
    local duration=$1
    local label=$2
    local width=34
    local spinners=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    
    tput civis
    for ((i=0; i<=width; i++)); do
        local pct=$(( i * 100 / width ))
        local sync=$(( i * 400 / width ))
        local spin=${spinners[$((i % 10))]}
        
        if [ $pct -lt 25 ]; then
            COLOR="$CRIMSON"
        elif [ $pct -lt 55 ]; then
            COLOR="$ORANGE"
        elif [ $pct -lt 85 ]; then
            COLOR="$AMBER"
        else
            COLOR="$GOLD"
        fi

        local filled=$(printf "%${i}s" | tr ' ' '▰')
        local empty=$(printf "%$((width - i))s" | tr ' ' '▱')
        
        printf "\r${RUST}%s${RESET} ${COLOR}%s%s${RESET} ${CREAM}%3d%%${RESET} ${AMBER}[SYNC:%3d%%]${RESET} %s" \
            "$spin" "$filled" "$empty" "$pct" "$sync" "$label"
        sleep "$duration"
    done
    echo -e " ${GOLD}🍁 [ONLINE]${RESET}"
    tput cnorm
}

cleanup() {
    tput cnorm
    echo -e "\n${ORANGE}[!] Closing pop-ups & restoring Wi-Fi on $INTERFACE / 画面終了とWi-Fi復元中...${RESET}"
    sudo airmon-ng stop "$MON_IFACE" >/dev/null 2>&1
    sudo ip link set "$INTERFACE" up >/dev/null 2>&1
    sudo systemctl restart NetworkManager >/dev/null 2>&1
    echo -e "${GOLD}[+] Network restored cleanly / ネットワーク接続を正常に復元しました。${RESET}"
}

trap cleanup EXIT INT TERM

clear
echo -e "${RUST}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${RUST}║${RESET} ${GOLD}🍁 PROJECT JP VIOLET SYNAPSE // SHIBUYA-AIRWAVE-GHOST (PT0-003)${RESET}            ${RUST}║${RESET}"
echo -e "${RUST}║${RESET} ${CREAM}   渋谷エアウェーブ・ゴースト — 無線LAN・Bluetooth・パスワード解析ライブ${RESET}   ${RUST}║${RESET}"
echo -e "${RUST}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo -e " ${AMBER}[*] INTERFACE:${RESET} ${CREAM}$INTERFACE${RESET}   ${AMBER}[*] TERMINAL:${RESET} ${CREAM}$TERM_CMD${RESET}   ${AMBER}[*] MODE:${RESET} ${CREAM}$MODE${RESET}\n"

# 1. Wi-Fi Recon Pop-Up
autumn_bar 0.04 "LINKING WI-FI MONITOR ($MON_IFACE)"
if [ "$MODE" == "--live" ]; then
    sudo airmon-ng check kill >/dev/null 2>&1
    sudo airmon-ng start "$INTERFACE" >/dev/null 2>&1
    spawn_popup "AIRODUMP-NG // LIVE WI-FI MONITOR ($MON_IFACE)" "90x22+40+40" "sudo airodump-ng $MON_IFACE"
else
    spawn_popup "AIRODUMP-NG // WI-FI RECON PREVIEW" "90x22+40+40" "echo -e \"\033[38;5;208m[🍁] AIRODUMP-NG SPECTRUM ENGINE ($MON_IFACE)\033[0m\"; airodump-ng --help | head -n 22"
fi
sleep 1.5

# 2. Bluetooth LE Pop-Up
autumn_bar 0.04 "INJECTING BLE SCANNER (bluetoothctl)"
spawn_popup "BLUETOOTHCTL // BLE & RF RECON" "90x22+660+40" "echo -e \"\033[38;5;214m[🍁] SCANNING BLE SPECTRUM / Bluetoothデバイス探索...\033[0m\"; timeout 12 bluetoothctl scan on || bluetoothctl devices"
sleep 1.5

# 3. Hashcat Pop-Up
autumn_bar 0.04 "ARMING HASHCAT GPU/CPU CRACKER (-m 22000)"
spawn_popup "HASHCAT // WPA2-EAPOL (-m 22000) ENGINE" "90x22+40+460" "echo -e \"\033[38;5;160m[🍁] HASHCAT CRACKING BENCHMARK (-m 22000)...\033[0m\"; hashcat -m 22000 -b --force 2>/dev/null || hashcat --version"
sleep 1.5

# 4. BloodHound Pop-Up
autumn_bar 0.04 "SYNCING BLOODHOUND GRAPH (AD/WIRELESS)"
spawn_popup "BLOODHOUND // AD & WIRELESS PIVOT GRAPH" "90x22+660+460" "echo -e \"\033[38;5;220m[🍁] INITIALIZING BLOODHOUND ATTACK GRAPH...\033[0m\"; which bloodhound >/dev/null && bloodhound --no-sandbox || echo \"[!] BloodHound GUI ready (run: sudo neo4j start && bloodhound --no-sandbox)\""
sleep 1.5

# 5. Main HUD Execution
autumn_bar 0.045 "EXECUTING PHISHING & BLUE-TEAM HARDENING"
echo ""
python3 /home/live/development/shibuya-airwave-ghost/04-social-engineering/gophish_sim.py
echo ""
python3 /home/live/development/shibuya-airwave-ghost/05-perimeter-hardening/harden_airwave.py

echo ""
autumn_bar 0.025 "ALL SHIBUYA-AIRWAVE-GHOST SYSTEMS NOMINAL"
echo ""
read -p "[?] Recording complete? Press [ENTER] to close demo & restore Wi-Fi / 録画完了後 Enter で終了: "
